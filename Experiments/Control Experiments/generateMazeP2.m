function p1 = generateMazeP2()
       
    p1 = [0.8 0.8];
    p1 = [p1;line(p1(end,1),p1(end,2),0.75,0.8,1)]; 
    p1 = [p1;line(p1(end,1),p1(end,2),0.75,0.25,4)];
    p1 = [p1;line(p1(end,1),p1(end,2),0.65,0.25,1)];
    p1 = [p1;line(p1(end,1),p1(end,2),0.65,0.35,1)];
    p1 = [p1;line(p1(end,1),p1(end,2),0.55,0.35,1)];
    p1 = [p1;line(p1(end,1),p1(end,2),0.55,0.25,1)];
    p1 = [p1;line(p1(end,1),p1(end,2),0.5,0.25,1)];
    p1 = [p1;line(p1(end,1),p1(end,2),0.5,0.2,1)];

    function p = line(sx,sy,ex,ey,n)
       d = (1:n)' / n;
       x = (ex-sx) * d + sx;
       y = (ey-sy) * d + sy;
       p = [x y];
    end
end