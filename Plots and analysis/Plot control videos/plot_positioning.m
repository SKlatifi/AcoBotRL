function plot_positioning()     
    
    tempDataPath = getTempDataPath();
    frameNumber = 0;
    lastFrameRepeat = 0;
    makeVideo = 0;
    everyNthFrame = 5;
    
    f = figure(1);
    set(f, 'Position', [100, 100, 700, 700]);                
    axes('position', [0 0 1 1]);
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[]);
    data = csvread('C:\Users\X230\Documents\AcoLabControl\results\positioning\positioning.txt'); 
    lastFrame = FindLastFrame();
    dumpFrames = round(linspace(1,lastFrame,5));
    
    if (makeVideo)
        v = VideoWriter(sprintf('%sPOSITONING_m.avi',tempDataPath));
        open(v);
        set(f, 'Position', [100, 100, 720, 720]);                
    end
      
    processVideo('positioning.avi',@processFrame);        
    
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
        
        t{1} = [0.75 0.25];
        t{2} = [0.75 0.75];            
        t{3} = [0.25 0.75];
        t{4} = [0.25 0.25];  
                      
        co = [0.7 0.5 0];
        
        for m = 1:length(t)
            MarkerSize = 40;
            d1 = sqrt((data(1:frameNumber,13+m) - data(frameNumber,13+m)) .^ 2 +...
                (data(1:frameNumber,17+m) - data(frameNumber,17+m)) .^ 2);            
            ind = d1 > 0.035;
            
            for j = 1:size(ind,1)  % Down sampling the data
                if mod(j,everyNthFrame) ~= 1
                    ind(j) = 0;
                end
            end
            
            if m == 1  %% Type of particle box
                trailType = 'b.';
            elseif m == 2
                trailType = 'r.';
            elseif m == 3
                trailType = 'g.';
            elseif m == 4
                if makeVideo
                    trailType = 'y.';
                else
                    trailType = 'm.';
                end
            end 
                        
            plot(data(ind,13+m)*imgSize(2),data(ind,17+m)*imgSize(1),...
                trailType,'MarkerSize',7);  

            if m == 1  %% Type of particle box
                pType = 'bs';
            elseif m == 2
                pType = 'r^';
            elseif m == 3
                pType = 'gd';
            elseif m == 4
                if makeVideo
                    pType = 'yo';
                else
                    pType = 'mo';
                end
            end                                 
            
            plot(data(frameNumber,13+m)*imgSize(2),data(frameNumber,17+m)*imgSize(1),...   
                    pType,'LineWidth',3,'MarkerSize',MarkerSize);
            if makeVideo
                plot(t{m}(:,1)*imgSize(2),t{m}(:,2)*imgSize(1),'r+','MarkerSize',32,'LineWidth',2);
                plot(t{m}(:,1)*imgSize(2),t{m}(:,2)*imgSize(1),'ro','MarkerSize',16,'LineWidth',2);
            else
                plot(t{m}(:,1)*imgSize(2),t{m}(:,2)*imgSize(1),'+','MarkerSize',32,'LineWidth',2,'Color',co);
                plot(t{m}(:,1)*imgSize(2),t{m}(:,2)*imgSize(1),'o','MarkerSize',16,'LineWidth',2,'Color',co);
            end
        end
        
        if (frameNumber < 100 || makeVideo)
            FontSize = 32;
            LegendMarkerSize = 30;
            GapHor = 450;
            GapVert = 70;
            TextLeft = 120; 
            LegendLeft = 80;
            TextTop = 50;
            
            if makeVideo
                colorLegend = 'white';
            else
                colorLegend = 'black';
            end
            text(TextLeft,50,'Mustard seed','HorizontalAlignment','left',...
            'VerticalAlignment','middle','FontName','Arial','FontSize',FontSize,'Color',colorLegend);  
            text(TextLeft+GapHor,50,'Resistor','HorizontalAlignment','left',...
            'VerticalAlignment','middle','FontName','Arial','FontSize',FontSize,'Color',colorLegend); 
            text(TextLeft,120,'Candy ball','HorizontalAlignment','left',...
            'VerticalAlignment','middle','FontName','Arial','FontSize',FontSize,'Color',colorLegend); 
            text(TextLeft+GapHor,120,'Chia seed','HorizontalAlignment','left',...
            'VerticalAlignment','middle','FontName','Arial','FontSize',FontSize,'Color',colorLegend);
            cLegend = [LegendLeft TextTop; LegendLeft+GapHor TextTop; LegendLeft TextTop+GapVert; LegendLeft+GapHor TextTop+GapVert]; 
                        
            for m = 1:size(cLegend,1)
                if m == 1  %% Type of particle box
                    if makeVideo
                        pType = 'yo';
                    else
                        pType = 'mo';
                    end                    
                elseif m == 2
                    pType = 'bs';
                elseif m == 3
                    pType = 'gd';
                elseif m == 4
                    pType = 'r^';
                end
                plot(cLegend(m,1),cLegend(m,2),pType,'LineWidth',3,'MarkerSize',LegendMarkerSize);
            end
        end
        
        hold off;        
        
        if (any(abs(frameNumber-dumpFrames)<2.5))
            export_fig(sprintf('%sPOSITIONING_%d.pdf',tempDataPath,frameNumber));
        end
        
        if (makeVideo)
            F = getframe(gca);
            writeVideo(v,F);
        end
    end
    close all;
    
    function lastFrame = FindLastFrame()
        distVector = data(:,14:21) - data(:,38:45);
        for i = 1:4
            dist{i} = distVector(:,(2*i-1):(2*i));
        end

        for i = 1:length(dist) 
            for j = 1:length(dist{i})
                normVector{i}(j,1) = norm(dist{i}(j,:));
            end
        end
        totalDist = normVector{1}+normVector{2}+normVector{3}+normVector{4};
        [~,lastFrame] = min(totalDist);            
    end
            
end