addpath('..');

close all;
clear all;

gridSize = 20;
%desiredStepSize = 0.07;

%% Uncomment this part for mode drop out experiment and comment out the next section
% dropOutNum = 51;
% folderName = 'D:\Projects\Acobot\AcoLabControl\TempData\';
% oldFileName = 'trackModesChromatic.mat';
% newFileName = strcat('trackModesChromatic',num2str(dropOutNum),'.mat');
% dropOutModes(folderName,oldFileName,dropOutNum,newFileName);
% datafile = ['D:\Projects\Acobot\AcoLabControl\TempData\square_' datestr(now,'yymmdd_HHMMSS') '.txt'];
% modes = fromData(loadVariable(newFileName,'modeInfo'),loadVariable(newFileName,'Map'),gridSize,0);

%% Uncomment this part for full modes experiment and comment out the previous section
datafile = ['D:\Projects\AcoBotRL\TempData\glass750_UW_line_' datestr(now,'yymmdd_HHMMSS') '.txt'];
modes = fromData(loadVariable('vectorField_RL_2019_1.mat','modeInfo'),loadVariable('vectorField_RL_2019_1.mat','mapGrid'),gridSize,0);
%modes = adjustDurations(modes,desiredStepSize,0.3,4);

%%
modes.gains = modes.gains * 1;
modes.durations = modes.durations * 0.2;

t = {generateLine();};
%%

httpcommand('ShowVectorField','flag',0);
httpcommand('StartOverlayDisplay');
httpcommand('ShowTrackingPoints','flag',1);
httpcommand('RecordRawImage','flag',1);
httpcommand('StartTracking');
httpcommand('TriggedRecording','flag',1);
httpcommand('StopRecording');
httpcommand('StartRecording');

%%

myplate = plate();
recorder = mockupDataRecorder(datafile);
cost = multiPointTracker(t,0.01,0,0,1,1e6,0.01);
model = localPlateModel(modes,3,0.5);
planner = totalisticPlanner(0.2);
% cost.finished = @(p) false; % disable end condition
mycontroller = controller(myplate,model,cost,planner,recorder);
mycontroller.run();

%%

httpcommand('StopRecording');