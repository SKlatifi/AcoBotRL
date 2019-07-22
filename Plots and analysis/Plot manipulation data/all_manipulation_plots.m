close all;
profile on

D = load('trackModesChromatic.mat');
%%
M = csvread('logo_160120_124207.txt');
plot_manipulation_data(D,M,sprintf('%sLOGO.avi',getTempDataPath()));
close all;
%%
M = csvread('SCI_160120_110520.txt');
plot_manipulation_data(D,M,sprintf('%sSCI.avi',getTempDataPath()));
%%
close all;
M = csvread('sorting_160122_145336.txt');
plot_manipulation_data(D,M,sprintf('%sSORTING.avi',getTempDataPath()),0,10);
%%
close all;
M = csvread('pattern_160122_123004.txt');
plot_manipulation_data(D,M,sprintf('%sPATTERN.avi',getTempDataPath()),0,2,'--');
