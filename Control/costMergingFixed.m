function ret = costMergingFixed(targets,tolerance,lineWeight,stdWeight,particleRadius,particlePenalty,finishingTolerance)
    ret = struct('compute',@compute,'update',@update,'finished',@finished,'visualization',@visualization);   
    
    if (nargin < 7)
        finishingTolerance = tolerance;
    end
    
    M = length(targets);
    cw = ones(M,1);
    tw = arrayfun(@(x) size(x{1},1),targets)';
    currentTarget= [];
    weightMatrices = [];
    pickCurrentTarget();
    
    function ret = compute(modes,path,vars)          
        deltas = currentTarget - path(:,(end-1):end);
        dists = zeros(M,1);
        for i = 1:M
            d = deltas(i,:) * squeeze(weightMatrices(i,:,:));
            dists(i) = sqrt(sum(d .^ 2,2));
        end       
        finalVars = vars(:,end);        
        numP = size(path,1);                      
        ret = sqrt(sum((dists + stdWeight * sqrt(finalVars)) .^ 2));
    end   

    function pickCurrentTarget()        
        currentTarget = cell2mat(arrayfun(@(i) targets{i}(cw(i),:)',1:M,'UniformOutput',false))';        
        weightMatrices = zeros(M,2,2);
        for i = 1:M
            ind = cw(i);
            if (ind > 1)
                delta = targets{i}(ind,:)-targets{i}(ind-1,:);
                deltan = delta / norm(delta,2);
                weightMatrices(i,:,:) = [deltan(1) deltan(2);-deltan(2)*(1+lineWeight) deltan(1)*(1+lineWeight)];
            else
                weightMatrices(i,:,:) = eye(2,2);
            end
        end
    end
        
    function update(p,n,mode)
        for i = 1:M
            while(cw(i) < tw(i) && withinTolerance(n(i,:),targets{i}(cw(i),:),tolerance))                
                cw(i) = cw(i) + 1;
            end                
        end       
        pickCurrentTarget();    
    end

    function ret = withinTolerance(point,target,tol)
        delta = target - point;
        dist = sqrt(sum(delta .^ 2,2));        
        ret = all(dist < tol);
    end

    function ret = finished(p)  
        ft = cell2mat(arrayfun(@(x) x{1}(end,:)',targets,'UniformOutput',false))';
        ret = all(cw == tw) && withinTolerance(p,ft,finishingTolerance);
    end
        

    function ret = visualization()
        ret = currentTarget;
    end
end