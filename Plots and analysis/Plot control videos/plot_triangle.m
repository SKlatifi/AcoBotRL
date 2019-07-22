function plot_sci()     
    tempDataPath = getTempDataPath();
    x = [];
    y = [];
    p = [];    
    frameNumber = 0;
    fnum = [];
    gof = [];
    makeVideo = 1;
    
    f = figure(1);
    set(f, 'Position', [100, 100, 700, 700]);                
    axes('position', [0 0 1 1]);
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[]);
    %dumpFrames = [round(linspace(1,481,4))]; % 1146
    dumpFrames = [round(linspace(1,2096,4))]; 
    
    lines = [0.5 0.3 0.3 0.7;0.3 0.7 0.7 0.7;0.7 0.7 0.5 0.3];
    lines = (lines - 0.5) * 1.1 + 0.5;    
    
	if (makeVideo)
        v = VideoWriter(sprintf('%sPATTERN_m.avi',tempDataPath));
        open(v);
        set(f, 'Position', [100, 100, 720, 720]);                
    end
    
    processVideo('E:\VideoOfManipulation 2016.01.22\pattern_cam5_20160122_007.avi',@processFrame);        
        
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
        if mod(frameNumber,5) ~= 1 || frameNumber > max(dumpFrames)
            return;
        end                        
        
        gf = double(rgb2gray(frame))/255;                  
        bw = adaptiveThreshold(gf,5);         
        if (isempty(p))
            imshow(~bw);
            %p = ginput(6);
            p = [181.6300  212.3100  389.3100  394.0300  665.4300  628.8500; ...
            572.3900  198.3300  629.0300  350.5500  560.5900  243.1700]';            
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
        
        fnum = [fnum;frameNumber];
        gof = [gof;max(distancesToLines(p,imgSize))];
        gof(end)
        
        hold on;
        t{1} = [lines(:,1:2);lines(1,1:2)];
        for i = 1:length(t)
            t2 = splitTargetList(t{i},0.02);
            n = length(t2);
            t2(:,1) = t2(:,1) * imgSize(2);
            t2(:,2) = t2(:,2) * imgSize(1);
            d1 = sqrt((ones(6,1) * t2(:,1)' - p(1:6,1) * ones(1,n)) .^ 2 + (ones(6,1) * t2(:,2)' - p(1:6,2) * ones(1,n)) .^ 2);            
            ind = min(d1,[],1) > 24;  
            hr = plot(t2(ind,1),t2(ind,2),'r+','LineWidth',1,'MarkerSize',4);                 
        end                            
        
        for i = 1:size(p,1)                     
            n = size(x,2);
            d1 = sqrt((ones(6,1) * x(i,:) - p(1:6,1) * ones(1,n)) .^ 2 + (ones(6,1) * y(i,:) - p(1:6,2) * ones(1,n)) .^ 2);            
            ind = min(d1,[],1) > 24;                        
            plot(x(i,ind),y(i,ind),'b.','LineWidth',1.5);
        end 
        
        ht = plot(-100,-100,'b.','LineWidth',1.5);
        
        if (makeVideo)
            col = [1 1 1];
        else
            col = [0 0 0];
        end
            
        
        hp = plot(p(:,1),p(:,2),'o','LineWidth',2,'MarkerSize',20,'Color',col);     
                
        if (frameNumber < 2500)
            if (makeVideo)
                [hl,hobj] = legend([hp,hr,ht],{'Particles','Target','Trail'},'Position',[0.65 0.70 0.1 0.25]);
            else
                [hl,hobj] = legend([hp,hr,ht],{'Particles','Target','Trail'},'Location','NorthEast');
                hl.Position = hl.Position + [-0.08 0.03 0 0];
            end
            
            
            legend('boxoff');
            set(hl,'FontSize',25);
            hobj(1).FontSize = 25; 
            hobj(2).FontSize = 25; 
            hobj(3).FontSize = 25; 
            if (makeVideo)                
                hobj(1).Color = [1 1 1];
                hobj(2).Color = [1 1 1];               
                hobj(3).Color = [1 1 1];               
            end
            hobj(7).MarkerSize = 25;
            hobj(9).MarkerSize = 30;                                                
        end
        hold off;        
        
        if (any(abs(frameNumber-dumpFrames)<2.5))
            export_fig(sprintf('%striangle_%d.pdf',tempDataPath,frameNumber));
        end
        
        if (makeVideo)
            F = getframe(gca);
            writeVideo(v,F);
        end
    end

    function d = distancesToLines(points,imgSize)
        d = zeros(size(points,1),1);
        for i = 1:size(points,1)
           d(i) = distanceToAnyLine(points(i,:),imgSize);
        end
    end

    function ret = distanceToAnyLine(point,imgSize)
        d = zeros(size(lines,1),1);
        for i = 1:size(lines,1)
           d(i) = distanceToNearestLine(point ./ [imgSize(2) imgSize(1)],lines(i,:));
        end
        ret = min(d);
    end

    function ret = findBlobs(bw)        
        s = regionprops(bw,'centroid','FilledArea');
        centroids = cat(1, s.Centroid);
        areas = cat(1, s.FilledArea);
        ind = 150 < areas & areas < 350;
        ret = centroids(ind,:);      
    end    

    figure;
    plot(fnum,gof,'.');
    
     

    
end