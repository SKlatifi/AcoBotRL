function p = line2()    
    numWayPoints = 10;
    p = [0.7 0.7];
    p = [p;line(p(end,1),p(end,2),0.3,0.7,numWayPoints)];
    
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