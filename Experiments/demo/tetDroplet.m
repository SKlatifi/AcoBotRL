clear all;
close all;
clc;

load('trackModesChromatic.mat')

% idx = 36; Amp = 3; 
% idx = 43; Amp = 3;
% idx = 52; Amp = 1;

duration = 5000;
frequency = 12000;
amplitude = 0.52;
N = 1;

httpcommand('StopRecording');
httpcommand('StartRecording');

for i=1:N
    playsignal(frequency,amplitude,duration,'Triangular');
    pause(duration/1000 + 1);
end

httpcommand('StopRecording');
