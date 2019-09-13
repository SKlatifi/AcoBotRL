function [coordinates,angle,data] = plot_P2P()     
    
    tempDataPath = getTempDataPath();  
    videoPath = strcat(tempDataPath,'video_analysis\');
    frameNumber = 0;
    lastFrameRepeat = 0;
    makeVideo = 0;
    everyNthFrame = 5;
    downSampling = 0;
    pdfFrames = [1, 190, 820];
    idxForPdf = 1;
    coordinates = zeros(2,2);
    angle = 0;
    n_particle = 3;
    
    f = figure(1);
    set(f, 'Position', [100, 100, 700, 700]);                
    axes('position', [0 0 1 1]);
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[]);  
    data = [];
    
    t = [0.5 0.25; 0.3 0.7; 0.7 0.7];
    vidObj = VideoReader(strcat(videoPath,'triple_50000.wmv'));
    lastFrame = ceil(vidObj.FrameRate*vidObj.Duration);
    dumpFrames = round(linspace(1,lastFrame,5));
    
    if (makeVideo)
        v = VideoWriter(sprintf('%striple_50000_m',videoPath),'MPEG-4');
        open(v);
        set(f, 'Position', [100, 100, 720, 720]);                
    end
      
    processVideo(strcat(videoPath,'triple_50000.wmv'),@processFrame);        
    
    if (makeVideo)        
        close(v);
    end
    
    function processFrame(frame)
        
        if makeVideo
            if (frameNumber == lastFrame)
                 lastFrameRepeat = lastFrameRepeat + 1;
                 if (lastFrameRepeat <= 5)
                    frameNumber = frameNumber - 1;
                 end
            end
        end
        
        frameNumber = frameNumber +1;
        
        if downSampling
            if (frameNumber ~= lastFrame)
                if (mod(frameNumber,everyNthFrame) ~= 1) || (frameNumber > lastFrame) % Down sampling the video
                    return;
                end
            end
        end
        
        if frameNumber == 1
            load('data_start_triple.mat');
            t = data_p(end-n_particle+1:end,:);  
%             [coordinates,angle] = im_calibrate(frame);
        end            

        frame_rotated = imrotate(frame,-angle);        
        frame = frame_rotated(coordinates(1,2):coordinates(2,2),...
            coordinates(1,1):coordinates(2,1),:);                        
        gf = double(rgb2gray(frame))/255;                  
        
        if (makeVideo)
            imshow(gf);
        else
            imshow(1 - gf);        
        end
        imgSize = size(gf);
        
        if frameNumber == 1
            t = [t(:,1)/imgSize(2),t(:,2)/imgSize(1)]; 
        end
       
        hold on;                                     
        co = [0.7 0.5 0];
        
        ret = findBlobs(gf);        
        
        if (isempty(ret))
            data(end+1:end+n_particle,:) = data(end-n_particle+1:end,:);
        end
        data = [data; ret];

        MarkerSize = 20;
                
%         idx = zeros(length(data),n_particle);
        for h = 1:n_particle
            d1 = sqrt((data(1:end,1) - data(end-n_particle+h,1)) .^ 2 +...
            (data(1:end,2) - data(end-n_particle+h,2)) .^ 2); 
            idx(:,h) = d1 > 15;
        end
        
        ind = idx(:,1) & idx(:,2) & idx(:,3);
                
        plot(data(ind,1),data(ind,2),'b.','MarkerSize',7);

        if downSampling
            for j = 1:size(ind,1)  % Down sampling the data
                if mod(j,everyNthFrame) ~= 1
                    ind(j) = 0;
                end
            end
        end

        dt = sqrt((t(:,1)*imgSize(2) - data(frameNumber,1)) .^ 2 +...
            (t(:,2)*imgSize(1) - data(frameNumber,2)) .^ 2);            
        indT = dt > 0;  % For disappearing the target points: indT = dt > 0.022;

        if makeVideo
            plot(t(indT,1)*imgSize(2),t(indT,2)*imgSize(1),'r+','MarkerSize',20,'LineWidth',2);                
        else
            plot(t(indT,1)*imgSize(2),t(indT,2)*imgSize(1),'+','MarkerSize',20,'LineWidth',2,'Color',co);                
        end

        colorType = 'b';            
        pType = sprintf('%so',colorType);                       
%         hp = plot(data(frameNumber,1)*imgSize(2),data(frameNumber,2)*imgSize(1),...   
%                 pType,'LineWidth',2,'MarkerSize',MarkerSize); 
               
        for x = 1:n_particle
            hp = plot(data((frameNumber-1)*n_particle+x,1),...
                data((frameNumber-1)*n_particle+x,2),...
                pType,'LineWidth',2,'MarkerSize',MarkerSize); 
        end
        
        if makeVideo
                ht = plot(-1,-1,'r+','MarkerSize',20,'LineWidth',2);                
            else
                ht = plot(-1,-1,'+','MarkerSize',20,'LineWidth',2,'Color',co);                
        end
                                 
        if (makeVideo == 1) || ((makeVideo == 0) && (frameNumber < 10))  
            [hl,hobj] = legend([hp,ht],{'Particle','Target'},'Position',[0.6 0.75 0.4 0.2]);               
            legend('boxoff');
            set(hl,'FontSize',30);            
            hobj(1).FontSize = 24;            
            hobj(2).FontSize = 24;               
            if (makeVideo)                
                hobj(1).Color = [1 1 1];
                hobj(2).Color = [1 1 1];                
            end
        end
        hold off;        
        
        if (makeVideo == 0) && (frameNumber == pdfFrames(idxForPdf))
            export_fig(sprintf('%sz_%d.pdf',tempDataPath,frameNumber));
            idxForPdf = idxForPdf + 1;
        end
        
        if (makeVideo)
            F = getframe(gca);
            writeVideo(v,F);
        end
    end
    close all;
    
    function ret = findBlobs(gf)  
        original = adaptiveThreshold(gf,5);       
        filled = imfill(original, 'holes');
        holes = filled & ~original;
        bigholes = bwareaopen(holes, 40);
        smallholes = holes & ~bigholes;
        bw = original | smallholes;
        s = regionprops(logical(bw),'centroid','FilledArea','Eccentricity');
        centroids = cat(1, s.Centroid);
        areas = cat(1, s.FilledArea);
        eccs = cat(1, s.Eccentricity);
        ind = 80 < areas & areas < 400 & eccs < 0.9;    
        ret = centroids(ind,:);   
    end                
end