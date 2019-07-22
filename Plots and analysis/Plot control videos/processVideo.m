function processVideo(filename,callback,frames)    
    v = VideoReader(filename);    
    i = 0;    
    while hasFrame(v)    
        frame = readFrame(v);
        i = i + 1;
        if (nargin > 2) 
            if (any(abs(i-frames)<1e-8))
                callback(frame);
            end
        else
            callback(frame);
        end
    end
end

