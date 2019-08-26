% All units are normalized to the plate size: (0,0) is topleft corner,
% (1,0) is the topright corner; (0,1) is the bottomleft corner

close all;
clear all;
clc;

% Starting point for the manipulation     
start = [0.7 0.4];
target = [0.3 0.4];   

tolerance = 0.015; % At which distance the particle considered have reached the target, in plate units
mycontroller = @net_controller; % Replace this line to switch from one controller to another

datapath = getTempDataPath();
mapfilename = 'vectorField_RL_2019_P2.mat';
netfilename = 'nets2.mat';
load(strcat(datapath,mapfilename));
load(strcat(datapath,netfilename));

global nets mapFunc

% dataRecorder(...,'log',true) saves log file
% dataRecorder(...,'plot','video') save a video
recorder = dataRecorder('maps',mapFunc,'plot','video');

% For simulation, use simulatedPlate.
% In the final competition, we will replace this with realPlate
plate = simulatedPlate(start,mapFunc);

% Run the main control loop
steps = controlLoop(mycontroller,target,tolerance,plate,recorder);
fprintf('Manipulation completed in %d steps\n',steps);

% Clearing all references to the recorder calls the destructor for a
% videoWriter, so the video file is not locked anymore and can be watched
recorder = [];