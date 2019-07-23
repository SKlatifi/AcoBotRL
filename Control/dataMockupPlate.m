function ret = dataMockupPlate(p,modeInfoFile,stepscale,stdscale)
    if (nargin < 4)
        stdscale = 1;
    end
    
    fig = figure();

    ret = struct('play',@play,'findParticles',@findParticles,'getClicks',@getClicks,'visualize',@visualize);        
    modeInfoStruct = load(modeInfoFile,'modeInfo');
    modes = modeInfoStruct.modeInfo;           
    
    function [d,std] = evaluateModel(p,modeNumber)
        g = modes.gradient{modeNumber};
        s = [g.maxX g.maxY];
        pPixels = [p(:,1)*s(1) p(:,2)*s(2)];
        dPixels = [feval(g.fitU,pPixels) feval(g.fitV,pPixels)];
        stdPixels = feval(g.fitSTD,pPixels);
        d = [dPixels(:,1)/s(1) dPixels(:,2)/s(2)];
        std = stdPixels / mean(s);        
    end

    function visualizeText(p)
       b = num2str((1:size(p,1))');
       c = cellstr(b);
       dx = 0.01; dy = 0.01;
       text(p(:,1)+dx, p(:,2)+dy, c); 
    end
    
    function visualize(p,phat,t,modeArrows)
        figure(fig); 
        hold off;        
        plot(p(:,1),p(:,2),'kd');        
        hold on;        
        visualizeText(p);
        plot([p(:,1) phat(:,1)]',[p(:,2) phat(:,2)]','b-');        
        plot(t(:,1),t(:,2),'g*');
        s = size(modeArrows.u)-1;
        [y,x] = meshgrid((0:s(1)) / s(1),(0:s(2)) / s(2));
        quiver(x,y,modeArrows.u,modeArrows.v)
        visualizeText(t);
        hold off;        
        axis([0 1 0 1]);
    end    
    
    function play(params)      
        frequency = params(1);        
        amplitude = params(2);
        duration = params(3);
        modeNumber = find(modes.freq == frequency,1);                       
        if (isempty(modeNumber))
            error('Trying to use unknown mode');
        end
        [d,std] = evaluateModel(p,modeNumber);
        ascale = amplitude / modes.amp(modeNumber);
        dscale = duration / (modes.duration(modeNumber) / 1000);        
        p = p + stepscale * ascale * dscale * (d + (stdscale * std * [1 1]) .* randn(size(p)));        
        pause(1e-6);
    end

    function ret = findParticles()
        ret = p;
    end

    function ret = getClicks()        
        ret = p;
    end
end