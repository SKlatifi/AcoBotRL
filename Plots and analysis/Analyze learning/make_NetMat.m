
close all;
clear all
clc;

tempPath = getTempDataPath();
numGrid = 20;
x = linspace(0,1,numGrid);
y = linspace(0,1,numGrid);

num_episodes = 200;
selected_note = 40;
NetMat = zeros(numGrid,numGrid,num_episodes);

for n = 1:num_episodes
    load(strcat(tempPath,'reward_converge\nets',num2str(n),'.mat'));
    n
    tic
    for i = 1:numGrid
        for j = 1:numGrid
            P = [x(j); y(i)];          
            NetMat(i,j,n) = nets(selected_note).net(P);            
        end
    end
    toc;
end


