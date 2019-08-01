function track_main_1by1

    % The main difference between track_main_1by1 and track_main: 
    % track_main_1by1 plays one note cycles times and then starts the next note, 
    % but in track_main the notes are randomly played in a sequence
    
    simulate = 0; % 1 = generated random images, 0 = get images over http
    id = 'solderball_20190801_tracktest'; % Identifier of the experiment run
    desired_particles = 80; % How many particles should be on the plate, at least, for the experiment to start. Empty is means disabled.
    cycles = 50; % For each frequency, how many PTV steps is taken in total. The total number of exps cycles * number of frequencies    
    exps_before_reset = 10; % The balls are replaced to good locations every this many cycles                        
    datapath = getTrackingDataPath();   
    
    % In air
    prefiximg = [getTrackingDataPath() 'Tracktest_RL_1by1_2019_1\'];
    mkdir(prefiximg)    
    datafile = [prefiximg id '.mat'];
    modeInfofile = [getTempDataPath() 'modeInfo.mat'];
    load(modeInfofile)
    
%     % Replace amps with the final tuned ones
%     load('D:\Projects\Acobot\AcoLabControl\TempData\Amptest2018_1_tuned\amp_movement_final.mat');
%     modeInfo.amp = amp;    
%     %

    % Experiments 1 by 1
    exps = zeros(1,M*cycles);
    for i = 1:M
        for j = 1:cycles
            exps((i-1)*cycles + j) = i;
        end
    end
    
    num_particles = NaN;
    
    exp_counter = 0;
    N = length(exps);
    tol = 1e-2;
    
    save(datafile,'exps','modeInfo');
    
    for i = 1:N        
        beforefile = sprintf('%s%s_%06d_%.0f_%.0f_%.3f_in.jpg',prefiximg,id,i,modeInfo.freq(exps(i)),modeInfo.duration(exps(i)),modeInfo.amp(exps(i)));       
        afterfile = sprintf('%s%s_%06d_%.0f_%.0f_%.3f_out.jpg',prefiximg,id,i,modeInfo.freq(exps(i)),modeInfo.duration(exps(i)),modeInfo.amp(exps(i)));
        if ~exist(beforefile,'file') || ~exist(afterfile,'file')
            if (exp_counter >= exps_before_reset)
                fprintf('Redistribute the particles evenly on the plate and hit enter when ready\n');
                pause();
            exp_counter = 0;
            end
            num_particles = doAmpExperiment(beforefile,afterfile,modeInfo.freq(exps(i)),modeInfo.amp(exps(i)),modeInfo.duration(exps(i)),desired_particles,simulate);
            exp_counter = exp_counter + 1;            
        end        
        fprintf('%d / %d (%.0f%% done) Particles: %d\n',i,N,i * 100 / N,num_particles);        
    end    
end