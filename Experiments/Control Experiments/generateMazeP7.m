function p0 = generateMazeP7()

    p0 = [0.2 0.25];
    p0 = [p0;line(p0(end,1),p0(end,2),0.43,0.25,7)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.43,0.35,3)];    
    p0 = [p0;line(p0(end,1),p0(end,2),0.56,0.35,4)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.56,0.48,4)]; 
    p0 = [p0;line(p0(end,1),p0(end,2),0.65,0.48,3)]; 
    p0 = [p0;line(p0(end,1),p0(end,2),0.65,0.65,5)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.75,0.65,3)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.75,0.55,3)];
    p0 = [p0;line(p0(end,1),p0(end,2),0.8,0.55,2)];

%     p0 = [0.8 0.25];
%     p0 = [p0;line(p0(end,1),p0(end,2),0.55,0.25,7)];
%     p0 = [p0;line(p0(end,1),p0(end,2),0.55,0.45,6)];    
%     p0 = [p0;line(p0(end,1),p0(end,2),0.65,0.45,3)];
%     p0 = [p0;line(p0(end,1),p0(end,2),0.65,0.55,3)]; 
%     p0 = [p0;line(p0(end,1),p0(end,2),0.55,0.55,3)]; 
%     p0 = [p0;line(p0(end,1),p0(end,2),0.55,0.75,6)];
%     p0 = [p0;line(p0(end,1),p0(end,2),0.35,0.75,6)];
%     p0 = [p0;line(p0(end,1),p0(end,2),0.35,0.8,2)];    
% 
    
    function p = line(sx,sy,ex,ey,n)
       d = (1:n)' / n;
       x = (ex-sx) * d + sx;
       y = (ey-sy) * d + sy;
       p = [x y];
    end
end