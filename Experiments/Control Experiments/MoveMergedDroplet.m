function MoveMergedDroplet(Start,Target,GainAmp,GainDur)


%% Uncomment this part for full modes experiment and comment out the previous section
datafile = ['D:\Projects\Acobot\AcoLabControl\TempData\MoveMerged_' datestr(now,'yymmdd_HHMMSS') '.txt'];
modes = fromData(loadVariable('trackModesChromatic.mat','modeInfo'),loadVariable('trackModesChromatic.mat','Map'),gridSize,0);
modes.gains = modes.gains * GainAmp;
modes.durations = modes.durations * GainDur;

t = {generatePath(Start,Target);};
%%

httpcommand('ShowVectorField','flag',0);
httpcommand('StartOverlayDisplay');
httpcommand('ShowTrackingPoints','flag',1);
httpcommand('RecordRawImage','flag',1);
httpcommand('StartTracking');
httpcommand('TriggedRecording','flag',1);


%%

myplate = plate();
recorder = mockupDataRecorder(datafile);
cost = multiPointTracker(t,0.005,0,0,1,1e6,0.01);
model = localPlateModel(modes,3,0.5);
planner = totalisticPlanner(0.2);
% cost.finished = @(p) false; % disable end condition
mycontroller = controller(myplate,model,cost,planner,recorder);
mycontroller.run();


end