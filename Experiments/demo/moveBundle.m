
clear all;
close all;
clc;

load('trackModesChromaticUW_2018_20_1_m6.mat');

takeVideo = 1;

if takeVideo
    httpcommand('StopRecording');
    httpcommand('StartRecording');
end

idx = 46; Amp = 2; 
duration = 10000;
playsignal(modeInfo.freq(idx),Amp*modeInfo.amp(idx),duration,'Triangular');
pause(1.1*duration/1000);

idx = 9; Amp = 2; 
duration = 4000;
playsignal(modeInfo.freq(idx),Amp*modeInfo.amp(idx),duration,'Trapezoidal');
pause(1.1*duration/1000);

idx = 46; Amp = 2; 
duration = 14000;
playsignal(modeInfo.freq(idx),Amp*modeInfo.amp(idx),duration,'Triangular');
pause(1.1*duration/1000);

idx = 9; Amp = 2; 
duration = 9000;
playsignal(modeInfo.freq(idx),Amp*modeInfo.amp(idx),duration,'Trapezoidal');
pause(1.1*duration/1000);

idx = 26; Amp = 2.5; 
duration = 10000;
playsignal(modeInfo.freq(idx),Amp*modeInfo.amp(idx),duration,'Trapezoidal');
pause(1.1*duration/1000);

if takeVideo
    httpcommand('StopRecording');
end