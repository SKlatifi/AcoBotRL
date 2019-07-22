function ret = controller(plate,model,cost,planner,recorder)
    ret = struct('init',@initialization,'run',@run);
    p = [];
    initialization();

    function p = matchLeft(p1,p2)
        m = match(p1,p2);
        msort = sortrows(m,2);
        p = p1(msort(:,1),:);
    end
    
    function p = matchClicks()
        c = plate.getClicks();
        for i = 1:10
            p = matchLeft(plate.findParticles(),c);                
            if (~isempty(p) && all(size(p) == size(c)))
            	return;
            end
        end        
        error('Could not find necessary number of particles');
    end

    function initialization()
        plate.visualize(cost.visualization(),cost.visualization(),cost.visualization(),[]);
        p = matchClicks();
        plate.visualize(p,p,cost.visualization(),[]);
    end  

    function run(steps)       
        if (nargin < 1)
            steps = inf;
        end
        step = 0;
        while(~cost.finished(p) && step < steps)                
            paramCodes = planner(model.predict,cost.compute,p,model.numCodes());                                         
            phat = model.predict(p,zeros(size(p,1),1),paramCodes);
            plate.visualize(p,phat,cost.visualization(),model.visualization(paramCodes));            
            playedNotes = model.getParams(p,paramCodes);
            plate.play(playedNotes);            
            for i = 1:10
                n = matchLeft(plate.findParticles(),p);                        
                if (~isempty(n) && all(size(n) == size(p)))
                    break;
                end
            end
            if (isempty(n) || any(size(n) ~= size(p)))
                n = matchClicks();
            end            
            model.update(p,n,paramCodes);
            cost.update(p,n,paramCodes); 
            if (~isempty(recorder))
                recorder.record(p,phat,n,cost.visualization(),paramCodes,playedNotes);
            end
            p = n;  
            step = step + 1;
        end
    end
end