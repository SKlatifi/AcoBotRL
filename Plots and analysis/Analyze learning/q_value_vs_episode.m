close all;
clear all
clc;

tempPath = getTempDataPath();
load(strcat(tempPath,'Error_vs_episode_note40.mat'));

episode_min = 3;
episode_max = 199;

% dx.dy was missed in calculating the error, so applied here
dx = 0.4/20;    % Correct the integral in X dirction
dy = 0.4/20;    % Correct the integral in X dirction

x = 3:199;
y = error(3:199)*dx*dy;

[fitresult, gof] = createFitQvalue(x, y);
export_fig(strcat(tempPath,'q_value_evolution.pdf'));
