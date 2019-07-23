function plot_droplet()     
    
    tempDataPath = getTempDataPath();
    frameNumber = 0;
    lastFrameRepeat = 0;
    makeVideo = 1;
    everyNthFrame = 2;
    
    f = figure(1);
    set(f, 'Position', [100, 100, 700, 700]);                
    axes('position', [0 0 1 1]);
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[]);
    data = csvread('C:\Users\X230\Documents\AcoLabControl\results\droplet\droplet.txt');    
    firstFrame = 140;
    lastFrame = 668;
    dumpFrames = round(linspace(1,lastFrame,5));
    
    if (makeVideo)
        v = VideoWriter(sprintf('%sDROPLET_m.avi',tempDataPath));
        open(v);
        set(f, 'Position', [100, 100, 720, 720]);                
    end
      
    processVideo('droplet.avi',@processFrame);        
    
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
        
        if frameNumber > firstFrame 
            
            dataNumber = frameNumber - firstFrame;

            if (dataNumber ~= lastFrame)
                if (mod(dataNumber,everyNthFrame) ~= 1)
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

            t = generateLineDroplet();            
            
            MarkerSize = 40;
            dt = sqrt((t(:,1) - data(dataNumber,14)) .^ 2 +...
                (t(:,2) - data(dataNumber,15)) .^ 2);            
            indT = dt > 0.04;            
            plot(t(indT,1)*imgSize(2),t(indT,2)*imgSize(1),...
                'r+','MarkerSize',8,'LineWidth',2);
            dp = sqrt((data(1:dataNumber,14) - data(dataNumber,14)) .^ 2 +...
                (data(1:dataNumber,15) - data(dataNumber,15)) .^ 2);            
            indP = dp > 0.04;

            for j = 1:size(indP,1)  % Down sampling the data
                if mod(j,everyNthFrame) ~= 1
                    indP(j) = 0;
                end
            end

            plot(data(indP,14)*imgSize(2),data(indP,15)*imgSize(1),...
                'b.','MarkerSize',8);
            
            if makeVideo
                hp = plot(data(dataNumber,14)*imgSize(2),data(dataNumber,15)*imgSize(1),...   
                    'wo','LineWidth',3,'MarkerSize',MarkerSize);
                plot(data(dataNumber,20)*imgSize(2),data(dataNumber,21)*imgSize(1),...
                'gx','MarkerSize',20,'LineWidth',4);
            else
                hp = plot(data(dataNumber,14)*imgSize(2),data(dataNumber,15)*imgSize(1),...
                    'ko','LineWidth',3,'MarkerSize',MarkerSize);
            end        

            hr = plot(-1,-1,'b.','MarkerSize',25);   % Just for legend
            ht = plot(-2,-2,'r+','MarkerSize',20,'LineWidth',1.5); % Just for legend

            if (dataNumber < 100 || makeVideo)
                
                if (makeVideo)
                    FontSize = 22;
                    GapHor = 220;
                    GapVert = 70;
                    TextLeft = 380; 
                    LegendLeft = 330;
                    TextTop = 40;
                    colorLegend = 'white';

                    text(TextLeft,TextTop,'Droplet','HorizontalAlignment','left',...
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
                    [hl,hobj] = legend([hp,ht,hr],{'Droplet','Reference','Trail'},'Position',[0.65 0.79 0.35 0.2]);               
                    legend('boxoff');
                    set(hl,'FontSize',20);            
                    hobj(1).FontSize = 20;            
                    hobj(2).FontSize = 20;   
                    hobj(3).FontSize = 20; 
                end

            end
            hold off;        

            if (frameNumber == lastFrame) || (any(abs(frameNumber-dumpFrames)<2.5))
                export_fig(sprintf('%sDroplet_%d.pdf',tempDataPath,frameNumber));
            end

            if (makeVideo)
                F = getframe(gca);
                writeVideo(v,F);
            end
        end
    end
    close all;
               
end