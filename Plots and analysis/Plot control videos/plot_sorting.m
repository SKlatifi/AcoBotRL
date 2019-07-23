function plot_sorting()     
    tempDataPath = getTempDataPath();
    x = [];
    y = [];
    p = [];        
    frameNumber = 0;
    makeVideo = 1;
    
    f = figure(1);
    set(f, 'Position', [100, 100, 700, 700]);                
    axes('position', [0 0 1 1]);
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[]);
    dumpFrames = [round(linspace(1,10841,5)) 25];
    
    if (makeVideo)
        v = VideoWriter(sprintf('%sSORTING_m.avi',tempDataPath));
        open(v);
        set(f, 'Position', [100, 100, 720, 720]);                
    end
    
    processVideo('sorting_cam5_20160122_011.avi',@processFrame);   
%     processVideo('E:\VideoOfManipulation 2016.01.22\sorting_cam5_20160122_011.avi',@processFrame);        
    
    if (makeVideo)        
        close(v);
    end
    
    function p = matchLeft(p1,p2)
        m = match(p1,p2);
        msort = sortrows(m,2);
        p = p1(msort(:,1),:);
    end
    
    function processFrame(frame)
        frameNumber = frameNumber +1
        if mod(frameNumber,5) ~= 1
            return;
        end                        
        
        gf = double(rgb2gray(frame))/255;                  
        bw = adaptiveThreshold(gf,15);         
        if (isempty(p))
            imshow(~bw);
            %p = ginput(6);            
            p = [189.8900  392.8500  705.5500  117.9100  301.9900  569.8500; ...
                198.3300  527.5500  489.7900  357.6300  336.3900  586.5500]';
        end        
        ret = findBlobs(bw);
        p = matchLeft(ret,p);
        x = [x p(:,1)];
        y = [y p(:,2)];        
        if (makeVideo)
            imshow(gf);
        else
            imshow(1 - gf);        
        end
        imgSize = size(gf);
        hold on;
        t{1} = [0.75 0.25];
        t{2} = [0.25 0.75];        
                
        for i = 1:size(p,1)                     
            n = size(x,2);
            d1 = sqrt((ones(3,1) * x(i,:) - p(1:3,1) * ones(1,n)) .^ 2 + (ones(3,1) * y(i,:) - p(1:3,2) * ones(1,n)) .^ 2);
            d2 = max(abs(ones(3,1) * x(i,:) - p(4:6,1) * ones(1,n)),abs(ones(3,1) * y(i,:) - p(4:6,2) * ones(1,n)));
            ind1 = min(d1,[],1) > 24;
            ind2 = min(d2,[],1) > 20;
            ind = ind1 & ind2;
            if (i < 4)
                linedef = 'b.';
            else                            
                linedef = 'r.';
            end            
            ht = plot(x(i,ind),y(i,ind),linedef,'LineWidth',1.5);
        end                 
        
        hp1 = plot(p(1:3,1),p(1:3,2),'bo','LineWidth',2,'MarkerSize',20);     
        hp2 = plot(p(4:6,1),p(4:6,2),'rs','LineWidth',2,'MarkerSize',20);                                 
        

        co = [0.7 0.5 0];
        
        plot(t{1}(:,1) * imgSize(2),t{1}(:,2) * imgSize(1),'+','LineWidth',1.5,'MarkerSize',20,'Color',co);                 
        plot(t{1}(:,1) * imgSize(2),t{1}(:,2) * imgSize(1),'o','LineWidth',1.5,'MarkerSize',10,'Color',co);     
        plot(t{2}(:,1) * imgSize(2),t{2}(:,2) * imgSize(1),'+','LineWidth',1.5,'MarkerSize',20,'Color',co);     
        plot(t{2}(:,1) * imgSize(2),t{2}(:,2) * imgSize(1),'o','LineWidth',1.5,'MarkerSize',10,'Color',co);     
       
            
        if (frameNumber < 2500)                        
            if (makeVideo)
                col = [1 1 1];
            else
                col = [0 0 0];
            end
            
            text(t{1}(:,1) * imgSize(2),t{1}(:,2) * imgSize(1) + 50,'Target 1','FontSize',25,'HorizontalAlignment','center','VerticalAlignment','middle','Color',col);
            text(t{2}(:,1) * imgSize(2),t{2}(:,2) * imgSize(1) + 50,'Target 2','FontSize',25,'HorizontalAlignment','center','VerticalAlignment','middle','Color',col);
            
            if (makeVideo)
                [hl,hobj] = legend([hp1,hp2],{'Group 1','Group 2'},'Position',[0.65 0.75 0.1 0.25]);
            else
                [hl,hobj] = legend([hp1,hp2],{'Group 1','Group 2'},'Location','NorthEast');                                        
            end               
            legend('boxoff');
            set(hl,'FontSize', 25);    
            hobj(1).FontSize = 25;            
            hobj(2).FontSize = 25;     
            if (makeVideo)                
                hobj(1).Color = [1 1 1];
                hobj(2).Color = [1 1 1];               
            end
            
        end
        hold off;        
        
        if (any(abs(frameNumber-dumpFrames)<2.5))
            export_fig(sprintf('%ssort_%d.pdf',tempDataPath,frameNumber));
        end
        
        if (makeVideo)
            F = getframe(gca);
            writeVideo(v,F);
        end
    end

    function ret = findBlobs(bw)        
        s = regionprops(bw,'centroid','FilledArea');
        centroids = cat(1, s.Centroid);
        areas = cat(1, s.FilledArea);
        ind = 100 < areas & areas < 250;
        ret = centroids(ind,:);      
    end    
end