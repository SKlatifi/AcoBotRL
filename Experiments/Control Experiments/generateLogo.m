function p = generateLogo()    
    p = [0.1 0.8];
    p = [p;line(p(end,1),p(end,2),0.3,0.1,100)];    
    p = [p;line(p(end,1),p(end,2),lerp(0.3,0.5,(0.55-0.1)/0.7),0.55,80)];
    p = [p;line(p(end,1),p(end,2),lerp(0.3,0.1,(0.55-0.1)/0.7)+0.05,0.55,80)];
    p = [p;line(p(end,1),p(end,2),lerp(0.3,0.1,(0.6-0.1)/0.7)+0.05,0.6,80)];
    p = [p;line(p(end,1),p(end,2),lerp(0.3,0.5,(0.6-0.1)/0.7),0.6,80)];    
    p = [p;line(p(end,1),p(end,2),0.5,0.8,40)];
    p = [p;line(p(end,1),p(end,2),0.65,0.8,20)];
    p = [p;arc(p(end,1)+0.05,p(end,2),0.05,180,-90,40)];
    p = [p;line(p(end,1),p(end,2),0.7,0.5,40)];
    p = [p;arc(p(end,1),p(end,2)-0.2,0.2,90,90-230,100)];
    
    p(:,1) = (p(:,1) -0.5) * 0.9 + 0.5;
    p(:,2) =(p(:,2) -0.5) * 0.9 + 0.5 + 0.05;
    
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

