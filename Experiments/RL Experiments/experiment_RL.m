
clear all;
close all;

% targets = [0.5 0.5];
target = [0.25 0.25;
          0.75 0.75];
% targets = [0.5 0.3; 0.5 0.4; 0.6 0.4; 0.6 0.3; 0.5 0.3];
tolerance = 0.03;
% mycontroller = linearProgrammingController(0.5); % Replace this line to switch from one planner to another

%% Load models and modeInfo; and generate the output
datapath = [getTempDataPath 'RL_P2\'];
datafile = [datapath 'P2_' datestr(now,'yymmdd_HHMMSS') '.txt'];
vector_field_file = [getTempDataPath() 'vectorField_RL_2019_1.mat'];
policy_file = [getTempDataPath() 'policy10000.mat'];
load(vector_field_file);
load(policy_file);

%%
mycontroller = @RL_controller;
% load('maps.mat');
% load('modeInfo.mat');
modeInfo.amp = modeInfo.amp * 1;
modeInfo.duration = modeInfo.duration * 0.4;
recorder = RL_dataRecorder('maps',mapFunc,'log',true,'plot','video');
plate = realPlate(modeInfo,mapFunc);
steps = RL_controlLoop(mycontroller,target,tolerance,plate,recorder,policy);
fprintf('The total path completed in %d steps\n',steps);
recorder = [];

% persistent last_positions;
% last_positions(end+1,:)= position;
% 
% vecnorm(last_positions(end-1) - position)
% if length(last_positions) > 2
%     if (vecnorm(last_positions(end-1) - position) < 0.05)
%         id = randi([1,length(maps)]);
%         return
%     end
% end