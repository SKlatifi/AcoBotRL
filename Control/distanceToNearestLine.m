function ret = distanceToNearestLine(point,line)        
    tangent = (line(3:4) - line(1:2));
    diff = point - line(1:2);
    relprojection = dot(diff,tangent) / dot(tangent,tangent); 
    if (relprojection < 0)
        ret = norm(point - line(1:2),2);
        return;
    elseif (relprojection > 1)
        ret = norm(point - line(3:4),2);
        return;
    else
        ret = norm(point - (line(1:2) + relprojection * tangent),2);
        return;
    end                                            
end
