function [reward_tot,step] = calc_reward_control(mycontroller,target,tolerance,plate,recorder,max_steps)
    gridNum = 50;
    step = 0;   
    reward_tot = 0;
    % Show the target on the machine vision
    plate.setTarget(target);              
    % Fetch the latest positions from machine vision
    curPos = plate.getPositions();
    % Loop until the object is within tolerance of the target
    while any(distance(curPos,target) > tolerance) && (step < max_steps)           
        % Ask the controller which frequency to play next
        frequencyId = mycontroller(curPos,target,2*tolerance);                                                 
        % Play the frequency       
        plate.play(frequencyId); 
        % Get the positions after playing the frequency
        nextPos = plate.getPositions();
        [reward,~] = calculate_reward(nextPos,curPos,target,gridNum);
        reward_tot = reward_tot + reward;
        if (nargin > 4 && ~isempty(recorder))
            % Save/show the data
            recorder(curPos,nextPos,target,frequencyId);
        end
        curPos = nextPos;  
        step = step + 1;   
    end    
    
    function ret = distance(from,to)
        ret = sqrt(sum((from-to).^2,2));
    end
end