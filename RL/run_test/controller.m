function id = controller(position,policy)

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
    id = policy.getAction(position);
end
        