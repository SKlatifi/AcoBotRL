
modeInfofile = [getTempDataPath() 'modeInfo.mat'];
load(modeInfofile);
cycles = 30;
N = length(modeInfo.freq);

for i = 1:cycles
    for j = 1:N
        playsignal(modeInfo.freq(j),modeInfo.amp(j),modeInfo.duration(j));  
        pause(modeInfo.duration(j)/1000 + 0.5);  % For under water + 3 ; For air + 0.5 
        fprintf('%.0f percent done....\n',i*j*100 / (N*cycles));
    end
end
