% analyze('data/exp_151210_122752.txt');
close all;
clear all;
%%
pixels = [825 826];
siz = [50 50];
fsize = 14;

fig = figure('Position', [100, 100, 500, 500]);

v = VideoReader('cam5_20151216_013.avi');
%v = VideoReader('data/cam5_20151210_009.avi');
spacing = 15;
totf = [];
i = 1;
while hasFrame(v)    
    frame = double(rgb2gray(readFrame(v)));        
    if (mod(i,spacing) == 0)        
        if (isempty(totf))
            totf = frame;
        else
            totf = max(0,frame - totf)+totf;
            i
        end
    end
    i = i + 1;
end
%%

imshow(1 - flipud(totf / 255),'Xdata',[0 50],'Ydata',[0 50]);
axis on;
set(gca,'Ydir','Normal')

hold on;
l = [];
%t{1} = [0.3 0.3;0.1 0.3;0.1 0.5;0.3 0.5;0.3 0.7;0.1 0.7];
%t{2} = [0.7 0.3;0.5 0.3;0.5 0.7;0.7 0.7];
%t{3} = [0.9 0.3;0.9 0.7];
%t{1} = [0.33 0.35;0.13 0.35;0.13 0.5;0.33 0.5;0.33 0.65;0.08 0.65];
%t{2} = [0.7 0.35;0.5 0.35;0.5 0.45;0.5 0.55;0.5 0.65;0.7 0.65];
%t{3} = [0.87 0.35; 0.87 0.4; 0.87 0.5; 0.87 0.6; 0.87 0.7;];
t{1} = [0.33 0.35;0.13 0.35;0.13 0.5;0.33 0.5;0.33 0.65;0.13 0.65];
t{2} = [0.7 0.35;0.5 0.35;0.5 0.45;0.5 0.55;0.5 0.65;0.7 0.65];
t{3} = [0.87 0.35; 0.87 0.65];

for i = 1:length(t)    
    l(1) = plot(t{i}(:,1) * siz(1),(1-t{i}(:,2)) * siz(2),'r:','LineWidth',2);    
end
axis([0 siz(1) 0 siz(2)]); 
hold off;
% l(2) = analyze('data/exp_151209_142100.txt',siz,pixels);
legend(l,{'Planned'});
legend boxoff;
xlabel('X (mm)');
ylabel('Y (mm)');

h = gca;
set(h, 'Box', 'on');
set(h, 'Position',[0.09 0.09 0.88 0.88])
set(h,'XTick',0:5:50);
set(h,'YTick',0:5:50);

set(gcf,'color','w');
set(gca,'FontName','Arial','FontSize', fsize)
h = get(gca, 'title');
set(h ,'FontName','Arial','FontSize', fsize)
h = get(gca, 'xlabel');
set(h,'FontName','Arial','FontSize', fsize)
h = get(gca, 'ylabel');
set(h ,'FontName','Arial','FontSize', fsize)