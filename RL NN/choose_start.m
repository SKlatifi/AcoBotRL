function initial_state = choose_start(start,target,edge_ratio)

rand_x = rand;
rand_y = rand;

for i = 1:size(start,1)
    
    if abs(target(i,1) - start(i,1))
        W = edge_ratio * abs(target(i,1) - start(i,1));
    else
        W = 0.1;
    end
    
    if abs(target(i,2) - start(i,2))
        H = edge_ratio * abs(target(i,2) - start(i,2));
    else
        H = 0.1;
    end
    
    x_min = min(start(i,1),target(i,1)) - W;
    y_min = min(start(i,2),target(i,2)) - H;
    x_max = max(start(i,1),target(i,1)) + W;
    y_max = max(start(i,2),target(i,2)) + H;
    initial_state(i,:) = [x_min + rand_x*(x_max - x_min) y_min + rand_y*(y_max - y_min)];
end

end

function ret = rand_bound(min,max)
    % Generates a uniform random number between min and max
    ret = min + rand*(max - min);
end

