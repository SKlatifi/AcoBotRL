function modeInfo = makeStruct(selectedData)

%% This mfile makes a data structure for AcoRobot control algorithm
%
% Data structure includes:
%       Frequency, Amplitude, and Duration  of the signal
%       Material which should be used in the experiments
%       Gradient, STD, and Squared error map
%       X-Y Grid dada
%       
% *** For appending new mode data, add the prefix of the mode to this section 

%% create data struct from selectedData

material = {};
freq = [];
amp = [];
duration = [];
gradientMap = {};

for i = 1:length(selectedData)
    s = selectedData{i};
    modeString = strsplit(s,'_');
    material{i} = modeString{1}; 
    freq(i) = str2double(modeString{2});
    amp(i) = str2double(modeString{3}); 
    duration(i) = str2double(modeString{4}); 
    load(strcat(s,'map.mat'));
    gradientMap{i} = gradmap;    
end

modeInfo = struct;
modeInfo.material = material;
modeInfo.freq = freq;
modeInfo.amp = amp;
modeInfo.duration = duration;
modeInfo.gradient = gradientMap;




