function amp_main
    simulate = 0; % 1 = generated random images, 0 = get images over http
    id = 'solderball_20190806_amptest'; % Identifier of the experiment run
    desired_particles = 80; % How many particles should be on the plate, at least, for the experiment to start
    desired_stepSize = 0.0035; % The experiment tries to adjust the amplitudes so that the 75% of the particles move less than this
    cycles = 30; % For each frequency, how many PTV steps is taken in total. The total number of exps cycles * number of frequencies
    minfreq = 1000; % All notes from the scale below this frequency are discarded.
    maxfreq = 20000; % All notes from the scale above this frequency are discarded
    duration = 500; % in milliseconds, constant for all notes
    default_amp = 0.02; % starting amplitude: for 2*3*5 actuators = 0.02; for 2*3*20 actuators = 0.005
    min_amp = 0.001; % never decrease amplitude below this
    max_amp = 1; % never increase amplitude above this
    max_increase = 1.5; % never increase the amplitude more than 1.5 x from the previous experiment
    exps_before_reset = 30; % The balls are replaced to good locations every this many cycles
    % basescale = [261.63 293.66 329.63 349.23 392.00 440.00 493.88]; % C major
    basescale = [261.63 277.18 293.66 311.13 329.63 349.23 369.99 392.00 415.30 440.00 466.16 493.88]; % chromatic             
    
    prefiximg = [getTempDataPath() 'Amptest_RL_2019_P2\'];
    mkdir(prefiximg)
    datafile = [prefiximg id '.mat'];   
    tmpscalemat = basescale' * (2.^(-10:10));
    tmpscale = reshape(tmpscalemat,1,numel(tmpscalemat));    
    expfreq = tmpscale(tmpscale >= minfreq & tmpscale <= maxfreq);     
    rand('twister', 5489);
        
    M = length(expfreq);        
    exps = zeros(1,M*cycles);
    for i = 1:cycles
        exps((i*M-M+1):(i*M)) = randperm(M);
    end      
    
    exp_counter = 0;
    N = length(exps);
    tol = 1e-6;

    if (exist(datafile,'file'))
        load(datafile);
    else
        movements = nan(1,N);
        freqs = nan(1,N);   
        amps = nan(1,N);
        durations = nan(1,N);
    end
    
    for i = 1:N
        if isnan(amps(i)) 
            beforefile = sprintf('%s%s_%06d_%.0f_%.0f_in.jpg',prefiximg,id,i,expfreq(exps(i)),duration);       
            afterfile = sprintf('%s%s_%06d_%.0f_%.0f_out.jpg',prefiximg,id,i,expfreq(exps(i)),duration);
            if ~exist(beforefile,'file') || ~exist(afterfile,'file')
                freq = expfreq(exps(i));
                % 
                ind = ~isnan(amps) & (abs(freq - freqs) < tol) & (abs(durations - duration) < tol);
                prevAmps = amps(ind);
                if (isempty(prevAmps))
                    amp = default_amp;
                else
                    prevMovements = movements(ind);
                    amp = chooseNextAmp(prevMovements,prevAmps);
                end
                if (exp_counter >= exps_before_reset)
                    fprintf('Redistribute the particles evenly on the plate and hit enter when ready\n');
                    pause();
                    exp_counter = 0;
                end
                doAmpExperiment(beforefile,afterfile,freq,amp,duration,desired_particles,simulate);
                exp_counter = exp_counter + 1;
            end
            [movements(i),freqs(i),amps(i),durations(i)] = load_amp_exp(beforefile,afterfile);            
            save(datafile,'expfreq','exps','movements','freqs','amps','durations');              
            fprintf('%d / %d (%.0f%% done) %1.1f %1.3f %1.4f\n',i,N,i * 100 / N, freqs(i), amps(i), movements(i) );
        end       
        
        if (mod(i,100) == 0)
          plot_ampdata(datafile);
        end
    end    
    
    make_modeinfo(datafile);
    
    function ret = chooseNextAmp(prevMovements,prevAmps)  
        k = median(prevAmps ./ prevMovements);              
        ret = k * desired_stepSize;                
        last_good_amp = max(prevAmps(prevMovements < desired_stepSize));
        if (isempty(last_good_amp))
            last_good_amp = default_amp;        
        end
        ret = max(min(min(ret,last_good_amp * max_increase),max_amp),min_amp);
    end
end