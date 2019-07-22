function plot_aaltologo()     
    close all;

    tempDataPath = getTempDataPath();
    x = [];
    y = [];
    p = [];    
    frameNumber = 0;
    template = [];
    offs = [];
    
    % for paper
    % makeVideo = 0;
    % everyNthFrame = 2;
    % dumpFrames = round(linspace(1,1180,4));
    
    % for supplementary
    makeVideo = 1;
    dumpFrames = [];
    everyNthFrame = 4;
    
    f = figure;
    set(f, 'Position', [100, 100, 700, 700]);                
    axes('position', [0 0 1 1]);
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[]);    
    
           
    if (makeVideo)
        v = VideoWriter(sprintf('%sLOGO_m.avi',tempDataPath));
        open(v);
        set(f, 'Position', [100, 100, 720, 720]);                
    end
    
    processVideo('cam5_20160120_017.avi',@processFrame); 
   
    
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
        if mod(frameNumber,everyNthFrame) ~= 1
            return;
        end                        
        
        gf = double(rgb2gray(frame))/255;                  
        bw = adaptiveThreshold(gf,5);         
        if (isempty(p))
            imshow(~bw);
            % p = ginput(1);                        
            p = [129.7100  669.1500];
        end        
        ret = findWasher(bw);
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
        t = {generateLogo();};        
        for i = 1:length(t)
            t2 = splitTargetList(t{i},0.02);
            hr = plot(t2(:,1) * imgSize(2),t2(:,2) * imgSize(1),'r+','LineWidth',1,'MarkerSize',4);     
        end              
        ht = plot(x,y,'b.','LineWidth',2);                   
        if (frameNumber < 5 || makeVideo)
            if (makeVideo) 
                [hl,hobj] = legend([hr,ht],{'Reference','Trail'},'Position',[0.5 0.75 0.4 0.25]);                            
            else
                [hl,hobj] = legend([hr,ht],{'Reference','Trail'},'Location','NorthWest');            
            end
            legend('boxoff');         
            set(hl,'FontSize',24);                           
            hobj(1).FontSize = 24; 
            hobj(2).FontSize = 24;             
            hobj(4).MarkerSize = 25;
            hobj(6).MarkerSize = 30;           
            hl.Position = hl.Position + [0 0.03 0 0];
            if (makeVideo)                
                hobj(1).Color = [1 1 1];
                hobj(2).Color = [1 1 1];                
            end            
        end
        hold off;        
        
        if (any(abs(frameNumber-dumpFrames)<(0.5 + everyNthFrame/2)))
            export_fig(sprintf('%slogo_%d.pdf',tempDataPath,frameNumber));
        end
        
        if (makeVideo)
            F = getframe(gca);
            writeVideo(v,F);            
        end
    end

    function ret = findWasher(bw)                  
        if (isempty(template))
            imshow(~bw);                        
            % a = round(ginput(3));
            % a = [66   607;193   739;131   668];
            a = [54 615;180 741;117 677];

            template = bw(a(1,2):a(2,2),a(1,1):a(2,1));
            offs = [a(3,1)-a(2,1) a(3,2)-a(2,2)];
        end
        c = normxcorr2(template,bw);
        [ypeak, xpeak] = find(c==max(c(:)));
        cx = xpeak + offs(1);
        cy = ypeak + offs(2);
        imshow(bw);
        hold on;
        plot(cx,cy,'*');
        hold off;
        ret = [cx cy];
    end    

 %%
    close all;
    
     

    
end
