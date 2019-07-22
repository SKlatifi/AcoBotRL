function plot_multi_aaltologo()     
    
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
    data = csvread('C:\Users\X230\Documents\AcoLabControl\results\multi_aaltologo\multi_aaltologo.txt');    
    lastFrame = 4600;
    dumpFrames = round(linspace(1,lastFrame,5));
    
    if (makeVideo)
        v = VideoWriter(sprintf('%sMULTI_AALTOLOGO_m.avi',tempDataPath));
        open(v);
        set(f, 'Position', [100, 100, 720, 720]);                
    end
      
    processVideo('multi_aaltologo.avi',@processFrame);        
    
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
        
        fullA = generateA();
        fullQ = generateQuestion();
        t{1} = fullA(1:3:end,:);
        t{2} = fullQ(1:3:end,:);                             
        
        for m = 1:length(t)
            MarkerSize = 35;
            dt = sqrt((t{m}(:,1) - data(frameNumber,13+m)) .^ 2 +...
                (t{m}(:,2) - data(frameNumber,15+m)) .^ 2);            
            indT = dt > 0.03;            
            plot(t{m}(indT,1)*imgSize(2),t{m}(indT,2)*imgSize(1),...
                'r+','MarkerSize',5,'LineWidth',1.5);
            dp = sqrt((data(1:frameNumber,13+m) - data(frameNumber,13+m)) .^ 2 +...
                (data(1:frameNumber,15+m) - data(frameNumber,15+m)) .^ 2);            
            indP = dp > 0.03;
            
            for j = 1:size(indP,1)  % Down sampling the data
                if mod(j,everyNthFrame) ~= 1
                    indP(j) = 0;
                end
            end
            
            plot(data(indP,13+m)*imgSize(2),data(indP,15+m)*imgSize(1),...
                'b.','MarkerSize',6);
            if makeVideo
                hp = plot(data(frameNumber,13+m)*imgSize(2),data(frameNumber,15+m)*imgSize(1),...   
                    'wo','LineWidth',2,'MarkerSize',MarkerSize);
                plot(data(frameNumber,25+m)*imgSize(2),data(frameNumber,27+m)*imgSize(1),...
                'gx','MarkerSize',20,'LineWidth',4);
            else
                hp = plot(data(frameNumber,13+m)*imgSize(2),data(frameNumber,15+m)*imgSize(1),...
                    'ko','LineWidth',2,'MarkerSize',MarkerSize);
            end        
        end
        
        hr = plot(-1,-1,'b.','MarkerSize',25);   % Just for legend
        ht = plot(-2,-2,'r+','MarkerSize',20,'LineWidth',1.5); % Just for legend
                                 
        if (frameNumber < 100 || makeVideo)           
            if (makeVideo)
                FontSize = 22;
                GapHor = 220;
                GapVert = 70;
                TextLeft = 380; 
                LegendLeft = 330;
                TextTop = 40;
                colorLegend = 'white';

                text(TextLeft,TextTop,'Particles','HorizontalAlignment','left',...
                'VerticalAlignment','middle','FontName','Arial','FontSize',FontSize,'Color',colorLegend);  
                text(TextLeft+GapHor,TextTop,'Reference','HorizontalAlignment','left',...
                'VerticalAlignment','middle','FontName','Arial','FontSize',FontSize,'Color',colorLegend); 
                text(TextLeft,TextTop+GapVert,'Trail','HorizontalAlignment','left',...
                'VerticalAlignment','middle','FontName','Arial','FontSize',FontSize,'Color',colorLegend); 
                text(TextLeft+GapHor,TextTop+GapVert,'Current target','HorizontalAlignment','left',...
                'VerticalAlignment','middle','FontName','Arial','FontSize',FontSize,'Color',colorLegend);
                
                cLegend = [LegendLeft TextTop; LegendLeft+GapHor TextTop; LegendLeft TextTop+GapVert; LegendLeft+GapHor TextTop+GapVert]; 

                for m = 1:size(cLegend,1)
                    if m == 1  %% Type of particle box
                        pType = 'wo';
                        LegendMarkerSize = 30;
                    elseif m == 2
                        pType = '+r';
                        LegendMarkerSize = 20;
                    elseif m == 3
                        pType = 'b.';
                        LegendMarkerSize = 30;
                    elseif m == 4
                        pType = 'gx';
                        LegendMarkerSize = 30;
                    end
                    plot(cLegend(m,1),cLegend(m,2),pType,'LineWidth',3,'MarkerSize',LegendMarkerSize);
                end
            else
                [hl,hobj] = legend([hp,ht,hr],{'Particles','Reference','Trail'},'Position',[0.65 0.79 0.35 0.2]);               
                legend('boxoff');
                set(hl,'FontSize',20);            
                hobj(1).FontSize = 20;            
                hobj(2).FontSize = 20;   
                hobj(3).FontSize = 20;                 
            end
        end
        hold off;        
        
        if (frameNumber == lastFrame) || (any(abs(frameNumber-dumpFrames)<2.5))
            export_fig(sprintf('%sMULTI_AALTOLOGO_%d.pdf',tempDataPath,frameNumber));
        end
        
        if (makeVideo)
            F = getframe(gca);
            writeVideo(v,F);
        end
    end
    close all;
               
end