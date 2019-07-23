function modes = fromData(modeInfo,ppmap,gridsize,normalize)
    modes = struct();    
    modes.frequencies = modeInfo.freq;
    modes.gains = modeInfo.amp;
    modes.durations = modeInfo.duration / 1000;    
    modes.w = cell(length(ppmap),1);
    modes.gridSize = gridsize;
    for i = 1:length(ppmap)      
        s = size(ppmap(i).gU);
        x = round(linspace(1,s(2),gridsize+1));
        y = round(linspace(1,s(1),gridsize+1));                
        if (nargin < 4 || normalize)
            gu = ppmap(i).gU(y,x)' / s(2);
            gv = ppmap(i).gV(y,x)' / s(1);
            std = ppmap(i).STD(y,x)' * 2 / (s(1) + s(2));        
        else
            gu = ppmap(i).gU(y,x)';
            gv = ppmap(i).gV(y,x)';
            std = ppmap(i).STD(y,x)';        
        end
        modes.w{i} = [gu(:) gv(:) std(:).^2];        
    end       
end