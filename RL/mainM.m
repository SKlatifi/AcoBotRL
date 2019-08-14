
clc;
clear all;
close all;

datapath = getTempDataPath();
filename = 'vectorField_RL_2019_P2.mat';
load(strcat(datapath,filename));

start = [0.5 0.25;
          0.3 0.7;
          0.7 0.7];
target = [0.5 0.4;
         0.4 0.62;
         0.6 0.62];
     
randomness = zeros(size(target,1),1);
plate = simulatedPlateM(start,mapFunc,randomness);
[policy,thetaLearn] = learnpolicy(plate,start,target,mapFunc);