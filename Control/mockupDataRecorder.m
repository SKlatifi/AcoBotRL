function ret = mockupDataRecorder(filename)
    fig = figure();
    axis([0 1 0 1]);
    if (nargin<  1)
        filename = ['../../TempData/data_' datestr(now,'yymmdd_HHMMSS') '.txt'];        
    end    
    
    ret = struct('record',@record);            
    
    function record(p,phat,n,t,paramCode,playedNotes)
        figure(fig);
        hold on;
        plot(p(:,1),p(:,2),'k.');
        set(gca, 'YDir', 'reverse');        
        hold off;                
        s = [flat(size(paramCode)) flat(size(playedNotes)) flat(size(p)) flat(size(t))];
        M = [s flat(paramCode) flat(playedNotes) flat(p) flat(phat) flat(n) flat(t)];
        dlmwrite(filename,M,'-append') 
    end

    function ret = flat(d)
        ret = reshape(d,1,numel(d));
    end
end