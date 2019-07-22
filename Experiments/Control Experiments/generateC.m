function p0 = generateC()
    
    p0 = arc(0.7,0.48,0.1,270,180,50);
    p0 = [p0;line(p0(end,1),p0(end,2),0.6,0.52,10)];
    p0 = [p0;arc(0.7,0.52,0.1,180,90,50)];      
    
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

end