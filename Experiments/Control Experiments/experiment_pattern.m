addpath('..');

close all;
clear all;

gridSize = 20;
desiredStepSize = 0.07;

datafile = ['D:\Projects\Acobot\AcoLabControl\TempData\line_pattern_' datestr(now,'yymmdd_HHMMSS') '.txt'];        

% modes = fromData(loadVariable('modeInfo.mat','modeInfo'),loadVariable('PPMap.mat','Map'),gridSize);
modes = fromData(loadVariable('trackModesChromatic.mat','modeInfo'),loadVariable('trackModesChromatic.mat','Map'),gridSize,0);
%modes = adjustDurations(modes,desiredStepSize,0.3,4);
%modes.gains = modes.gains * 1.1;
modes.gains = modes.gains * 1.4;
modes.durations = modes.durations * 0.5;

% %% Triangle pattern
% lines = [0.5 0.3 0.3 0.7;0.3 0.7 0.7 0.7;0.7 0.7 0.5 0.3];
% lines = (lines - 0.5) * 1.1 + 0.5;

%% Line Pattern
% lines = [0.15 0.85 0.85 0.15];
lines = [0.15 0.65 0.85 0.65];
lines = (lines - 0.5) * 1.1 + 0.5;

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

R = 0.1;
stdWeight = 0.1;
tolerance = 0.05;

myplate = plate();
recorder = mockupDataRecorder(datafile);
cost = patternTracker(lines,tolerance,stdWeight,R,1e6);
model = localPlateModel(modes,3,0.5);
planner = totalisticPlanner();
cost.finished = @(p) false; % disable end condition
mycontroller = controller(myplate,model,cost,planner,recorder);
mycontroller.run();

%%

httpcommand('StopRecording');
