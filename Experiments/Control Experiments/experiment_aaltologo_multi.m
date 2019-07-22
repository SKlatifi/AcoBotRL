addpath('..');

close all;
clear all;

gridSize = 20;

datafile = ['D:\Projects\Acobot\AcoLabControl\TempData\Resistor_aalto_multi_' datestr(now,'yymmdd_HHMMSS') '.txt'];

modes = fromData(loadVariable('trackModesChromatic.mat','modeInfo'),loadVariable('trackModesChromatic.mat','Map'),gridSize,0);
modes.gains = modes.gains * 1.3;
modes.durations = modes.durations * 0.5;

%t = {[0.3 0.3;0.1 0.3;0.1 0.5;0.3 0.5;0.3 0.7;0.1 0.7],[0.7 0.3;0.5 0.3;0.5 0.7;0.7 0.7],[0.9 0.3;0.9 0.7]};
t = {};
rotflag = 0;
t{1} = generateA(rotflag);
t{2} = generateQuestion(rotflag);

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
cost = syncMultiPointTracker(t,0.01,1,0.1,0.1,1e6,0.01);
model = localPlateModel(modes,3,0.5);
planner = totalisticPlanner(0.2);
mycontroller = controller(myplate,model,cost,planner,recorder);
mycontroller.run();

%%

httpcommand('StopRecording');