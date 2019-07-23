function p = generateLineDroplet()    
    numWayPoints = 20;
    p = [0.23 0.25];
    p = [p;line(p(end,1),p(end,2),0.73,0.25,numWayPoints)];
    
    function p = line(sx,sy,ex,ey,n)
       d = (1:n)' / n;
       x = (ex-sx) * d + sx;
       y = (ey-sy) * d + sy;
       p = [x y];
    end

end