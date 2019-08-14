function ret = simulatedPlateM(p,maps,randomness)        
    % simulatedPlate  Constructor for creating a mockup plate object
    
    ret = struct('play',@play,'setPositions',@setPositions,'getPositions',@getPositions);                       
    
    %set current position of the particle
    function setPositions(currentPosition)
        p = currentPosition;
    end

    % In real plate, this will play real sound
    % The mockup plate simulates the movement based on deltaX and deltaY,
    % adding some randonmness based on the variance maps
    function play(frequencyId)
        if (frequencyId < 1 || frequencyId > length(maps))
            error('Invalid frequencyId, should be between 1..%d (was: %d)',length(maps),frequencyId);
        end                
        randomness = sqrt(max(maps(frequencyId).variance(p),0));
        dx = maps(frequencyId).deltaX(p);
        dy = maps(frequencyId).deltaY(p);        
        noise = (randomness * [1 1]) .* randn(size(p));        
        p = p + [dx,dy] + noise;          
    end

    % In real plate, this will perform machine vision
    function ret = getPositions()
        ret = p;
    end

end