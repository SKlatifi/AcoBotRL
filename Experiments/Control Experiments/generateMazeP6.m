function p0 = generateMazeP6()
       
    p0 = [0.75 0.6];
    p0 = [p0;line(p0(end,1),p0(end,2),0.7,0.6,2)]; 
    p0 = [p0;line(p0(end,1),p0(end,2),0.7,0.55,2)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.7,0.45,4)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.7,0.4,2)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.7,0.35,2)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.65,0.35,2)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.55,0.35,4)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.55,0.3,2)];
    
    function p = line(sx,sy,ex,ey,n)
       d = (1:n)' / n;
       x = (ex-sx) * d + sx;
       y = (ey-sy) * d + sy;
       p = [x y];
    end
end