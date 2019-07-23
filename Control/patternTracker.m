function ret = patternTracker(lines,tolerance,stdWeight,particleRadius,particlePenalty)
    ret = struct('compute',@compute,'update',@update,'finished',@finished,'visualization',@visualization);                          
    
    function ret = compute(modes,path,vars)                  
        dists = distancesToLines(path(:,(end-1):end));        
        finalVars = vars(:,end);        
        numP = size(path,1);      
        avoidance = 0;        
        p = path(:,(end-1):end);
        [X1,X2] = meshgrid(p(:,1),p(:,1));
        [Y1,Y2] = meshgrid(p(:,2),p(:,2));
        D = sqrt((X1 - X2) .^ 2 + (Y1 - Y2) .^ 2);                        
        D = D ./ particleRadius;
        D = D + eye(numP,numP);
        avoidance = avoidance + sum(sum((D < 1) .* (1 ./ D - 1) * particlePenalty));                   
        ret = sqrt(sum((dists + stdWeight * sqrt(finalVars)) .^ 2)) + avoidance;
    end   

    function update(p,n,mode)
    end

    function d = distancesToLines(points)
        d = zeros(size(points,1),1);
        for i = 1:size(points,1)
           d(i) = distanceToAnyLine(points(i,:));
        end
    end

    function ret = distanceToAnyLine(point)
        d = zeros(size(lines,1),1);
        for i = 1:size(lines,1)
           d(i) = distanceToNearestLine(point,lines(i,:));
        end
        ret = min(d);
    end

    function ret = withinTolerance(points)                        
        ret = all(distancesToLines(points) < tolerance);
    end

    function ret = finished(p)          
        ret = withinTolerance(p);
    end

    function ret = visualization()
        ret = [];
        for i = 1:size(lines,1)
            ret = [ret;splitTargetList(reshape(lines(i,:),2,2)',0.02)];
        end                
    end
end