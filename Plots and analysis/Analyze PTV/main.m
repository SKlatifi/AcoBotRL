close all;

% imgPath = 'C:\Users\micronano\Documents\AcoServer\Image\BlobTest2015-11-10\';
imgPath = 'E:\images from PTV\';
    
selectedData = {};
selectedData = [{'600umsolderball_3990_0.0375_500_'}];
selectedData = [selectedData {'600umsolderball_3990_0.075_500_'}];
selectedData = [selectedData {'600umsolderball_3990_0.1125_500_'}];
selectedData = [selectedData {'600umsolderball_3990_0.15_62.5_'}];
selectedData = [selectedData {'600umsolderball_3990_0.15_125_'}];
selectedData = [selectedData {'600umsolderball_3990_0.15_250_'}];
selectedData = [selectedData {'600umsolderball_3990_0.15_500_'}];
selectedData = [selectedData {'600umsolderball_3990_0.15_1000_'}];
selectedData = [selectedData {'600umsolderball_3990_0.225_500_'}];
% selectedData = [selectedData {'600umsolderball_7800_0.03_500_'}];

%% Plate No 7:
% selectedData = [{'600umsolderball_1898_0.12_500_'}];
% selectedData = [selectedData {'600umsolderball_2900_0.35_500_'}];
% selectedData = [selectedData {'600umsolderball_3000_0.3_500_'}];
% selectedData = [selectedData {'600umsolderball_3500_0.18_500_'}];
% selectedData = [selectedData {'600umsolderball_3990_0.0375_500_'}];
% selectedData = [selectedData {'600umsolderball_3990_0.075_500_'}];
% selectedData = [selectedData {'600umsolderball_3990_0.1125_500_'}];
% selectedData = [selectedData {'600umsolderball_3990_0.15_62.5_'}];
% selectedData = [selectedData {'600umsolderball_3990_0.15_125_'}];
% selectedData = [selectedData {'600umsolderball_3990_0.15_250_'}];
% selectedData = [selectedData {'600umsolderball_3990_0.15_500_'}];
% selectedData = [selectedData {'600umsolderball_3990_0.15_1000_'}];
% selectedData = [selectedData {'600umsolderball_3990_0.225_500_'}];
% selectedData = [selectedData {'600umsolderball_4250_0.25_500_'}];
% selectedData = [selectedData {'600umsolderball_4500_0.2_500_'}];
% selectedData = [selectedData {'600umsolderball_4600_0.35_500_'}];
% selectedData = [selectedData {'600umsolderball_4700_0.2_500_'}];
% selectedData = [selectedData {'600umsolderball_4830_0.05_400_'}];
% selectedData = [selectedData {'600umsolderball_4830_0.1_400_'}];
% selectedData = [selectedData {'600umsolderball_4830_0.15_400_'}];
% selectedData = [selectedData {'600umsolderball_4830_0.2_25_'}];
% selectedData = [selectedData {'600umsolderball_4830_0.2_50_'}];
% selectedData = [selectedData {'600umsolderball_4830_0.2_100_'}];
% selectedData = [selectedData {'600umsolderball_4830_0.2_400_'}];
% selectedData = [selectedData {'600umsolderball_4830_0.25_400_'}];
% selectedData = [selectedData {'600umsolderball_4830_0.3_400_'}];
% selectedData = [selectedData {'600umsolderball_4830_0.2_1000_'}];
% selectedData = [selectedData {'600umsolderball_4850_0.18_500_'}];
% selectedData = [selectedData {'600umsolderball_5000_0.25_400_'}];
% selectedData = [selectedData {'600umsolderball_5500_0.35_400_'}];
% selectedData = [selectedData {'600umsolderball_5600_0.3_400_'}];
% selectedData = [selectedData {'600umsolderball_5800_0.35_500_'}];
% selectedData = [selectedData {'600umsolderball_5900_0.2_500_'}];
% selectedData = [selectedData {'600umsolderball_5950_0.26_500_'}];
% selectedData = [selectedData {'600umsolderball_6050_0.26_500_'}];
% selectedData = [selectedData {'600umsolderball_6100_0.25_500_'}];
% selectedData = [selectedData {'600umsolderball_7000_0.12_400_'}];
% selectedData = [selectedData {'600umsolderball_7800_0.03_500_'}];
% selectedData = [selectedData {'600umsolderball_9000_0.18_500_'}];
% selectedData = [selectedData {'600umsolderball_10000_0.25_500_'}];
% selectedData = [selectedData {'600umsolderball_12000_0.03_500_'}];
% selectedData = [selectedData {'600umsolderball_14000_0.15_500_'}];
% selectedData = [selectedData {'600umsolderball_19500_0.005_300_'}];
% selectedData = [selectedData {'600umsolderball_20000_0.03_500_'}];
% selectedData = [selectedData {'600umsolderball_23890_0.01_250_'}];
% selectedData = [selectedData {'600umsolderball_24000_0.015_500_'}];
% selectedData = [selectedData {'600umsolderball_25740_0.1_200_'}];
% selectedData = [selectedData {'600umsolderball_26300_0.05_200_'}];
% selectedData = [selectedData {'600umsolderball_27200_0.03_200_'}];
% 

%selectedData = [selectedData {'600umsolderball_2F_3990_0.15_7800_0.03_500_'}];
%selectedData = [selectedData {'600umsolderball_2F_3990_0.075_7800_0.015_500_'}];

for i = 1:length(selectedData)
    fprintf('%1.0f: %s\n',i,selectedData{i});
end

%%
% % Plate No 7 (disorganised):
% selectedData{1} = '600umsolderball_3000_0.3_500_';
% selectedData{2} = '600umsolderball_3990_0.15_500_';
% selectedData{3} = '600umsolderball_4500_0.2_500_';
% selectedData{4} = '600umsolderball_4700_0.2_500_';
% selectedData{5} = '600umsolderball_4850_0.18_500_';
% selectedData{6} = '600umsolderball_6100_0.25_500_';
% selectedData{7} = '600umsolderball_5800_0.35_500_';
% selectedData{8} = '600umsolderball_7800_0.03_500_';
% selectedData{9} = '600umsolderball_12000_0.03_500_';
% selectedData{10} = '600umsolderball_1898_0.12_500_';
% selectedData{11} = '600umsolderball_4250_0.25_500_';
% selectedData{12} = '600umsolderball_19500_0.005_300_';
% selectedData{13} = '600umsolderball_23890_0.01_250_';
% selectedData{14} = '600umsolderball_27200_0.03_200_';
% selectedData{15} = '600umsolderball_25740_0.1_200_';
% selectedData{16} = '600umsolderball_5900_0.2_500_';
% selectedData{17} = '600umsolderball_6050_0.26_500_';
% selectedData{18} = '600umsolderball_5950_0.26_500_';

% Plate No 1:
% selectedData{1} = '750umbead_1868_0.5_400_';
% selectedData{2} = '750umbead_2945_0.3_200_';
% selectedData{3} = '750umbead_2975_0.1_250_';
% selectedData{4} = '750umbead_3005_0.18_300_';
% selectedData{5} = '750umbead_3040_0.28_350_';
% selectedData{6} = '750umbead_5249_0.33_400_';
% selectedData{7} = '750bead_6288_0.12_250_';
% selectedData{8} = '750umbead_6288_0.17_300_';
% selectedData{9} = '750umbead_7800_0.023_400_';

%% this is the running main running analysis file
% Input:    Path, File prefix
% Output:   P_List, V_list for an specific signal in 'D:\Projects\Acobot\AcoLabControl\TrackingData\'
%           Gradient, STD, and Squared Error map in 'D:\Projects\Acobot\AcoLabControl\TempData\'        
%beginMode = 18;
%endMode = 18;

mpath = mfilename('fullpath');
[pathstr,name,ext] = fileparts(mpath);

tempDataPath = [pathstr '\..\..\TempData\'];
dataPath = [pathstr '\..\..\TrackingData\'];
mkdir(dataPath);

warning('off','curvefit:prepareFittingData:removingNaNAndInf'); 

if (~exist('beginMode','var'))
    beginMode = 1;
end

if (~exist('endMode','var'))
    endMode = length(selectedData);
end

for i=beginMode:endMode
    % analyze image and get position and velocity vectors
    filePrefix = selectedData{i};
    
    disp(['analyzing ' filePrefix]);
    info = 1;
    debug = 0;
    pauseDuration = 0;
    threshold = 50;
    brightParticle = 1; % If particles are bright and plate is dark --> brightParticle = 1, else --> brightParticle = 1

    [P_List, V_List, maxX, maxY] = field_analysis(imgPath, filePrefix, info, threshold, debug, pauseDuration, brightParticle);

    filename = strcat([dataPath filePrefix], '.mat');
    save(filename,'P_List','V_List', 'maxX', 'maxY');
    
    % display movement
    LABEL = 0;
    TAIL = 1;    
    pauseDuration = 0;
    %displaymovement(imgPath, dataPath, filePrefix, LABEL, TAIL, pauseDuration);

    %%
    % fitting data
    disp('fitting data ...'); 

    numOfGrids = 50;
    span = 0.08;
    spanSE = 0.015;
    spanSTD = 0.02;
    showFigure = 1;
    

    [gradmap, resU, resV, resSE, resSTD] = fitVmap(P_List,V_List, maxX, maxY, numOfGrids, span, spanSE, spanSTD, showFigure, dataPath, filePrefix);
    filename = strcat([tempDataPath filePrefix], 'map.mat');
    save(filename,'gradmap');
    %tightfig;
end

% 
% 
% warning('on','curvefit:prepareFittingData:removingNaNAndInf'); 
% 
% fileName = 'modeInfo.mat';
% modeInfo = makeStruct(selectedData);
% filename = strcat(tempDataPath,fileName);
% save(filename,'modeInfo');
% 
% %% Generate PPMap for planning, visualization and reachability computation
% fileName = 'PPMap.mat';
% if exist([tempDataPath fileName], 'file') == 2
%     oldFile = ['PPMap.old.' date '.' num2str(randn()) '.mat'];
%     copyfile([tempDataPath fileName],[tempDataPath oldFile]);
% end
% 
% Map = GeneratePPMap(modeInfo);
% filename = strcat(tempDataPath,fileName);
% save(fileName,'Map');
% 
% %% Generate reachability map to check reachability based on current position
% reachabilityMapName = 'ReachMap.mat';
% checkReachabilityMajor;
% 
% vectorMapPath = 'D:\Projects\Acobot\AcoLabControl\TempData\vectorMap.mat';
% create_vectormap(vectorMapPath);




