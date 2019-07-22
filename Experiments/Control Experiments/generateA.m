function p = generateA(rotflag)
       
    p = [0.1 0.8];
    p = [p;line(p(end,1),p(end,2),0.3,0.1,70)];    
    p = [p;line(p(end,1),p(end,2),lerp(0.3,0.5,(0.55-0.1)/0.7),0.55,30)];
    p = [p;line(p(end,1),p(end,2),lerp(0.3,0.1,(0.55-0.1)/0.7)+0.05,0.55,30)];
    p = [p;line(p(end,1),p(end,2),lerp(0.3,0.1,(0.6-0.1)/0.7)+0.05,0.6,30)];
    p = [p;line(p(end,1),p(end,2),lerp(0.3,0.5,(0.6-0.1)/0.7),0.6,30)];    
    p = [p;line(p(end,1),p(end,2),0.5,0.8,40)];     
    
    if rotflag
        R = [0 1; -1 0];
        p = transpose(R*transpose(p));
        T = [0 1];
        Tfinal = repmat(T,length(p),1);
        p = p + Tfinal;
    end            
    
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

