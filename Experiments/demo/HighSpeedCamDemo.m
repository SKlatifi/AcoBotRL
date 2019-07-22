
clear all;
close all;
clc;

load('trackModesChromatic.mat')

idx = 45;
% idx = 47;

duration = 1000;
playsignal(modeInfo.freq(idx),modeInfo.amp(idx),duration,'Triangular');