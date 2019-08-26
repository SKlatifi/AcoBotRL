
clc;
clear all;
close all;

global nets mapFunc

load('vectorField_RL_2019_P2.mat');

num_of_notes = length(mapFunc);
nets = initialize_nets(num_of_notes);

start = [0.7 0.4];
target = [0.3 0.4];
     
randomness = zeros(size(target,1),1);

plate = simulatedPlateM(start,mapFunc,randomness);
q_value = learnpolicy(plate,start,target);