function ret = generate_policy( theta, maps,target )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    ret = struct('getAction',@getAction,'getTheta',@getTheta);
    
    function ret = getAction(currentPosition)
        p = currentPosition;
        X = zeros(1,size(p,1));
        max_val =  -inf;
        for n=1:length(maps)
            for i = 1:size(p,1)
                xn=p(i,1)+maps(n).deltaX(p(i,1),p(i,2));
                yn=p(i,2)+maps(n).deltaY(p(i,1),p(i,2));
                X(i) = sqrt(sum((target(i,:) - [xn yn]).^2));
            end
                

            value = [1 X]*theta;
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

