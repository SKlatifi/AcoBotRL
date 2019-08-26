function id = net_controller(position,target,tolerance)

    % controller    Decides the id of the frequency that should be played.
    %               Usage:
    %
    %               id = controller(maps,position,target)
    %               
    %               maps is a struct array of length M and id should be
    %                  index to this array (1..M).
    %               position is the current position(s) of the particle(s)
    %               target is the current target(s) of the particle(s).
    %    
    %               The predicted movement of a particle after returning id
    %               is pnew = p + [maps(id).deltaX(p) maps(id).deltaY(p)].
    
    % TODO: Implement your controller here.
    %id = randi([1,length(maps)]);
    global nets mapFunc
    num_of_particles = size(target,1);
        
    if vecnorm(target - position) < tolerance
        min_val = inf;
        for n = 1:length(mapFunc)
            p_new = position + [mapFunc(n).deltaX(position) mapFunc(n).deltaY(position)];
            value = vecnorm(target - p_new);
            if value < min_val
                min_val = value;
                id = n;
            end        
        end 
    else
        max_val = -inf;
        for n = 1:length(nets)
            p = reshape(position',1,2*num_of_particles);
            value = nets(n).net(p');
            if max_val < value
                max_val = value;
                id = n;
            end        
        end    
    end
end
        