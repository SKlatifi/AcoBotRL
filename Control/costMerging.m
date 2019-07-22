function ret = costMerging(targets,tolerance,seperationTolerance,finishingTolerance)
    ret = struct('compute',@compute,'update',@update,'finished',@finished,'visualization',@visualization);   
    
    if (nargin < 3)
        seperationTolerance = 0.2; % Seperation tolerance = 10 mm
    end
    
    if (nargin < 4)
        finishingTolerance = tolerance;
    end
    
    M = length(targets);
    cw = ones(M,1);
    tw = arrayfun(@(x) size(x{1},1),targets)';
    currentTarget = [];
%     weightMatrices = [];
    pickCurrentTarget();
    
    function ret = compute(modes,path,vars)
        p = path(:,(end-1):end);
        D = pdist(p);  
        formatSpec = 'Distance is %4.2f mm\n';
        fprintf(formatSpec,D*50);
        if D < seperationTolerance
            pause;
        end            
        ret = D;
    end  

    function pickCurrentTarget()        

        str = httpcommand('GetPosition');
        p = sscanf(str,'%f,%f; ');	
        p = reshape(p,2,length(p) / 2)';
        pixelSizeStr = httpcommand('GetSize');
        pixelSize = sscanf(pixelSizeStr,'%f,%f; ');
        p(:,1) = p(:,1) / pixelSize(1);
        p(:,2) = p(:,2) / pixelSize(2);
        currentTarget = p + (0.5 * (p - repmat(centroid(p),size(p,1),1)));
%         for i = 1:size(t,1)
%             currentTarget{i} = t(i,:);
%         end
%         splitT = arrayfun(@(x) splitTargetList(x{1},0.02),t,'UniformOutput',false);
%         p = cell2mat(arrayfun(@(x) x{1}(1,:)',t,'UniformOutput',false))';

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