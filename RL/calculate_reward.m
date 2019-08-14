function [reward_distance,reward_angle,beta,terminal] = ...
    calculate_reward(p_before,p,dir_before,target,gridNum)
 
    gain_dist = 5;
    sigma_dist = 0.2;
    gain_angle = 3;
    sigma_angle = 0.5;
    
    reward_distance = 0;
    reward_angle = 0;    
    
    delta_p = p - p_before;
    beta = dot(dir_before,delta_p,2)./(vecnorm(dir_before').*vecnorm(delta_p'))';
    
    if (min(min(p)) < 1/gridNum || max(max(p)) > 1-1/gridNum)
        terminal = 1;
        reward_distance = - 100;
    else
        terminal = 0;
        for i = 1: size(p,1)                
            if isequal(p(1,:),round(target(i,:).*gridNum)+ [1 1])                    
                reward_distance = reward_distance + 10;
            end
            reward_distance = reward_distance + (gain_dist/(sigma_dist*sqrt(2*pi))).*exp((-((p(i,1)-target(i,1)).^2)-(p(i,2)-target(i,2)).^2)/(2*sigma_dist^2));
            reward_angle = reward_angle + (gain_angle/(sigma_angle*sqrt(2*pi))).*exp(-(beta(i)-1)^2/(2*sigma_angle^2));
        end
    end
end