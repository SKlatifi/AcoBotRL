% All units are normalized to the plate size: (0,0) is topleft corner,
% (1,0) is the topright corner; (0,1) is the bottomleft corner

% Starting point for the manipulation     
% start = [0.2 0.2;
%          0.8 0.5
%          0.3 0.8];
% target = [0.35 0.35;
%           0.75 0.4;
%           0.4 0.7];
tolerance = 0.015; % At which distance the particle considered have reached the target, in plate units
mycontroller = @controller; % Replace this line to switch from one controller to another

datapath = getTempDataPath();
mapfilename = 'vectorField_RL_2019_1.mat';
policyfilename = 'policy10000.mat';
load(strcat(datapath,mapfilename));
load(strcat(datapath,policyfilename));

load('maps.mat');
load('policy1000.mat')

% dataRecorder(...,'log',true) saves log file
% dataRecorder(...,'plot','video') save a video
recorder = dataRecorder('maps',maps,'plot','video');

% For simulation, use simulatedPlate.
% In the final competition, we will replace this with realPlate
plate = simulatedPlate(start,maps);

% Run the main control loop
steps = controlLoop(mycontroller,maps,target,tolerance,plate,recorder,policy);
fprintf('Manipulation completed in %d steps\n',steps);

% Clearing all references to the recorder calls the destructor for a
% videoWriter, so the video file is not locked anymore and can be watched
recorder = [];