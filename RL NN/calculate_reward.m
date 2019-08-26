function [reward_distance,terminal] = calculate_reward(p,p_before,target,gridNum)
 
    terminal = 0;
    
    if (min(min(p)) < 1/gridNum || max(max(p)) > 1-1/gridNum)
        terminal = 1;
    end
    
    dp = p - p_before;
    dist = target - p;
    
    projection = dot(dp,dist,2)./dot(dist,dist,2) .* dist;
    reward_sign = sign(dot(projection,dist,2));
    reward_distance = reward_sign * norm(vecnorm(projection,2,2));
    
%     gain_dist = 0.005;
%     sigma_dist = 0.2;   
%     reward_distance = 0;
    
%     if (min(min(p)) < 1/gridNum || max(max(p)) > 1-1/gridNum)
%         terminal = 1;
%         reward_distance = - 100*gain_dist;
%     else
%         terminal = 0;
%         for i = 1: size(p,1)                
%             if isequal(p(1,:),round(target(i,:).*gridNum)+ [1 1])                    
%                 reward_distance = reward_distance + 10*gain_dist;
%             end
%             reward_distance = reward_distance + (gain_dist/(sigma_dist*sqrt(2*pi))).*exp((-((p(i,1)-target(i,1)).^2)-(p(i,2)-target(i,2)).^2)/(2*sigma_dist^2));            
%         end
%     end
end