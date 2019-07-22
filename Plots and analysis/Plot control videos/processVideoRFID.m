function processVideoRFID(filename,callback,frames)    
    v = VideoReader(filename);    
    i = 0;    
    while hasFrame(v)    
        frame = readFrame(v);
        if v.CurrentTime > 50
            break
        end
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