function plot_RFID6()     
    
    tempDataPath = getTempDataPath();
    frameNumber = 0;
    lastFrameRepeat = 0;
    makeVideo = 1;
    everyNthFrame = 5;
    
    f = figure(1);
    set(f, 'Position', [100, 100, 700, 700]);                
    axes('position', [0 0 1 1]);
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[]);
    data = csvread('C:\Users\X230\Documents\AcoLabControl\results\RFID6\RFID6.txt'); 
    lastFrame = FindLastFrame();
    dumpFrames = round(linspace(1,lastFrame,10));
    
    if (makeVideo)
        v = VideoWriter(sprintf('%sRFID6_m.avi',tempDataPath));
        open(v);
        set(f, 'Position', [100, 100, 720, 720]);                
    end
      
    processVideoRFID('RFID6.avi',@processFrame);        
    
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
        
        if (frameNumber ~= lastFrame)
            if (mod(frameNumber,everyNthFrame) ~= 1) || (frameNumber > lastFrame) % Down sampling the video
                return;
            end
        end
        
        gf = double(rgb2gray(frame))/255;                  
        
        if (makeVideo)
            imshow(gf);
        else
            imshow(1 - gf);        
        end
        imgSize = size(gf);
        hold on;
        
        t = line(0.1,0.6650,0.85,0.6650,20);
                     
        co = [0.7 0.5 0];
        
        for m = 1:6
            MarkerSize = 22;
            d1 = sqrt((data(1:frameNumber,13+m) - data(frameNumber,13+m)) .^ 2 +...
                (data(1:frameNumber,19+m) - data(frameNumber,19+m)) .^ 2);            
            ind = d1 > 0.022;
            
            for j = 1:size(ind,1)  % Down sampling the data
                if mod(j,everyNthFrame) ~= 1
                    ind(j) = 0;
                end
            end
            
            plot(data(ind,13+m)*imgSize(2),data(ind,19+m)*imgSize(1),...
                'b.','MarkerSize',7);
            
            dt = sqrt((t(:,1) - data(frameNumber,13+m)) .^ 2 +...
                (t(:,2) - data(frameNumber,19+m)) .^ 2);            
            indT = dt > 0.022; 
            
            if makeVideo
                plot(t(indT,1)*imgSize(2),t(indT,2)*imgSize(1),'r+','MarkerSize',8,'LineWidth',2);                
            else
                plot(t(indT,1)*imgSize(2),t(indT,2)*imgSize(1),'+','MarkerSize',8,'LineWidth',2,'Color',co);                
            end
            
            colorType = 'k';            
            pType = sprintf('%so',colorType);                       
            hp = plot(data(frameNumber,13+m)*imgSize(2),data(frameNumber,19+m)*imgSize(1),...   
                    pType,'LineWidth',2,'MarkerSize',MarkerSize);                
        end 
        
        if makeVideo
                ht = plot(-1,-1,'r+','MarkerSize',20,'LineWidth',2);                
            else
                ht = plot(-1,-1,'+','MarkerSize',20,'LineWidth',2,'Color',co);                
        end
                                 
        if (frameNumber < 100)  
            [hl,hobj] = legend([hp,ht],{'RFID chips','Target'},'Position',[0.5 0.77 0.4 0.2]);               
            legend('boxoff');
            set(hl,'FontSize',30);            
            hobj(1).FontSize = 30;            
            hobj(2).FontSize = 30;               
            if (makeVideo)                
                hobj(1).Color = [0 0 0];
                hobj(2).Color = [0 0 0];                
            end
        end
        hold off;        
        
        if (frameNumber == lastFrame) || (any(abs(frameNumber-dumpFrames)<2.5))
            export_fig(sprintf('%sRFID6_%d.pdf',tempDataPath,frameNumber));
        end
        
        if (makeVideo)
            F = getframe(gca);
            writeVideo(v,F);
        end
    end
    close all;
    
    function lastFrame = FindLastFrame()
        distVector = abs(data(:,20:25) - 0.6650);
        for i = 1:length(data)
            totalDist(i) = sum(distVector(i,:));
        end
        [~,lastFrame] = min(totalDist);           
    end

    function p = line(sx,sy,ex,ey,n)
       d = (1:n)' / n;
       x = (ex-sx) * d + sx;
       y = (ey-sy) * d + sy;
       p = [x y];
    end
            
end