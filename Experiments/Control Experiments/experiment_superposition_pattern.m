addpath('..');

close all;
clear all;

gridSize = 20;
desiredStepSize = 0.07;

modes = fromData(loadVariable('modeInfo.mat','modeInfo'),loadVariable('PPMap.mat','Map'),gridSize);
modes = adjustDurations(modes,desiredStepSize,0.3,0.5);
modes.gains = modes.gains * 3.2;
lines = [0.5 0.3 0.3 0.7;0.3 0.7 0.7 0.7;0.7 0.7 0.5 0.3];
lines = (lines - 0.5) * 1.2 + 0.5;

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

R = 0.13;
stdWeight = 0.1;
tolerance = 0.04;

myplate = plate();
recorder = mockupDataRecorder();
cost = patternTracker(lines,tolerance,stdWeight,R,1e6);
model = localPlateModel(modes,3,0.5);
planner = superPositionPlanner(0.5);
%cost.finished = @(p) false; % disable end condition
mycontroller = controller(myplate,model,cost,planner,recorder);
mycontroller.run();

%%

httpcommand('StopRecording');
