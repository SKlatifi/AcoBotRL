addpath('..');

close all;
clear all;

gridSize = 20;
desiredStepSize = 0.07;

modes = fromData(loadVariable('modeInfo.mat','modeInfo'),loadVariable('PPMap.mat','Map'),gridSize);
modes = adjustDurations(modes,desiredStepSize,0.3,4);
% modes.gains = modes.gains * 1.5;

t = {generateLogo();};
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
recorder = mockupDataRecorder();
cost = multiPointTracker(t,0.02,1,0,1,1e6);
model = localPlateModel(modes,3,0.5,'duration');
planner = superPositionPlanner(0.5);
cost.finished = @(p) false; % disable end condition
mycontroller = controller(myplate,model,cost,planner,recorder);
mycontroller.run();

%%

httpcommand('StopRecording');