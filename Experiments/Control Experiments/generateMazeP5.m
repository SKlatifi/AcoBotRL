function p0 = generateMazeP5()
       
    p0 = [0.25 0.5];
    p0 = [p0;line(p0(end,1),p0(end,2),0.3,0.5,2)]; 
    p0 = [p0;line(p0(end,1),p0(end,2),0.3,0.5,2)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.35,0.6,4)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.4,0.6,2)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.4,0.55,2)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.45,0.55,2)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.45,0.65,4)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.45,0.7,2)];
    
    function p = line(sx,sy,ex,ey,n)
       d = (1:n)' / n;
       x = (ex-sx) * d + sx;
       y = (ey-sy) * d + sy;
       p = [x y];
    end
end