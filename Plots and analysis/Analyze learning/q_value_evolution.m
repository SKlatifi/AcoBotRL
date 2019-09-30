
close all;
clear all
clc;

tempPath = getTempDataPath();
load(strcat(tempPath,'reward_converge\NetMat40.mat'));
num_episodes = 200;
selected_episodes = [2 10 50 200];

epi = 1:size(NetMat,3);
error = zeros(size(epi));


S = zeros(size(NetMat,1),size(NetMat,2));
N_av = 10;
for i = 1:N_av
    S = S + NetMat(:,:,end-i+1);
end
S = S/N_av;

for i = 1:size(NetMat,3)
    error(i) = sum(sum(abs(S - NetMat(:,:,i))));   
end

plot(epi(1:end),error(1:end));

save(strcat(tempPath,'Error_vs_episode_note40.mat'),'epi','error');
