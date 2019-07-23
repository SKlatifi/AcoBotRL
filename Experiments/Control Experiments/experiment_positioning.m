addpath('..');

close all;
clear all;

gridSize = 20;

datafile = ['D:\Projects\Acobot\AcoLabControl\TempData\positioning_' datestr(now,'yymmdd_HHMMSS') '.txt'];        

modes = fromData(loadVariable('trackModesChromatic.mat','modeInfo'),loadVariable('trackModesChromatic.mat','Map'),gridSize,0);
modes.gains = modes.gains * 1;
modes.durations = modes.durations * 0.5;

%t = {[0.75 0.25],[0.75 0.75],[0.25 0.75],[0.25 0.25]};
%t = {[0.5 0.25],[0.75 0.5],[0.5 0.75],[0.25 0.5]};
t = {[0.82 0.18],[0.66 0.34],[0.50 0.50],[0.34 0.66], [0.18 0.82]};
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
n = 5;
R = [0.1*ones(n,n)];
%R = [0.1*ones(n,n) 0.13*ones(n,n);0.13*ones(n,n) 0.1*ones(n,n)];

myplate = plate();
recorder = mockupDataRecorder(datafile);
cost = multiPointTracker(t,0.05,0,0,R,1e6);
model = localPlateModel(modes,3,0.5);
planner = totalisticPlanner(0.2);
cost.finished = @(p) false; % disable end condition
mycontroller = controller(myplate,model,cost,planner,recorder);
mycontroller.run();

%%

httpcommand('StopRecording');