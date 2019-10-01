
close all;
clear all
clc;

tempPath = getTempDataPath();
load(strcat(tempPath,'reward_converge\NetMat40.mat'));

numGrid = 20;
x = linspace(0.3,0.7,numGrid);
y = linspace(0.1,0.5,numGrid);
[X,Y] = meshgrid(x,y);

selected_episodes = [9 49 99 149 199];
% cmap = {'parula','jet','hot','bone','cool','spring','summer','autumn','gray','copper','pink'};
% cmap = {'parula','spring','gray','copper'};
cmap = {'parula'};
N_episodes = length(selected_episodes);
N_cmap = length(cmap);


% surf(X,Y,NetMat(:,:,20));
for j = 1:N_cmap    
    for i = 1:N_episodes
%         subplot(length(cmap),length(selected_episodes),(j-1)*N_episodes+i);
%         subplot(1,length(selected_episodes),i);
        figure
        hold on
        q_value = NetMat(:,:,selected_episodes(i));
        pcolor(x,y,q_value);    
        colormap(cmap{j});
        shading interp
        % caxis([-0.3 0.3]);
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
end

