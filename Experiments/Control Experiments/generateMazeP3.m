function p0 = generateMazeP3()
       
    p0 = [0.25 0.25];
    p0 = [p0;line(p0(end,1),p0(end,2),0.35,0.25,1)]; 
    p0 = [p0;line(p0(end,1),p0(end,2),0.35,0.35,1)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.45,0.35,1)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.45,0.45,1)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.5,0.45,1)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.5,0.4,1)];
    
    function p = line(sx,sy,ex,ey,n)
       d = (1:n)' / n;
       x = (ex-sx) * d + sx;
       y = (ey-sy) * d + sy;
       p = [x y];
    end
end