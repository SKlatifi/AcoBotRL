function ret = realPlate(modeInfo,maps)
    ret = struct('play',@play,'getPositions',@getPositions,'setTarget',@setTarget);
    
    pixelSize = convert(httpcommand('GetSize'));
    positions = [];    
    target = [];
    
    httpcommand('ShowVectorField','flag',0);
    httpcommand('StartOverlayDisplay');
    httpcommand('ShowTrackingPoints','flag',1);
    httpcommand('RecordRawImage','flag',1);
    httpcommand('StartTracking');
    httpcommand('TriggedRecording','flag',1);
    httpcommand('StopRecording');
    httpcommand('StartRecording');
    
    if (nargin < 2)
        maps = [];
    end

    % Public methods    
    
    function play(noteId)               
        if (noteId < 1 || noteId > length(modeInfo.freq))
            error('Invalid noteid, should be between 1..%d (was: %d)',length(modeInfo.freq),noteId);
        end
        visualize(noteId);        
        freq = modeInfo.freq(noteId);
        duration = modeInfo.duration(noteId);
        amp = min(max(modeInfo.amp(noteId),0),1);
        httpcommand('PlaySmoothSignal', 'amp', amp * 4.5, 'bias', 3, 'freq', freq, 'duration', duration,...
            'envelope','Triangular');        
        pause(duration/1000);
    end   

    function ret = getPositions()
        if (isempty(positions))
            positions = getClicks();
        end
        while(true)
            for retry = 1:10  % This is necessary on the real plate, because the machine vision sometimes failes due to lighting issues
                newPositions = matchLeft(getPositionsHttp(),positions);                        
                if (~isempty(newPositions) && all(size(newPositions) == size(positions)))
                    positions = newPositions;
                    ret = positions;
                    return;
                end
                pause(0.1);
            end           
            disp('Adjust machine vision, then hit enter');
            pause;
        end
        error('Machine vision failed');
    end

    function setTarget(t)
        target = t;
        visualize([]);
    end

    % Private methods

    function p = matchLeft(p1,p2)
        m = match(p1,p2);
        msort = sortrows(m,2);
        p = p1(msort(:,1),:);
    end        
    
    function p = convert(str)        
        p = sscanf(str,'%f,%f; ');	
        p = reshape(p,2,length(p) / 2)';
    end

    function visualize(noteId)
        if (~isempty(positions))
            trackingInfo.p0 = positions .* (ones(size(positions,1),1) * pixelSize);
            if (~isempty(noteId) && ~isempty(maps))
                phat = positions + [maps(noteId).deltaX(positions),maps(noteId).deltaY(positions)];
                trackingInfo.p1 = phat .* (ones(size(phat,1),1) * pixelSize);         
            end
        end
        if (~isempty(target))
            trackingInfo.target = target .* (ones(size(target,1),1) * pixelSize);
        end
        save('D:\Projects\Acobot\AcoLabControl\TempData\trackingInfo.mat','trackingInfo');
        httpcommand('SetTrackingInfoFilePath','filename','D:\Projects\Acobot\AcoLabControl\TempData\trackingInfo.mat');
    end

    function ret = getPositionsHttp()
        ret = convert(httpcommand('GetPosition'));
        ret(:,1) = ret(:,1) / pixelSize(1);
        ret(:,2) = ret(:,2) / pixelSize(2);
    end

    function ret = getClicks()
        numParticles = input('Please enter the number of particles');
        ret = zeros(numParticles,2);
        for i = 1:numParticles
            disp(['Please click the particle #' num2str(i) ', then press a key']);
            pause;
            ret(i,:) = convert(httpcommand('GetMousePosition')) ./ pixelSize;   
        end        
    end    
end