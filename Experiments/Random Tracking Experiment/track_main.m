function track_main
    simulate = 0; % 1 = generated random images, 0 = get images over http
    id = 'solderball_20190806_tracktest'; % Identifier of the experiment run
    desired_particles = 80; % How many particles should be on the plate, at least, for the experiment to start. Empty is means disabled.
    cycles = 50; % For each frequency, how many PTV steps is taken in total. The total number of exps cycles * number of frequencies    
    exps_before_reset = 25; % The balls are replaced to good locations every this many cycles                        
    datapath = getTrackingDataPath();   
    
    % In air
    prefiximg = [getTrackingDataPath() 'Tracktest_RL_2019_P2\'];
    mkdir(prefiximg)    
    datafile = [prefiximg id '.mat'];
    modeInfofile = [getTempDataPath() 'modeInfo.mat'];
    load(modeInfofile)
    
    % Replace amps with the final tuned ones
    load('D:\Projects\AcoBotRL\TempData\Amptest_RL_2019_P2_tuned\amp_movement_final.mat');
    modeInfo.amp = amp; 
    %
        
    rand('twister', 5489);
    M = length(modeInfo.freq);    
    
    exps = zeros(1,M*cycles);
    for i = 1:cycles
        exps((i*M-M+1):(i*M)) = randperm(M);
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