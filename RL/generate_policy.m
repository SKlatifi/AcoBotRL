function ret = generate_policy(theta,maps,target)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    ret = struct('getAction',@getAction,'getTheta',@getTheta);
    
    function ret = getAction(currentPosition)
        p = currentPosition;
        dist = zeros(1,size(p,1));
        beta = zeros(1,size(p,1));
        max_val =  -inf;
        for n=1:length(maps)
            for i = 1:size(p,1)                
                dir_before = target(i,:) - p(i,:);
                dx = maps(n).deltaX(p(i,1),p(i,2));
                dy = maps(n).deltaY(p(i,1),p(i,2));
                xn = p(i,1) + dx;
                yn = p(i,2) + dy;
                dist(i) = sqrt(sum((target(i,:) - [xn yn]).^2));
                beta(i) = dot(dir_before,[dx,dy])/(norm(dir_before)*norm([dx,dy]));
            end

            value = [1 dist beta]*theta;
            if max_val<value
                max_val=value;
                id=n;
            end
            ret = id;
        end
    
    end

    function ret = getTheta()
        ret = theta;
    end

end

