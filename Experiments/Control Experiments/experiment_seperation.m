addpath('..');

close all;
clear all;

gridSize = 20;

datafile = ['D:\Projects\Acobot\AcoLabControl\TempData\Seperate_' datestr(now,'yymmdd_HHMMSS') '.txt'];

modes = fromData(loadVariable('trackModesChromatic.mat','modeInfo'),loadVariable('trackModesChromatic.mat','Map'),gridSize,0);
modes.gains = modes.gains * 1;

httpcommand('StartTracking');
distance = 0.8; % in mm
startingPoint(distance);
fprintf('Please place the particles\n');
httpcommand('ShowVectorField','flag',0);
httpcommand('StartOverlayDisplay');
pause;
t = dynamicTarget();

p = cell2mat(arrayfun(@(x) x{1}(1,:)',t,'UniformOutput',false))';

%%

httpcommand('ShowVectorField','flag',0);
httpcommand('StartOverlayDisplay');
httpcommand('ShowTrackingPoints','flag',1);
httpcommand('RecordRawImage','flag',1);
httpcommand('TriggedRecording','flag',1);
httpcommand('StopRecording');
httpcommand('StartRecording');

%%
myplate = plate();
recorder = mockupDataRecorder(datafile);
cost = costSeperation(t,0.001,0.2);
model = localPlateModel(modes,3,0.5);
planner = totalisticPlanner(0.2);
mycontroller = controller(myplate,model,cost,planner,recorder);
mycontroller.run();

%%

httpcommand('StopRecording');