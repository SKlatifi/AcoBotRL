addpath('..');

close all;
clear all;

gridSize = 20;

datafile = ['D:\Projects\Acobot\AcoLabControl\TempData\maze_' datestr(now,'yymmdd_HHMMSS') '.txt'];
modes = fromData(loadVariable('trackModesChromaticUW_2018_20_1_m3.mat','modeInfo'),loadVariable('trackModesChromaticUW_2018_20_1_m3.mat','Map'),gridSize,0);
modes.gains = modes.gains * 2;
modes.durations = modes.durations * 0.2;

%t = {[0.3 0.3;0.1 0.3;0.1 0.5;0.3 0.5;0.3 0.7;0.1 0.7],[0.7 0.3;0.5 0.3;0.5 0.7;0.7 0.7],[0.9 0.3;0.9 0.7]};
t = {};
t{1} = generateMazeP5();
t{2} = generateMazeP6();

p = cell2mat(arrayfun(@(x) x{1}(1,:)',t,'UniformOutput',false))';

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
cost = syncMultiPointTracker(t,0.03,0,0,0.1,1e6,0.02);
model = localPlateModel(modes,3,0.5);
planner = totalisticPlanner(0.2);
mycontroller = controller(myplate,model,cost,planner,recorder);
mycontroller.run();

%%

httpcommand('StopRecording');