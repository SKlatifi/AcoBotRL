
clear all;
close all;
clc;

load('trackModesChromaticUW_2018_20_1_m6.mat');

idx = 54; Amp = 1; 
duration = 5000;
playsignal(modeInfo.freq(idx),Amp*modeInfo.amp(idx),duration,'Square');
pause(1.1*duration/1000);
