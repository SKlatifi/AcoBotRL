% All units are normalized to the plate size: (0,0) is topleft corner,
% (1,0) is the topright corner; (0,1) is the bottomleft corner

% Starting point for the manipulation     
start = [0.5 0.25;
          0.3 0.7;
          0.7 0.7];
target = [0.5 0.4;
         0.4 0.62;
         0.6 0.62];
      
tolerance = 0.015; % At which distance the particle considered have reached the target, in plate units
mycontroller = @controller; % Replace this line to switch from one controller to another

datapath = getTempDataPath();
mapfilename = 'vectorField_RL_2019_P2.mat';
policyfilename = 'policy5000.mat';
load(strcat(datapath,mapfilename));
load(strcat(datapath,policyfilename));

% dataRecorder(...,'log',true) saves log file
% dataRecorder(...,'plot','video') save a video
recorder = dataRecorder('maps',mapFunc,'plot','video');

% For simulation, use simulatedPlate.
% In the final competition, we will replace this with realPlate
plate = simulatedPlate(start,mapFunc);

% Run the main control loop
steps = controlLoop(mycontroller,mapFunc,target,tolerance,plate,recorder,policy);
fprintf('Manipulation completed in %d steps\n',steps);

% Clearing all references to the recorder calls the destructor for a
% videoWriter, so the video file is not locked anymore and can be watched
recorder = [];