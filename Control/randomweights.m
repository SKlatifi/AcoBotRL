

frequencies = f;
        numCodes = length(f);    
        m = (gridSize+1)*(gridSize+1);
        w = cell(numCodes,1);
        R = cell(numCodes,1);        
        gains = ones(numCodes,1);    
        durations = ones(numCodes,1);
        for v = 1:numCodes
            w{v} = randn(m,3)*1e-8;
            R{v} = sparse(eye(m,m));            
        end
