addpath('..');

gridSize = 20;
desiredStepSize = 0.04;

modes = fromData(loadVariable('modeInfo.mat','modeInfo'),loadVariable('PPMap.mat','Map'),gridSize);
modes = adjustDurations(modes,desiredStepSize,0.3,4);

%%
p = [0.25 0.25;0.75 0.25;0.75 0.75] + randn(3,2) * 0.1;      
t = [0.25 0.25;0.75 0.25;0.75 0.75];

myplate = dataMockupPlate(p,'modeInfo.mat',1);
cost = pointTracker(t,0.02,0.1,0.1,1e6);
model = localPlateModel(modes,3,1);
planner = beamPlanner(4,20);
mycontroller = controller(myplate,model,cost,planner);
mycontroller.run();