function [ret,numframes] = videoMap(filename,frameSpacing,firstFrame)

    if (nargin < 2)
        frameSpacing = 1;
    end

    if (nargin < 3)
        firstFrame = 1;
    end      

    v = VideoReader(filename);
    ret = [];
    template = [];
    i = 0;
    while hasFrame(v)    
        rawFrame = readFrame(v);
        i = i + 1;
        if (i < firstFrame)        
            continue;
        end    
        if (mod(i-firstFrame,frameSpacing) == 0)        
            gf = double(rgb2gray(rawFrame))/255;  
            bw = adaptiveThreshold(gf,5);            
            if (isempty(template))
                imshow(~bw);                        
                a = round(ginput(2));
                template = bw(a(1,2):a(2,2),a(1,1):a(2,1));
            end
            i                       
            c = normxcorr2(template,bw);
            [ypeak, xpeak] = find(c==max(c(:)));
            yoffSet = ypeak-size(template,1);
            xoffSet = xpeak-size(template,2);       
            imshow(gf);
            imrect(gca, [xoffSet, yoffSet, size(template,2), size(template,1)]);
        end
    end
end

