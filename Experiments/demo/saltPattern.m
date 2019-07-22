
clear all;
close all;
clc;

load('trackModesChromaticUW_2018_20_1_m3.mat')

% idx = 20; Amp = 3; 
% idx = 31; Amp = 3; 
% idx = 41; Amp = 3; 
% % Under water
% httpcommand('StopRecording');
% httpcommand('StartRecording');
% idx = 42; Amp = 1.8; 
% duration = 20000;
% 
% for i = 0:18
%     modeInfo.freq(idx) - 100*i
%     if i < 10
%         playsignal(modeInfo.freq(idx)-100*i,Amp*modeInfo.amp(idx),duration,'Triangular');
%     else
%         playsignal(modeInfo.freq(idx)-100*i,(Amp-0.5)*modeInfo.amp(idx),duration,'Triangular');
%     end
%     pause(1.1*duration/1000);
% end
% 
% httpcommand('StopRecording');

% % In air
% httpcommand('StopRecording');
% httpcommand('StartRecording');
% freq = 24000;
% idx = 42; Amp = 0.8; 
% duration = 20000;
% 
% for i = 2:2
%     freq - 200*i
%     playsignal(freq-200*i,Amp*modeInfo.amp(idx),duration,'Triangular');
%     pause(1.1*duration/1000);
% end
% 
% httpcommand('StopRecording');

% Franadole in air
httpcommand('StopRecording');
httpcommand('StartRecording');
freq = 24000;
idx = 42; Amp = 1.5; 
duration = 20000;
frequency=((modeInfo.freq(idx)-500)-(modeInfo.freq(idx)-1600))...
    *((freq-400)-(freq-4400))/((modeInfo.freq(idx)-100)-(modeInfo.freq(idx)-1600))...
    + freq - 4400;

playsignal(frequency,Amp*modeInfo.amp(idx),duration,'Triangular');
pause(1.1*duration/1000);

httpcommand('StopRecording');

