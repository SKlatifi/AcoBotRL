
theta = [];
load('policy10.mat');
theta = [theta; transpose(policy.getTheta())];
load('policy100.mat');
theta = [theta; transpose(policy.getTheta())];
load('policy500.mat');
theta = [theta; transpose(policy.getTheta())];
load('policy1000.mat');
theta = [theta; transpose(policy.getTheta())];
load('policy2000.mat');
theta = [theta; transpose(policy.getTheta())];
load('policy5000.mat');
theta = [theta; transpose(policy.getTheta())];
load('policy10000.mat');

for i = 1:size(theta,2)
    plot(theta(:,i));
    hold on;
    pause
end


