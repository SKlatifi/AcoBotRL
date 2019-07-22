function ret= beamPlanner(maxdepth,beamwidth)
    ret = @plan;

    function ret = plan(predict,computeCost,p,numCodes)
        solutions = {};
        solutions{1} = {[],p,zeros(size(p,1),1)}; % modes, path, stds

        for i = 1:maxdepth
            % Find all the children and costs of the children of the current solutions
            numChildren = length(solutions) * numCodes;
            children = cell(numChildren,1);
            childrenCosts = zeros(numChildren,1);
            index = 1;
            for j = 1:length(solutions)
                for k = 1:numCodes
                    modes = solutions{j}{1};
                    path = solutions{j}{2};
                    vars = solutions{j}{3};
                    [pnew,varnew] = predict(path(:,(end-1):end),vars(:,end),k);
                    cModes = [modes k];
                    cPath = [path pnew];
                    cStd = [vars varnew];                    
                    c = computeCost(cModes,cPath,cStd);
                    children{index} = {cModes,cPath,cStd}; 
                    childrenCosts(index) = c;
                    index = index + 1;
                end
            end

            % Sort children according to their costs
            [~,ind] = sort(childrenCosts);
            sortedSolutions = children(ind);
            n = min(beamwidth,length(sortedSolutions));

            % ...and keep only beamwidth     
            solutions = sortedSolutions(1:n);

            allSame = true;
            for j = 2:length(solutions)
                if solutions{j}{1}(1) ~= solutions{j-1}{1}(1)
                    allSame = false;
                    break;
                end
            end
            if (allSame)
                break;
            end
        end
        ret = [solutions{1}{1}(1) 1];
    end

end

