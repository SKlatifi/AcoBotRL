function [ret,numframes] = mergeVideo(filename,frameSpacing,firstFrame,cmap,numframes)

if (nargin < 2)
    frameSpacing = 1;
end

if (nargin < 3)
    firstFrame = 1;
end

if (nargin >= 4 && ischar(cmap))
    cmap = colormap(cmap);
end

v = VideoReader(filename);
if (nargin < 5)
    numframes = v.Duration * v.FrameRate;
end
ret = [];
i = 0;
while hasFrame(v)    
    rawFrame = readFrame(v);
    i = i + 1;
    if (i < firstFrame)        
        continue;
    end    
    if (mod(i-firstFrame,frameSpacing) == 0)        
        i
        grayFrame = double(rgb2gray(rawFrame))/255;  
        frame = repmat(grayFrame,[1 1 3]);         
        if (nargin >= 4)
            c = interp1(cmap,(i-firstFrame)/(numframes - firstFrame)*(size(cmap,1)-1)+1);
            frame(:,:,1) = frame(:,:,1)*c(1);
            frame(:,:,2) = frame(:,:,2)*c(2);
            frame(:,:,3) = frame(:,:,3)*c(3);
        end
        if (isempty(ret))
            ret = frame;
        else
            ret = max(0,frame - ret)+ret;
        end
    end    
end