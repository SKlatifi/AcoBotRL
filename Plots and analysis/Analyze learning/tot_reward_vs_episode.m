
close all;
clear all
clc;

tempPath = getTempDataPath();
load(strcat(tempPath,'accumulated_reward_v2.mat'));

step_best = 60;
episode_max = 100;
real_reward = zeros(episode_max,1);

for i = 1:length(reward_list)
    normalized_coeff = step_best/step_list(i);
    real_reward(i) = normalized_coeff * reward_list(i);   
end

x = 1:episode_max;
y = real_reward(1:episode_max);

[fitresult, gof] = createFitExp(x, y);