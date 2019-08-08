function id = RL_controller(position,policy,Nmodes)   

    % controller    Decides the id of the frequency that should be played.
    %               Usage:
    
    persistent last_positions;
    N = size(position,1);
    last_positions = [last_positions; position];
    
    if size(last_positions,1) > 2*N        
        if (vecnorm(last_positions(end-2*N+1:end-N,:) - position) < 0.0001*N)
            id = randi(Nmodes);
            return
        end
    end
        
    id = policy.getAction(position);
    
end
        