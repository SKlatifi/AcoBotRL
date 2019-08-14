function [policy,thetaLearn] = learnpolicy( plate,start, target,maps)

datapath = getTempDataPath();
num_of_episodes = 1000;
num_of_steps = 50;
theta = zeros(2*size(start,1)+1, 1); % initialize fitting parameters
theta_dist = zeros(size(start,1)+1, 1);
theta_beta = zeros(size(start,1), 1);
thetaLearn = theta;
alpha_dist = 0.01;
alpha_angle = 0.002;
gridNum = 50;
tic
for i = 1:num_of_episodes %run for a number of episodes
    start = rand(size(start));
    plate.setPositions(start);
    terminal = 0;
    steps = 1;
    dir_before = target - start;
             
    while(terminal~=1 && steps <= num_of_steps)
        
        action = randi(size(maps,2));
        p_before = plate.getPositions();
        plate.play(action);
        p = plate.getPositions();
        [reward_dist,reward_angle,beta,terminal] = calculate_reward(p_before,p,dir_before,target,gridNum);                     
        
        for j = 1:size(start,1)
            dist(j) = sqrt(sum((target(j,:) - p(j,:)).^2));
        end
        
        X_dist = [1 dist];
        X_beta = beta';
        theta_dist = theta_dist - alpha_dist*X_dist'*(X_dist*theta_dist - reward_dist);         
        theta_beta = theta_beta - alpha_angle*X_beta'*(X_beta*theta_beta - reward_angle);
        theta = [theta_dist; theta_beta];
        steps = steps + 1;
    end
    thetaLearn = [thetaLearn theta];
    
    
    policy = generate_policy(theta, maps,target);

    if (i == 10|| i == 100|| i == 500 || i == 1000 ||i == 2000 || i == 5000 || i == 10000|| i == 50000)
        i
        toc
        save(strcat(datapath,'policy',num2str(i),'.mat'),'policy','thetaLearn')
        tic
    end
end

toc
end

