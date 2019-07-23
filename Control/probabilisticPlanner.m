function ret= probabilisticPlanner()
    ret = @plan;    
    
    function ret = plan(predict,computeCost,p,numCodes)        
        N = size(p,1);
        M = numCodes;
        h = 1e-6;           
        g = zeros(N,2);
        for i = 1:N
            for j = 1:2
                d = zeros(N,2);
                d(i,j) = h;
                g(i,j) = (computeCost([],p+d,zeros(N,1))-computeCost([],p-d,zeros(N,1))) / (2*h);
            end
            g(i,:) = g(i,:) / norm(g(i,:) + 1e-5);
        end
        beq = -reshape(g,N*2,1); % The movement should be in the direction of negative gradient
        Aeq = zeros(N*2,M);
        f = zeros(M,1);
        for i = 1:M
            [pnew,varnew] = predict(p,zeros(N,1),i);
            d = pnew - p;            
            Aeq(:,i) = reshape(d,N*2,1);
            f(i,1) = sum(varnew);
        end        
        lb = zeros(M,1);
        options=optimset('Display', 'off');
        x = linprog(f,[],[],Aeq,beq,lb,[],[],options);
        xsat = max(x,0); % Not really needed, unless the optimizer doesn't find a solution        
        cumx = cumsum(xsat / sum(xsat));        
        r = rand();
        ret = find(cumx > r,1);
        ret = [ret 1];
    end
end
        