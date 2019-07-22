function plot_sci()     
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
    dumpFrames = round(linspace(1,1576,4));
       
    
    if (makeVideo)
        v = VideoWriter(sprintf('%sSCI_m.avi',tempDataPath));
        open(v);
        set(f, 'Position', [100, 100, 720, 720]);                
    end
      
    processVideo('cam5_20160120_008.avi',@processFrame);        
    
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
        bw = adaptiveThreshold(gf,5);         
        if (isempty(p))
            imshow(~bw);
            % p = ginput(3);
            p = [273.7852  282.2817;572.9201  287.3403;719.0450  289.4775];            
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
        t{1} = [0.33 0.35;0.13 0.35;0.13 0.5;0.33 0.5;0.33 0.65;0.13 0.65];
        t{2} = [0.7 0.35;0.5 0.35;0.5 0.45;0.5 0.55;0.5 0.65;0.7 0.65];
        t{3} = [0.87 0.35; 0.87 0.65];             

        for i = 1:length(t)
            t2 = splitTargetList(t{i},0.02);
            n = length(t2);
            t2(:,1) = t2(:,1) * imgSize(2);
            t2(:,2) = t2(:,2) * imgSize(1);
            d1 = sqrt((ones(3,1) * t2(:,1)' - p(1:3,1) * ones(1,n)) .^ 2 + (ones(3,1) * t2(:,2)' - p(1:3,2) * ones(1,n)) .^ 2);            
            ind = min(d1,[],1) > 24;  
            hr = plot(t2(ind,1),t2(ind,2),'r+','LineWidth',1,'MarkerSize',4);                 
        end                            
        
        for i = 1:size(p,1)                     
            n = size(x,2);
            d1 = sqrt((ones(3,1) * x(i,:) - p(1:3,1) * ones(1,n)) .^ 2 + (ones(3,1) * y(i,:) - p(1:3,2) * ones(1,n)) .^ 2);            
            ind = min(d1,[],1) > 24;                        
            plot(x(i,ind),y(i,ind),'b.','LineWidth',1.5);
        end 
        
        ht = plot(-100,-100,'b.','LineWidth',1.5);
        
        if (makeVideo)
            hp = plot(p(:,1),p(:,2),'ko','LineWidth',2,'MarkerSize',20,'Color',[1 1 1]);                 
        else
            hp = plot(p(:,1),p(:,2),'ko','LineWidth',2,'MarkerSize',20);     
        end
                
        if (frameNumber < 100 || makeVideo)
            if (makeVideo)
                [hl,hobj] = legend([hp,hr,ht],{'Particles','Reference','Trail'},'Position',[0.5 0.75 0.4 0.25]);
            else
                [hl,hobj] = legend([hp,hr,ht],{'Particles','Reference','Trail'},'Location','NorthWest');                   
            end
            legend('boxoff');
            set(hl,'FontSize',24);            
            hobj(1).FontSize = 24;            
            hobj(2).FontSize = 24;             
            hobj(3).FontSize = 24;             
            hobj(7).MarkerSize = 25;
            hobj(9).MarkerSize = 30;         
            if (makeVideo)                
                hobj(1).Color = [1 1 1];
                hobj(2).Color = [1 1 1];
                hobj(3).Color = [1 1 1];            
            end
        end
        hold off;        
        
        if (any(abs(frameNumber-dumpFrames)<2.5))
            export_fig(sprintf('%sSCI_%d.pdf',tempDataPath,frameNumber));
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
        ind = 150 < areas & areas < 400;
        ret = centroids(ind,:);      
    end    

 %%
    close all;
    
     

    
end