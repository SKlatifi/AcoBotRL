
clc;
clear all;
close all;

gridNum = 50;
datapath = getTempDataPath();
filename = 'vectorField_RL_2019_1.mat';
load(strcat(datapath,filename));

start = [0.35 0.35;
          0.65 0.35;
          0.35 0.65
          0.65 0.65];
target = [0.25 0.25;
          0.75 0.25;
          0.25 0.75
          0.75 0.75];

plate = simulatedPlateM(start,target,mapFunc,gridNum);
[policy] = learnpolicy(plate,start,target,mapFunc);

% partcl_numbr = 10;
% start = 0.2 + 0.6*rand(partcl_numbr,2);
% target = 0.2 + 0.6*rand(partcl_numbr,2);
% m = optimal_match(start,target);
% p = start(m(:,1),:);
% v = target(m(:,2),:);
% start = p;
% target = v;
% plot(start(:,1),start(:,2),'bo',target(:,1),target(:,2),'ro');
% axis([0 1 0 1]);   
