function q_value = learnpolicy(plate,start,target)

global nets
datapath = getTempDataPath();
num_of_particles = size(target,1);
num_of_episodes = 200;
num_of_steps = 110;
epsilon = 1;
edge_ratio = 0.2;
q_value = struct;
q_value_all = struct;
gridNum = 50;
% adapt_rate = 0.1;

for n = 1:length(nets)
    q_value_all(n).pos = [];
    q_value_all(n).value = [];
end

tic
for i = 1:num_of_episodes %run for a number of episodes
    i
    init = choose_start(start,target,edge_ratio);
    plate.setPositions(init);
    terminal = 0;
    steps = 1;
    
    for n = 1:length(nets)
%         q_value(i,n).pos = [];
%         q_value(i,n).value = [];
        q_value(n).pos = [];
        q_value(n).value = [];
    end
             
    while(terminal~=1 && steps <= num_of_steps)                        
        p_before = plate.getPositions();
        action = epsilon_greedy(epsilon,p_before);
        plate.play(action);
        p = plate.getPositions();     
        [reward_dist,terminal] = calculate_reward(p,p_before,target,gridNum);                    
%         q_value(i,action).pos = [q_value(i,action).pos; ...
%             reshape(p_before',1,2*num_of_particles)];
%         q_value(i,action).value = [q_value(i,action).value; reward_dist];
        q_value(action).pos = [q_value(action).pos; ...
            reshape(p_before',1,2*num_of_particles)];
        q_value(action).value = [q_value(action).value; reward_dist]; 
        steps = steps + 1;
    end
    
    for n = 1:length(nets)        
%         q_value_all(n).pos = [q_value_all(n).pos; q_value(i,n).pos];
%         q_value_all(n).value = [q_value_all(n).value; q_value(i,n).value];
        q_value_all(n).pos = [q_value_all(n).pos; q_value(n).pos];
        q_value_all(n).value = [q_value_all(n).value; q_value(n).value];
    end        
    
%     if (mod(i,2) == 0)
    if (i)
        nets = initialize_nets(length(nets));
        for note = 1:length(nets)
            if ~isempty(q_value_all(note).pos)            
                inputs = q_value_all(note).pos';
                averaged_reward = q_value_all(note).value';
    %             outputs = nets(note).net(inputs);
    %             averaged_reward = (adapt_rate*q_value_new(note).value' + (1-adapt_rate)*outputs);
                nets(note).net = train(nets(note).net,inputs,averaged_reward);    
            end
        end
        toc
        save(strcat(datapath,'nets',num2str(i),'.mat'),'nets')
        tic
    end

end

toc
end

