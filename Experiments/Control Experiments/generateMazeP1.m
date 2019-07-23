function p0 = generateMazeP1()
       
    p0 = [0.2 0.5];
    p0 = [p0;line(p0(end,1),p0(end,2),0.25,0.5,1)]; 
    p0 = [p0;line(p0(end,1),p0(end,2),0.25,0.65,1)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.35,0.65,1)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.35,0.55,1)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.5,0.55,1)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.5,0.7,2)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.6,0.7,2)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.6,0.8,2)];

    function p = line(sx,sy,ex,ey,n)
       d = (1:n)' / n;
       x = (ex-sx) * d + sx;
       y = (ey-sy) * d + sy;
       p = [x y];
    end
end