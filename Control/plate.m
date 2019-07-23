function ret = plate()
    ret = struct('play',@play,'findParticles',@findParticles,'getClicks',@getClicks,'visualize',@visualize);
    
    pixelSize = convert(httpcommand('GetSize'));
    
    function p = convert(str)        
        p = sscanf(str,'%f,%f; ');	
        p = reshape(p,2,length(p) / 2)';
    end

    function visualize(p,phat,t,modelVis)
        trackingInfo.p0 = p .* (ones(size(p,1),1) * pixelSize);
        trackingInfo.p1 = phat .* (ones(size(phat,1),1) * pixelSize);         
        trackingInfo.target = t .* (ones(size(t,1),1) * pixelSize);
        save('D:\Projects\Acobot\AcoLabControl\TempData\trackingInfo.mat','trackingInfo');
        httpcommand('SetTrackingInfoFilePath','filename','D:\Projects\Acobot\AcoLabControl\TempData\trackingInfo.mat');
    end
    
    function play(params)      
        if (size(params,1) == 1)
            playSingleSignal(params(1,1),params(1,2),params(1,3));            
        else
            playMultiSignal(params);
        end
    end   

    function playMultiSignal(params)
        freqs = tostring(params(:,1));
        amps =  tostring(params(:,2) * 4.5);
        durations = tostring(params(:,3)*1000);
        httpcommand('PlayMultiSignal', 'bias', 3, 'amps', amps, 'freqs', freqs, 'durations', durations);       
    end

    function ret = tostring(a)       
       ret = sprintf('%.3f,' , a); 
       ret = ret(1:end-1);% strip final comma 
    end

%     function playMultiSignal(params)        
%         T = 1/2e6;
%         freq = params(:,1);
%         amp = params(:,2);
%         duration = params(:,3);
%         waveForm = [];
%         for i = 1:length(duration)                        
%             t = (0:T:duration(i))';   
%             s = envelopedSinusoid(t,freq(i));
%             s = pad(s,length(waveForm));
%             waveForm = pad(waveForm,length(s));            
%             waveForm = waveForm + amp(i) * s; 
%         end
%         waveForm = 4.5 * waveForm + 3;
%         playArbitrarySignal(waveForm');
%         pause(max(duration));
%     end

    function s = pad(s,l)
        ls = length(s);
        if (ls < l)
            s = [s;zeros(l - ls,1)];
        end
    end

    function playSingleSignal(freq,amp,duration)
        amp = min(max(amp,0),1);
        httpcommand('PlaySmoothSignal', 'amp', amp * 4.5, 'bias', 3, 'freq', freq, 'duration', duration*1000,...
            'envelope','Triangular');        
        pause(3*duration); % 1.1 for air; 2 for water
    end

    function ret = findParticles()
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