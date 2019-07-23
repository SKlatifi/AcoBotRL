function p0 = generateL()
       
    p0 = [0.3 0.38];
    p0 = [p0;line(p0(end,1),p0(end,2),0.3,0.62,69)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.44,0.62,40)];
    
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