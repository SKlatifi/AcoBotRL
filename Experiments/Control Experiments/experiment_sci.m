addpath('..');

close all;
clear all;

gridSize = 20;

datafile = ['../../TempData/SCI_' datestr(now,'yymmdd_HHMMSS') '.txt'];

modes = fromData(loadVariable('trackModes.mat','modeInfo'),loadVariable('trackModes.mat','Map'),gridSize,0);
modes.gains = modes.gains * 1.1;

%t = {[0.3 0.3;0.1 0.3;0.1 0.5;0.3 0.5;0.3 0.7;0.1 0.7],[0.7 0.3;0.5 0.3;0.5 0.7;0.7 0.7],[0.9 0.3;0.9 0.7]};
t = {};
t{1} = [0.33 0.35;0.13 0.35;0.13 0.5;0.33 0.5;0.33 0.65;0.13 0.65];
t{2} = [0.7 0.35;0.5 0.35;0.5 0.45;0.5 0.55;0.5 0.65;0.7 0.65];
t{3} = [0.87 0.35; 0.87 0.65];

splitT = arrayfun(@(x) splitTargetList(x{1},0.02),t,'UniformOutput',false);
p = cell2mat(arrayfun(@(x) x{1}(1,:)',splitT,'UniformOutput',false))';

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
cost = multiPointTracker(splitT,0.05,1,0.1,0.1,1e6,0.01);
model = localPlateModel(modes,3,0.5);
planner = totalisticPlanner(0.2);
mycontroller = controller(myplate,model,cost,planner,recorder);
mycontroller.run();

%%

httpcommand('StopRecording');