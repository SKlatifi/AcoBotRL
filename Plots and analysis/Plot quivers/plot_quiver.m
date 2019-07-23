  function cache = plot_quiver(D,freq,npoints,lw,linetype,cache)        
  if (nargin < 4)
      lw = 1;
  end
  if (nargin < 5)
      linetype = 'b-';
  end
  if (nargin < 6)
      cache = {};
  end
  
        index = find(abs(D.modeInfo.freq - freq) < 1);        
        if (length(cache) < index || isempty(cache{index}))        
            fitU = D.Map(index).fitU;
            fitV = D.Map(index).fitV;
            s = 1/(npoints*2);
            [pX,pY] = meshgrid(linspace(s,1-s,npoints),linspace(s,1-s,npoints));
            pU = fitU(pX,pY);
            pV = fitV(pX,pY);            
            cache{index} = {pX,pY,pU,pV};
        end
        pX = cache{index}{1};
        pY = cache{index}{2};
        pU = cache{index}{3};
        pV = cache{index}{4};
        lh = quiver(pX,pY,pU,pV,2.4,linetype);                
        set(gca, 'YDir', 'reverse');
        set(gca,'xtick',[])
        set(gca,'xticklabel',[])
        set(gca,'ytick',[])
        set(gca,'yticklabel',[])        
        axis([0 1 0 1]);
        set(lh,'linewidth',lw);    
        box off;       
    end