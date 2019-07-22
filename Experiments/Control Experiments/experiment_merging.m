addpath('..');

close all;
clear all;

gridSize = 20;

datafile = ['D:\Projects\Acobot\AcoLabControl\TempData\Merge_' datestr(now,'yymmdd_HHMMSS') '.txt'];

modes = fromData(loadVariable('trackModesChromaticUW_2018_20_1_m6.mat','modeInfo'),loadVariable('trackModesChromaticUW_2018_20_1_m6.mat','Map'),gridSize,0);

modes.gains = modes.gains * 2;
modes.durations = modes.durations * 0.2;

dynamicTarget = 1;
% GainAmp = 1.4;
% GainDur = 0.5;
p1 = [0.5,0.3];
p2 = [0.5,0.7];
% Target = [0.5,0.5];
% TargetAfterMerging = [0.4,0.4];

httpcommand('StartTracking');
startingPointMerge(p1,p2);
fprintf('Please place the particles\n');
httpcommand('ShowVectorField','flag',0);
httpcommand('StartOverlayDisplay');
pause;

if (dynamicTarget == 1)
    t = dynamicTargetMerge();
    cost = costMerging(t,0.001,0);
else
    t = {};
    t{1} = [p1;Target];
    t{2} = [p2;Target];
    splitT = arrayfun(@(x) splitTargetList(x{1},0.02),t,'UniformOutput',false);
    p = cell2mat(arrayfun(@(x) x{1}(1,:)',splitT,'UniformOutput',false))';
    cost = costMergingFixed(splitT,0.05,1,0.1,0.1,1e6,0.01);
end
    
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
model = localPlateModel(modes,3,0.5);
planner = totalisticPlanner(0.2);
mycontroller = controller(myplate,model,cost,planner,recorder);
mycontroller.run();

%%
% if (dynamicTarget == 1)
%     str = httpcommand('GetPosition');
%     pt = sscanf(str,'%f,%f; ');	
%     pt = reshape(pt,2,length(pt) / 2)';
%     pixelSizeStr = httpcommand('GetSize');
%     pixelSize = sscanf(pixelSizeStr,'%f,%f; ');
%     pt(:,1) = pt(:,1) / pixelSize(1);
%     pt(:,2) = pt(:,2) / pixelSize(2);
%     MoveMergedDroplet(pt,TargetAfterMerging);
% else
%     MoveMergedDroplet(Target,TargetAfterMerging,GainAmp,GainDur);
% end

%%
httpcommand('StopRecording');

