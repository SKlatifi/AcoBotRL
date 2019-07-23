function plot_manipulation_data(D,M,videoFile,plotReference,interval,targetStyle)         
    if (nargin < 3)
        videoFile = [];
    end
    
    if (nargin < 4)
        plotReference = 1;
    end
    
    if (nargin < 5)
        interval = 1;
    end

    if (nargin < 6)
        targetStyle = 'o';
    end
    
    history = 4;    
    alpha = 1;
    weights = exp(-alpha*(0:(history-1)));    
    F = {};
    k = 0;
    
    f = figure;
    set(f, 'Position', [100, 100, 720, 720]);                
    axes('position', [0 0 1 1]);
    
    if (~isempty(videoFile))
        v = VideoWriter(videoFile);
        open(v);
    end       
    
    cache = {};
        
    for i = 1:interval:size(M,1)                                                        
        line = M(i,:);        
        from = 1;
        [sParamCode,from] = take(line,from,2);
        [sPlayedNotes,from] = take(line,from,2);
        [sP,from] = take(line,from,2);
        [sT,from] = take(line,from,2);        
        [paramCode,from] = take(line,from,sParamCode);        
        [playedNotes,from] = take(line,from,sPlayedNotes);        
        hx = M(1:(i-1),from:(from+sP(1)-1));
        hy = M(1:(i-1),(from+sP(1)):(from+2*sP(1)-1));
        [p,from] = take(line,from,sP);           
        [phat,from] = take(line,from,sP);        
        [n,from] = take(line,from,sP);                
        t = take(line,from,sT);          
                
        cache = plot_quiver(D,D.modeInfo.freq(paramCode(1)),20,1,'b-',cache);
        hold on;        
        plot(hx,hy,'k.');
        if (plotReference)
            l4 = plot(M(:,(1:sT(1))+from-1),M(:,(1:sT(1))+from+sT(1)-1),'r--','LineWidth',2);
        end
        l2 = plot(t(:,1),t(:,2),targetStyle,'MarkerSize',14,'LineWidth',2,'Color',[0.8 0.5 0]);
        l1 = plot(p(:,1),p(:,2),'mx','MarkerSize',14,'LineWidth',2);                
        l3 = plot(-1,-1,'k.');        
        hold off;      
        if (plotReference)
            legend([l1,l2,l4(1),l3],{'Current position','Current target','Reference','Trail'},'Location','NorthWest','FontSize',11,'FontName','Arial');        
        else
            legend([l1,l2,l3],{'Current position','Current target','Trail'},'Location','NorthWest','FontSize',11,'FontName','Arial');        
        end
        pause(0.0001);               
        
        if (~isempty(videoFile))
            F{k+1} = getframe(gca);            
            Ftot = zeros(size(F{k+1})); 
            wtot = 0;
            for j = 1:min(history,length(F))
                Ftot = Ftot+im2double(F{mod(1+k-j,history)+1}.cdata)*weights(j);
                wtot = wtot + weights(j);
            end
            Ftot = im2uint8(Ftot / wtot);
            writeVideo(v,Ftot);
            k = mod(k+1,history);
        end
    end
    
    if (~isempty(videoFile))        
        close(v);
    end
    
    function [ret,fromNext] = take(line,from,shape)
        count = prod(shape);
        if length(shape) > 1
            ret = reshape(line(from:(from+count-1)),shape);
        else
            ret = line(from:(from+count-1));
        end
        fromNext = from + count;
    end
    
end

