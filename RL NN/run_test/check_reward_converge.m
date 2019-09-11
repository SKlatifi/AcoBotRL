% All units are normalized to the plate size: (0,0) is topleft corner,
% (1,0) is the topright corner; (0,1) is the bottomleft corner

close all;
clear all;
clc;

% Starting point for the manipulation     
start = [0.3 0.3];
target = [0.7 0.3];  

tolerance = 0.015; % At which distance the particle considered have reached the target, in plate units
mycontroller = @net_controller; % Replace this line to switch from one controller to another

datapath = getTempDataPath();
reward_path = 'reward_converge\';
mapfilename = 'vectorField_RL_2019_P2.mat';
load(strcat(datapath,mapfilename));
max_steps = 100;
reward_list = [];
step_list = [];

for i = 2:200 
    tic;
    i
    netfilename = strcat('nets',num2str(i),'.mat');
    load(strcat(datapath,reward_path,netfilename));

    global nets mapFunc

    % dataRecorder(...,'log',true) saves log file
    % dataRecorder(...,'plot','video') save a video
    recorder = dataRecorder('maps',mapFunc,'plot','none');

    % For simulation, use simulatedPlate.
    % In the final competition, we will replace this with realPlate
    plate = simulatedPlate(start,mapFunc);

    % Run the main control loop
    [reward_tot,num_step] = calc_reward_control(mycontroller,target,tolerance,plate,recorder,max_steps);
    reward_list = [reward_list; reward_tot];
    step_list = [step_list; num_step];

    % Clearing all references to the recorder calls the destructor for a
    % videoWriter, so the video file is not locked anymore and can be watched
    recorder = [];
    toc;
end

save(strcat(datapath,'accumulated_reward.mat'),'reward_list','step_list');