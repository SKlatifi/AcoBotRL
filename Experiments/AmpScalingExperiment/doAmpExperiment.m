function num_particles = doAmpExperiment(beforejpg,afterjpg,freq,amp,duration,desired_particles,simulate)
    if (nargin < 7)
        simulate = 0;
    end       
    
    comment = sprintf('Freq: %f Amp: %f Duration: %f',freq,amp,duration);

    while(true)
        img = grab();      
        if (isempty(desired_particles))
            break;
        end
        num_particles = size(find_blobs(img),1);
        if (num_particles >= desired_particles)
            break;
        end
        fprintf('Too few particles on the plate, please add more! Hit enter when ready. Is: %d Should be: %d\n',num_particles,desired_particles);
        pause;        
    end
    
    imwrite(img,beforejpg,'jpg','Comment',comment);
    if (~simulate)
        playsignal(freq, amp, duration);  
    	pause(duration / 1000 + 0.5);  % For under water + 3 ; For air + 0.5       
    end                   
    imwrite(grab(),afterjpg,'jpg','Comment',comment);
    
    function img = grab()
        if (simulate)
            gray = zeros(850,850);
            for i = 1:floor(rand() * 30-1+desired_particles)
                x = floor(rand() * 800+1);
                y = floor(rand() * 800+1);
                gray(y:(y+15),x:(x+15)) = 1;
            end
            img = gray(:,:,[1 1 1]);
        else
            tmpfile = 'C:\Users\micronano\Documents\AcoServer\Image\tmp.bmp';             
            httpcommand('GrabImage','filename', tmpfile);  
            pause(0.1);
            img = imread(tmpfile);
            delete(tmpfile);
        end
    end    
end