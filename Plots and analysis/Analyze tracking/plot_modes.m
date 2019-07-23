
close all;
clear all;

gridSize = 20;
modes1 = fromData(loadVariable('trackModesChromaticUW_2018_20_1_m6.mat','modeInfo'),loadVariable('trackModesChromaticUW_2018_20_1_m6.mat','Map'),gridSize,0);

[x,y] = meshgrid(0:0.05:1,0:0.05:1);
figure
for noteId = 1:length(modes1.frequencies)
    for i = 1:21
        for j = 1:21
            u1(i,j) = modes1.w{noteId}((i-1)*21+j,1);
            v1(i,j) = modes1.w{noteId}((i-1)*21+j,2);
        end
    end
    quiver(x,y,u1,v1,4);
    axis([0 1 0 1]);
    set(gca,'Ydir','reverse');
    title([num2str(noteId) ':  ' num2str(modes1.frequencies(noteId))]);   
    pause;
end