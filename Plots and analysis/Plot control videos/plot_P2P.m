function plot_P2P()     
    
    tempDataPath = strcat(fileparts(mfilename('fullpath')),'\');  
    frameNumber = 0;
    lastFrameRepeat = 0;
    makeVideo = 0;
    everyNthFrame = 5;
    downSampling = 0;
    pdfFrames = [1, 2000, 2919];
    idxForPdf = 1;
    cropWidth = 500;
    cropOrg = [986 262];
%     coordinateMult = 1;
%     coordinateOrg = [0.25 -0.15];    
    coordinateMult = 2.5;
    coordinateOrg = [0.25 0.3750];   
    
    f = figure(1);
    set(f, 'Position', [100, 100, 700, 700]);                
    axes('position', [0 0 1 1]);
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[]);  
%     % Read trail data
%     trail_table = readtable('steps.txt');
%     trail_mat = str2double(table2array(trail_table(:,1)));
%     trail_mat(isnan(trail_mat)) = [];
%     data(:,1) = trail_mat(1:2:end-1);
%     data(:,2) = trail_mat(2:2:end);
%     data = data - coordinateOrg;
%     data = coordinateMult * data;
    data = [];
    % Read target data
    t = table2array(readtable('path.txt'));
    t(:,2) = 1 - t(:,2);
    t = t - t(6,:);
    t = coordinateMult * t;
    t = t + coordinateOrg;
    vidObj = VideoReader('rect_raw.mp4');
    lastFrame = ceil(vidObj.FrameRate*vidObj.Duration);
    dumpFrames = round(linspace(1,lastFrame,5));
    
    if (makeVideo)
        v = VideoWriter(sprintf('%srect_raw_m.mp4',tempDataPath));
        open(v);
        set(f, 'Position', [100, 100, 720, 720]);                
    end
      
    processVideo('rect_raw.mp4',@processFrame);        
    
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
                
        frame = imcrop(frame,[cropOrg cropWidth cropWidth]);
        gf = double(rgb2gray(frame))/255;                  
        
        if (makeVideo)
            imshow(gf);
        else
            imshow(1 - gf);        
        end
        imgSize = size(gf);
        hold on;                
                     
        co = [0.7 0.5 0];
        
        ret = findBlobs(gf);
        
        if (isempty(ret))
            data(frameNumber,:) = data(frameNumber - 1,:);
        end
        data = [data; ret];

        MarkerSize = 35;
        
        d1 = sqrt((data(1:frameNumber,1) - data(frameNumber,1)) .^ 2 +...
            (data(1:frameNumber,2) - data(frameNumber,2)) .^ 2);            
        ind = d1 > 15;

        if downSampling
            for j = 1:size(ind,1)  % Down sampling the data
                if mod(j,everyNthFrame) ~= 1
                    ind(j) = 0;
                end
            end
        end

%         plot(data(ind,1)*imgSize(2),data(ind,2)*imgSize(1),...
%             'b.','MarkerSize',7);
        plot(data(ind,1),data(ind,2),'b.','MarkerSize',7);
 
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
        hp = plot(data(frameNumber,1),data(frameNumber,2),...
            pType,'LineWidth',2,'MarkerSize',MarkerSize); 
        
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
    
    function ret = findBlobs(bw)        
        s = regionprops(bw,'centroid','FilledArea');
        centroids = cat(1, s.Centroid);
        areas = cat(1, s.FilledArea);
        ind = 20 < areas & areas < 100;
        ret = centroids(ind,:);      
    end    
    
    function p = line(sx,sy,ex,ey,n)
       d = (1:n)' / n;
       x = (ex-sx) * d + sx;
       y = (ey-sy) * d + sy;
       p = [x y];
    end
            
end