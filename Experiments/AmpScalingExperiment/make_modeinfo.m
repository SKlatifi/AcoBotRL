function make_modeinfo(datafile)

if (nargin < 1)
    datafile = '600um_solder_amptest.mat';
end

desired_stepSize = 0.0035; % The experiment tries to adjust the amplitudes 
load (datafile);

% basescale = [261.63 293.66 329.63 349.23 392.00 440.00 493.88]; % C major
basescale = [261.63 277.18 293.66 311.13 329.63 349.23 369.99 392.00 415.30 440.00 466.16 493.88]; % chromatic             
minfreq = 1000; % All notes from C major below this frequency are discarded.
maxfreq = 30000; % All notes from C major above this frequency are discarded
tmpscalemat = basescale' * (2.^(-10:10));
tmpscale = reshape(tmpscalemat,1,numel(tmpscalemat));    
manipulationfreq = tmpscale(tmpscale >= minfreq & tmpscale <= maxfreq);
M = length(manipulationfreq);

N = length(expfreq);
tol = 1e-1;

absdist = abs(ones(N,1) * manipulationfreq - expfreq' * ones(1,M));
chosen = any(absdist < tol,2)';
allList =  1:length(expfreq);
chosenList = allList(chosen);

K = length(chosenList);

alast = zeros(1,K);
f = zeros(1,K);
dlast = zeros(1,K);
material = cell(1,K);
for i = 1:K
    j = chosenList(i);
    ind = exps == j & ~isnan(amps);
    a = amps(ind);    
    d = durations(ind);
    
    dist = movements(ind);
    [xData, yData] = prepareCurveData( dist, a );
    ft = fittype( 'poly2' );
    [fitresult, gof] = fit( xData, yData, ft );
    fittedamp(i) = fitresult(desired_stepSize); 
    
    if fittedamp(i) > 1
        fittedamp(i) = 1;
    end
    
    material{i} = datafile;
	f(i) = expfreq(j);    
    if (~isempty(a))
        alast(i) = a(end);
        dlast(i) = d(end);
    else        
        alast(i) = 0;
        dlast(i) = 0;
    end    
end

modeInfo = struct();
modeInfo.material = material;
modeInfo.freq = f;
modeInfo.amp = alast; 
% modeInfo.amp = fittedamp; In PRL paper this method was used --> selecting the fitted amplitude
modeInfo.duration = dlast;

save ([getTempDataPath() 'modeInfo.mat'],'modeInfo');