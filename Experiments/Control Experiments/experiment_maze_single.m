addpath('..');

close all;
clear all;

gridSize = 20;
%desiredStepSize = 0.07;

%% Uncomment this part for full modes experiment and comment out the previous section
datafile = ['D:\Projects\Acobot\AcoLabControl\TempData\glass750_maze_single_' datestr(now,'yymmdd_HHMMSS') '.txt'];
modes = fromData(loadVariable('trackModesChromaticUW_2018_20_1_m6.mat','modeInfo'),loadVariable('trackModesChromaticUW_2018_20_1_m6.mat','Map'),gridSize,0);
%modes = adjustDurations(modes,desiredStepSize,0.3,4);

%%
modes.gains = modes.gains * 2;
modes.durations = modes.durations * 0.2;
% load('D:\Projects\Acobot\AcoLabControl\TempData\modes_UW_m4_single_maze.mat');

t = {generateMazeP7();};
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
cost = multiPointTracker(t,0.03,0,0,1,1e6,0.02);
model = localPlateModel(modes,3,0.5);
planner = totalisticPlanner(0.2);
% cost.finished = @(p) false; % disable end condition
mycontroller = controller(myplate,model,cost,planner,recorder);
mycontroller.run();

%%

httpcommand('StopRecording');