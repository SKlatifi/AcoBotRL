function ret = localPlateModel(modes,kernelsize,alpha,type)
    frequencies = modes.frequencies;
    gains = modes.gains;
    durations = modes.durations;    
    gridSize = modes.gridSize;
    w = modes.w;                     
    numCodes = length(frequencies);    
    
    if (nargin >= 4 && strcmp(type,'duration'))
        durationBased = true;
    else
        durationBased = false;
    end
    
    % Public methods    
    
    ret = struct('predict',@predict,'update',@update,'numCodes',@() numCodes,'getParams',@getParams,'visualization',@visualization);      
    
    function update(p,n,mode)        
        [phat,varhat] = predict(p,zeros(size(p,1),1),mode);
        var = sum((n - phat) .^ 2,2) - varhat;
        E = [(n - p) var];
        s = spikeBasis(p,gridSize)';
        for i = 1:size(mode,1)
            E = E - mode(i,2) * s * w{mode(i,1)} * mode(i,2);  
        end
        for i = 1:size(mode,1)
            w{mode(i,1)} = localUpdate(p,E,w{mode(i,1)},alpha * mode(i,2));        
            w{mode(i,1)}(:,3) = max(w{mode(i,1)}(:,3),0);
        end
    end
    
    function ret = getParams(p,mode)                        
        ret = [];
        for i = 1:size(mode,1)
            if (durationBased)
                ret = [ret;frequencies(mode(i,1)) gains(mode(i,1)) durations(mode(i,1))*mode(i,2)];
            else
                ret = [ret;frequencies(mode(i,1)) gains(mode(i,1))*mode(i,2) durations(mode(i,1))];
            end
        end
    end   	           

	function [pnew,varnew] = predict(p,var,mode)                
        pnew = p;
        varnew = var;
        for i = 1:size(mode,1)
            d = spikeBasis(p,gridSize)' * w{mode(i,1)};                    
            pnew = pnew + mode(i,2) * d(:,1:2);
            varnew = varnew + mode(i,2) * d(:,3);                
        end                
    end           

    function ret = visualization(modes)
        U = zeros(gridSize+1,gridSize+1);
        V = zeros(gridSize+1,gridSize+1);
        for i = 1:size(modes,1)
            U = U + modes(i,2) * reshape(w{modes(i,1)}(:,1),gridSize+1,gridSize+1);
            V = U + modes(i,2) * reshape(w{modes(i,1)}(:,2),gridSize+1,gridSize+1);
        end
        ret = struct('u',U,'v',V);
    end              

    % Private methods
    
    function w = localUpdate(p,E,w,weight)                
        for i = 1:size(p,1)
            sp = p(i,:) * gridSize;
            ip = round(sp);
            xr = (-kernelsize:kernelsize)+ip(1);
            yr = (-kernelsize:kernelsize)+ip(2);
            xr = xr((xr >= 0) & (xr <= gridSize));
            yr = yr((yr >= 0) & (yr <= gridSize));
            [x,y] = meshgrid(xr,yr);        
            d2 = (x - sp(1)) .^ 2 + (y - sp(2)) .^ 2;
            s = kernelsize / 3;
            kw = exp(-d2 / (2*s^2));
            knorm = kw / sum(sum(kw));
            sw = sparse(x(:)+1,y(:)+1,knorm(:),gridSize+1,gridSize+1);
            swcol = reshape(sw,(gridSize+1) * (gridSize+1),1);
            w = w + weight * swcol * E(i,:);                                            
        end                            
    end
end