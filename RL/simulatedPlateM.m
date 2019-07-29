function ret = simulatedPlateM(p,target,maps,gridNum)        
    % simulatedPlate  Constructor for creating a mockup plate object
    %
    %                 plate = simulatedPlate(p,maps) creates a simulated plate
    %                   using the maps struct array and p starting point
    
    ret = struct('play',@play,'setPositions',@setPositions,'getPositions',@getPositions,'setTarget',@setTarget,'nextState',@nextState);                       
    
    % In real plate, this will show the target in the machine vision
    function setTarget(~)        
    end   

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
        noise = (sqrt(max(maps(frequencyId).variance(p),0)) * [1 1]) .* randn(size(p));
        p = p + [maps(frequencyId).deltaX(p),maps(frequencyId).deltaY(p)] + noise;        
        pause(1e-6); % slow things down just enough matlab has time to plot things
    end

    % In real plate, this will perform machine vision
    function ret = getPositions()
        ret = p;
    end
    %get next stae, reward and check if terminal
    function [terminal, snext, reward] = nextState()
 
        snext = [];
        reward = 0;
        for i = 1: size(p,1)
            snext(i,:) = round(p(i,:).*gridNum) + [1 1];
        end

        if (min(min(p)) < 1/gridNum || max(max(p)) > 1-1/gridNum)
            terminal = 1;
            reward = - 100;
        else
            gain = 1;
            sigma = 0.05;
            terminal = 0;
            for i = 1: size(p,1)
               if isequal(snext(1,:),round(target(i,:).*gridNum)+ [1 1])
                    reward = reward + 10;
               end
            reward = reward + (gain/(sigma*sqrt(2*pi))).*exp((-((p(i,1)-target(i,1)).^2)-(p(i,2)-target(i,2)).^2)/(2*sigma));
            end
        end
    end
end