addpath('..');

close all;
clear all;

gridSize = 20;
desiredStepSize = 0.07;

modes = fromData(loadVariable('modeInfo.mat','modeInfo'),loadVariable('PPMap.mat','Map'),gridSize);
modes = adjustDurations(modes,desiredStepSize,0.3,4);

t = {[0.3 0.3;0.1 0.3;0.1 0.5;0.3 0.5;0.3 0.7;0.1 0.7],[0.7 0.3;0.5 0.3;0.5 0.7;0.7 0.7],[0.9 0.3;0.9 0.7]};
splitT = arrayfun(@(x) splitTargetList(x{1}(:,[2,1]),0.02),t,'UniformOutput',false);
p = cell2mat(arrayfun(@(x) x{1}(1,:)',splitT,'UniformOutput',false))';

%%

myplate = dataMockupPlate(p,'modeInfo.mat',1);
recorder = mockupDataRecorder();
cost = multiPointTracker(splitT,0.05,1,0.2,0.1,1e6);
model = localPlateModel(modes,3,0.5);
% planner = beamPlanner(3,20);
planner = totalisticPlanner();
%planner = probabilisticPlanner();
cost.finished = @(p) false; % disable end condition
mycontroller = controller(myplate,model,cost,planner,recorder);
mycontroller.run();