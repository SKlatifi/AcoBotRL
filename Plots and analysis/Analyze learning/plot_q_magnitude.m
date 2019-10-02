
close all;
clear all
clc;

tempPath = getTempDataPath();
load(strcat(tempPath,'reward_converge\NetMat40.mat'));

numGrid = 20;
x = linspace(0.3,0.7,numGrid);
y = linspace(0.1,0.5,numGrid);
[X,Y] = meshgrid(x,y);

colorMap = buildcmap('bwr');
selected_episodes = [9 49 99 149 199];
N_episodes = length(selected_episodes);
  
for i = 1:N_episodes

    q_value = NetMat(:,:,selected_episodes(i));  
    figure       
    hold on        
    pcolor(x,y,q_value);    
    colormap(colorMap);
    shading interp
    caxis([-2e-3 2e-3]);
    ax = gca;
    ax.XTick = [];
    ax.YTick = [];
    axis square
    axis equal
    axis([0.3 0.7 0.1 0.5]);
    set(gca,'Ydir','reverse'); 
    box on
    hold off;        
    export_fig(strcat(tempPath,'q_value_',num2str(selected_episodes(i))),'-r600');
end

% Generate colorbar
figure
colorMap = buildcmap('bwr');
colormap(colorMap);
hold on
shading interp
c = colorbar;
c.Ticks = [-2 -1 0 1 2];
c.FontName = 'Times New Roman';
c.FontSize = 24;
caxis([-2 2]);
set(gcf, 'Color', 'None');
axis off
export_fig(strcat(tempPath,'colorbar_q_value'),'-r600');


