function playArbitrarySignal(waveForm)

waveForm = min(max(waveForm,-1.5),7.5);

signal = waveForm;
file = [tempname,'.mat']; 
save(file,'signal');
httpcommand('PlayFile', 'filename', file);
delete(file);
