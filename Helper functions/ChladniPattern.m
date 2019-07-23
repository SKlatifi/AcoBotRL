
% httpcommand('TriggedRecording','flag',0);
% httpcommand('StartRecording');

clear all;
load('trackModesChromatic_old.mat');

[~,idx] = sort(modeInfo.freq);
modeInfo.freq = modeInfo.freq(idx);
modeInfo.amp = modeInfo.amp(idx);
modeInfo.duration = modeInfo.duration(idx);
modeInfo.material = modeInfo.material(idx);
MapNew = Map;

for i = 1:length(idx)
    MapNew(i) = Map(idx(i));
end

Map = MapNew;

filenameNew = 'D:\Projects\Acobot\AcoLabControl\TempData\trackModesChromatic.mat';
save(filenameNew,'Map','modeInfo');

% idx = 36;
% idx = 43;
% idx = 21; 
% duration = 10000;
% playsignal(modeInfo.freq(idx),5*modeInfo.amp(idx),duration,'Square');
% pause(duration/1000 + 1);
% 
% httpcommand('StopRecording');