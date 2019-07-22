function plot_merging() 
    
    tempDataPath = getTempDataPath();
    frameNumber = 0;
    lastFrameRepeat = 0;
    makeVideo = 0;
    everyNthFrame = 2;
    
    f = figure(1);
    set(f, 'Position', [100, 100, 700, 700]);                
    axes('position', [0 0 1 1]);
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[]);
    data1 = csvread('C:\Users\X230\Documents\AcoLabControl\results\merging\merging21.txt');    
    data2 = csvread('C:\Users\X230\Documents\AcoLabControl\results\merging\merging22.txt');
    data = [data1; data2];
    lastFrame = 318;
    dumpFrames = round(linspace(1,lastFrame,5));
    
    if (makeVideo)
        v = VideoWriter(sprintf('%sMERGING_m.avi',tempDataPath));
        open(v);
        set(f, 'Position', [100, 100, 720, 720]);                
    end
      
    processVideo('merging.avi',@processFrame);        
    
    if (makeVideo)        
        close(v);
    end
    
    function processFrame(frame)
        
        if (frameNumber == lastFrame)
             lastFrameRepeat = lastFrameRepeat + 1;
             if (lastFrameRepeat <= 5)
                frameNumber = frameNumber - 1;
             end
        end
        
        frameNumber = frameNumber +1;
        
        if (frameNumber ~= lastFrame)
            if (mod(frameNumber,everyNthFrame) ~= 1) || (frameNumber > lastFrame)
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
        
        if frameNumber > 305
            x = 305;
        else
            x = frameNumber;
        end
        for m = 1:2
            d1 = sqrt((data(1:x,13+m) - data(x,13+m)) .^ 2 +...
                (data(1:x,15+m) - data(x,15+m)) .^ 2);            
            ind = d1 > 0.025;
            
            for j = 1:size(ind,1)  % Down sampling the data
                if mod(j,everyNthFrame) ~= 1
                    ind(j) = 0;
                end
            end
            
            plot(data(ind,13+m)*imgSize(2),data(ind,15+m)*imgSize(1),...
                'b.','MarkerSize',7);                     
        end        
        
%         hr = plot(-1,-1,'b.','MarkerSize',30);   % Just for legend
%                                  
%         if (frameNumber < 50 || makeVideo)
%             [hl,hobj] = legend(hr,'Trail');               
%             legend('boxoff');
%             set(hl,'FontSize',24); 
%             set(hl,'Position',[0.6 0.8 0.3 0.2]);
%             hobj(1).FontSize = 24;                                    
%             if (makeVideo)                
%                 hobj(1).Color = [1 1 1];                
%             end
%         end
        hold off;        
        
        if (any(abs(frameNumber-dumpFrames)<2.5))
            export_fig(sprintf('%sMERGING_%d.pdf',tempDataPath,frameNumber));
        end
        
        if (makeVideo)
            F = getframe(gca);
            writeVideo(v,F);
        end
    end
    close all;
                
end