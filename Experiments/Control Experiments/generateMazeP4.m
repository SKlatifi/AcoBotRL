function p1 = generateMazeP4()
       
    p1 = [0.75 0.75];
    p1 = [p1;line(p1(end,1),p1(end,2),0.65,0.75,1)]; 
    p1 = [p1;line(p1(end,1),p1(end,2),0.65,0.65,1)];
    p1 = [p1;line(p1(end,1),p1(end,2),0.55,0.65,1)];
    p1 = [p1;line(p1(end,1),p1(end,2),0.55,0.55,1)];
    p1 = [p1;line(p1(end,1),p1(end,2),0.5,0.55,1)];
    p1 = [p1;line(p1(end,1),p1(end,2),0.5,0.5,1)];

    function p = line(sx,sy,ex,ey,n)
       d = (1:n)' / n;
       x = (ex-sx) * d + sx;
       y = (ey-sy) * d + sy;
       p = [x y];
    end
end