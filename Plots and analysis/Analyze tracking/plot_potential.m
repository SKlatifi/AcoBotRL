close all;
clear all;

gridSize = 20;
modes1 = fromData(loadVariable('trackModesChromatic_2018_20_1_franadole3.mat','modeInfo'),loadVariable('trackModesChromatic_2018_20_1_franadole3.mat','Map'),gridSize,0);

[x,y] = meshgrid(0:0.05:1,0:0.05:1);
figure
for noteId = 1:1
    for i = 1:21
        for j = 1:21
            u1(i,j) = modes1.w{noteId}((i-1)*21+j,1);
            v1(i,j) = modes1.w{noteId}((i-1)*21+j,2);
        end
    end
    subplot(2,3,noteId);
    surf(sqrt(u1.^2 + v1.^2));
    colormap('gray');
    az = 0;
    el = 90;
    view(az, el);
    set(gca,'Ydir','reverse');
    axis([1 21 1 21]);
    title(['Frequency:  ' num2str(modes1.frequencies(noteId))]);  
    shading interp;
    set(gca,'XTick',[]); 
    set(gca,'YTick',[]); 
    set(gca,'Xticklabel',[]) ;
    set(gca,'Yticklabel',[]);
end