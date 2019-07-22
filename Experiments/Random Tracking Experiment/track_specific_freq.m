function track_specific_freq
    simulate = 0; % 1 = generated random images, 0 = get images over http
%     id = '600umsolder_20161801_tracktest'; % Identifier of the experiment run
    % Under water experiments    
    id = 'glass750_20180412_tracktest'; % Identifier of the experiment run
    desired_particles = 80; % How many particles should be on the plate, at least, for the experiment to start. Empty is means disabled.
    cycles = 50; % For each frequency, how many PTV steps is taken in total. The total number of exps cycles * number of frequencies    
    exps_before_reset = 5; % The balls are replaced to good locations every this many cycles                    
    
    % datapath = getTempDataPath();
    datapath = 'C:\Users\micronano\Documents\';
    
    % In air
    mkdir([datapath 'Tracktest_2018_20_1_franadole3\']);
    datafile = [datapath 'Tracktest_2018_20_1_franadole3\' id '.mat'];
    load('D:\Projects\Acobot\AcoLabControl\TempData\modeInfo2018_20_1_franadole2.mat');
    modeInfo.amp = 0.035;
    
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
        beforefile = sprintf('%sTracktest_2018_20_1_franadole3\\%s_%06d_%.0f_%.0f_%.3f_in.jpg',datapath,id,i,modeInfo.freq(exps(i)),modeInfo.duration(exps(i)),modeInfo.amp(exps(i)));       
        afterfile = sprintf('%sTracktest_2018_20_1_franadole3\\%s_%06d_%.0f_%.0f_%.3f_out.jpg',datapath,id,i,modeInfo.freq(exps(i)),modeInfo.duration(exps(i)),modeInfo.amp(exps(i)));
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