function modes = multiStep(modes,n)
    gridSize = modes.gridSize;
    [y,x] = meshgrid((0:gridSize)/gridSize,(0:gridSize)/gridSize);
    m = (gridSize+1)*(gridSize+1);
    for i = 1:length(modes.frequencies)
        w0 = [x(:) y(:) zeros(m,1)];                    
        wnew = w0;
        w = modes.w{i};
        for j = 1:n
            d = spikeBasis(wnew(:,1:2),gridSize)' * w;      
            wnew = wnew + d;            
        end
        modes.w{i} = wnew - w0;               
    end
    
    function scale = getScale(v,duration)
        l = rmsLength(v);
        scale = saturate(desiredStepSize / l,minDur / duration,maxDur / duration);        
    end

    function xsaturated = saturate(x,low,high)
       xsaturated = min(max(x,low),high); 
    end

    function length = rmsLength(v)       
       dist = sqrt(sum(v .^ 2,2));
       length = norm(dist(:),2);       
    end          
end