function ret = RLSPlateModel(modes,gridSize,lambda,alpha)
    frequencies = modes.frequencies;
    gains = modes.gains;
    durations = modes.durations;        
    w = modes.w;            
    numCodes = length(frequencies);                        
    
    R = cell(numCodes,1);        
    m = (gridSize+1)*(gridSize+1);
    for v = 1:numCodes        
        R{v} = sparse(eye(m,m));                        
    end
                
    % Public methods    
    
    ret = struct('predict',@predict,'update',@update,'numCodes',@() numCodes,'getParams',@getParams,'visualization',@visualization);      
    
    function update(p,n,mode)   
        [phat,varhat] = predict(p,zeros(size(p,1),1),mode);
        var = sum((n - phat) .^ 2,2) - varhat;
        [w{mode},R{mode}] = RLS(spikeBasis(p,gridSize),[(n - p) var],w{mode},R{mode},lambda,alpha);        
        w{mode}(:,3) = max(w{mode}(:,3),0);
    end
    
    function ret = getParams(p,modes)         
        if (size(modes,2) > 1)
            ret = [frequencies(modes) gains(modes).*modes(:,2) durations(modes)];        
        else
            ret = [frequencies(modes) gains(modes) durations(modes)];        
        end
    end   	
            
	function [pnew,varnew] = predict(p,var,mode)        
        d = spikeBasis(p,gridSize)' * w{mode};        
        pnew = p + d(:,1:2);
        varnew = var + d(:,3);        
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
    
    function [w,R] = RLS(X,Y,w,R,lambda,alpha)                
        E = Y - X' * w;        
        w = w + R \ (X * E);            
        R = lambda * R + X * X' + (1 - lambda) * alpha * sparse(eye(size(R))); 
    end
end