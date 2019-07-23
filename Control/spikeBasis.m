function ret = spikeBasis(p,gridSize)        
    ret = sparse((gridSize+1)*(gridSize+1),size(p,1));   
    s = gridSize+1;
    for i = 1:size(p,1)
        xx = p(i,1) * gridSize;
        yy = p(i,2) * gridSize;
        ix = floor(xx);
        iy = floor(yy);
        rx = xx - ix;
        ry = yy - iy;                        
        if (ix >= 0 && ix <= gridSize && iy >= 0 && iy <= gridSize)                
            ret(ix+1+iy*s,i) = (1-rx)*(1-ry);
        end
        if (ix+1 >= 0 && ix+1 <= gridSize && iy >= 0 && iy <= gridSize)                
            ret(ix+2+iy*s,i) = rx*(1-ry);
        end
        if (ix >= 0 && ix <= gridSize && iy+1 >= 0 && iy+1 <= gridSize)                
            ret(ix+1+(iy+1)*s,i) = (1-rx)*ry;
        end
        if (ix+1 >= 0 && ix+1 <= gridSize && iy+1 >= 0 && iy+1 <= gridSize)                
            ret(ix+2+(iy+1)*s,i) = rx*ry;
        end
    end
end   