function [amp, movement] = tune_final_amp

    simulate = 0; % 1 = generated random images, 0 = get images over http
    filename = [getTempDataPath 'modeInfo.mat'];
    
    id = 'solderball_20190806_amptest_tuning'; % Identifier of the experiment run
    desired_particles = 80; % How many particles should be on the plate, at least, for the experiment to start. Empty is means disabled.  
    exps_before_reset = 1; % The balls are replaced to good locations every this many cycles                    
    
    datapath = [getTempDataPath 'Amptest_RL_2019_P2_tuned\'];        
    mkdir(datapath);
    datafile = [datapath id '.mat'];
    load(filename); 
    
    % To change the amps whcih are very high
    load([datapath 'amp_movement_02.mat']);
    desired_move = 0.0035;
    max_tolerable_move = 0.0045;
    min_tolerable_move = 0.003;  
    modeInfo.amp = amp;
        
    for i = 1:length(modeInfo.amp)
        if (movement(i) > max_tolerable_move) || (movement(i) < min_tolerable_move)
            modeInfo.amp(i) = sqrt(desired_move/movement(i))*modeInfo.amp(i);
        end
        if modeInfo.amp(i) > 1
            modeInfo.amp(i) = 1;
        end
    end
    %
    
    num_particles = NaN;   
    exp_counter = 0;
    N = length(modeInfo.freq);
    
    movement = nan(1,N);
    freq = nan(1,N);   
    amp = nan(1,N);
    duration = nan(1,N);
    
    for i = 1:N
        beforefile = sprintf('%s%s_%06d_%.0f_%.0f_%.3f_in.jpg',datapath,id,i,modeInfo.freq(i),modeInfo.duration(i),modeInfo.amp(i));       
        afterfile = sprintf('%s%s_%06d_%.0f_%.0f_%.3f_out.jpg',datapath,id,i,modeInfo.freq(i),modeInfo.duration(i),modeInfo.amp(i));
        if ~exist(beforefile,'file') || ~exist(afterfile,'file')
            if (exp_counter >= exps_before_reset)
                fprintf('Redistribute the particles evenly on the plate and hit enter when ready\n');
                pause();
                exp_counter = 0;
            end
            num_particles = doAmpExperiment(beforefile,afterfile,modeInfo.freq(i),modeInfo.amp(i),modeInfo.duration(i),desired_particles,simulate);
            exp_counter = exp_counter + 1;            
        end 
        [movement(i),freq(i),amp(i),duration(i)] = load_amp_exp(beforefile,afterfile);            
        save(datafile,'movement','freq','amp','duration');              
        fprintf('%d / %d (%.0f%% done) %1.1f %1.3f %1.4f\n',i,N,i * 100 / N, freq(i), amp(i), movement(i) );       
    end    
end