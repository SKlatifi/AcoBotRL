function p = generateSquare()    
    numWayPoints = 100;
    p = [0.25 0.25];
    p = [p;line(p(end,1),p(end,2),0.75,0.25,numWayPoints)]; 
    p = [p;line(p(end,1),p(end,2),0.75,0.75,numWayPoints)];
    p = [p;line(p(end,1),p(end,2),0.25,0.75,numWayPoints)];
    p = [p;line(p(end,1),p(end,2),0.25,0.25,numWayPoints)];
    
    function p = arc(cx,cy,r,afrom,ato,n)
       a = linspace(afrom,ato,n)';
       x = cosd(a) * r + cx;
       y = sind(a) * r + cy;
       p = [x y];
    end

    function p = line(sx,sy,ex,ey,n)
       d = (1:n)' / n;
       x = (ex-sx) * d + sx;
       y = (ey-sy) * d + sy;
       p = [x y];
    end

    function ret = lerp(a,b,alpha)
        ret = (1-alpha)*a + alpha*b;
    end
end

