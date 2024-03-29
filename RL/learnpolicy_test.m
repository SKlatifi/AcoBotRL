function ret = learnpolicy_test( plate,start, target,maps)

datapath = getTempDataPath();
num_of_episodes = 10000;
theta = zeros(size(start,1)+1, 1); % initialize fitting parameters
alpha = 0.01;
x_list = [];
reward_list = [];
tic
for i = 1:num_of_episodes %run for a number of episodes
    start = rand(size(start));
    %current_state = round(start.*gridNum) + [1 1]
    plate.setPositions(start);
    terminal = 0;
    steps = 1;
             
    while(terminal~=1 && steps <= 5)
        
        action = randi(size(maps,2));

        plate.play(action);
        [terminal, ~ , reward] = plate.nextState();
        p = plate.getPositions();
        
        for j = 1:size(start,1)
            x(j) = sqrt(sum((target(j,:) - p(j,:)).^2));
        end
        x_list = [x_list; x];
        reward_list = [reward_list; reward];
        
        steps = steps + 1;
    end

    if (i == 10|| i == 100|| i == 500 || i == 1000 ||i == 2000 || i == 5000 || i == 10000|| i == 50000)
        i
        toc
        save(strcat(datapath,'policy',num2str(i),'.mat'),'x_list','reward_list')
        tic
    end
end

ret = 1;

toc
end

