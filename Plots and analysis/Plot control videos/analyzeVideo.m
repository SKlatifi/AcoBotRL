close all;
clear all;

spacing = 20;
v = VideoReader('cam5_20160601_036.avi');
totf = [];
i = 1;
while hasFrame(v)    
    frame = double(rgb2gray(readFrame(v)));        
    if (mod(i,spacing) == 0)        
        if (isempty(totf))
            totf = frame;
        else
            totf = max(0,frame - totf)+totf;
        end
    end
    i = i + 1
end
%%
figure;
image(totf / 3);
colormap gray;