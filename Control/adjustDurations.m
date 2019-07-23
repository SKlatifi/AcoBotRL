function modes = adjustDurations(modes,desiredStepSize,minDur,maxDur)
    for i = 1:length(modes.frequencies)
        scale = getScale(modes.w{i}(:,1:2),modes.durations(i));       
        modes.w{i} = [modes.w{i}(:,1:2)*scale modes.w{i}(:,3)*scale^2];
        modes.durations(i) = modes.durations(i)*scale;
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