function id = epsilon_greedy(epsilon,position)

global nets
N = length(nets);
p = rand(1);
if p < epsilon
    id = randi(N);
else
    max_val = -inf;
    for n = 1:N
        value = nets(n).net(position');
        if max_val < value
            max_val = value;
            id = n;
        end        
    end  
end

end