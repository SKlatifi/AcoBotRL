function ret = pointTracker(targets,tolerance,stdWeight,particleRadius,particlePenalty)
    ret = struct('compute',@compute,'update',@update,'finished',@finished,'visualization',@visualization);   
    
    function ret = compute(modes,path,vars)          
        deltas = targets - path(:,(end-1):end);
        finalDist = sqrt(sum(deltas .^ 2,2));
        finalVars = vars(:,end);        
        numP = size(path,1);      
        avoidance = 0;        
        p = path(:,(end-1):end);
        [X1,X2] = meshgrid(p(:,1),p(:,1));
        [Y1,Y2] = meshgrid(p(:,2),p(:,2));
        D = sqrt((X1 - X2) .^ 2 + (Y1 - Y2) .^ 2);                        
        D = D / particleRadius;
        D = D + eye(numP,numP);
        avoidance = avoidance + sum(sum((D < 1) .* (1 ./ D - 1) * particlePenalty));                   
        ret = sqrt(sum((finalDist + stdWeight * sqrt(finalVars)) .^ 2)) + avoidance;
    end   

    function update(p,n,mode)
    end

    function ret = finished(p)
        ret = max(sqrt(sum((targets - p) .^ 2))) < tolerance;            
    end

    function ret = visualization()
        ret = targets;
    end
end