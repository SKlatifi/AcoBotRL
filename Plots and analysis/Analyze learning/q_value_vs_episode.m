close all;
clear all
clc;

tempPath = getTempDataPath();
load(strcat(tempPath,'Error_vs_episode_note40.mat'));

episode_min = 3;
episode_max = 199;

x = 3:199;
y = error(3:199);

[fitresult, gof] = createFitQvalue(x, y);
export_fig(strcat(tempPath,'q_value_evolution.pdf'));
