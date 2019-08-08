
clear all;
close all;

target = [0.4 0.35;          
          0.6 0.65];
tolerance = 0.02;

%% Load models and modeInfo; and generate the output
datapath = [getTempDataPath 'RL_2019_P2_Part2\'];
datafile = [datapath 'P2_' datestr(now,'yymmdd_HHMMSS') '.txt'];
vector_field_file = [getTempDataPath() 'vectorField_RL_2019_P2.mat'];
policy_file = [getTempDataPath() 'policy10000.mat'];
load(vector_field_file);
load(policy_file);
Nmodes = length(modeInfo.freq);

%%
mycontroller = @RL_controller;
modeInfo.amp = modeInfo.amp * 1.2;
modeInfo.duration = modeInfo.duration * 0.2;
recorder = RL_dataRecorder('maps',mapFunc,'log',true,'plot','video');
plate = realPlate(modeInfo,mapFunc);
steps = RL_controlLoop(mycontroller,target,tolerance,plate,recorder,policy,Nmodes);
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