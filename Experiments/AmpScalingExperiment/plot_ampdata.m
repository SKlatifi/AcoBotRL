function plot_ampdata(datafile)

if (nargin < 1)
    datafile = '600umsolder_20161801_amptest.mat';
end

close all;
figure(1);
hold on;
figure(2);
hold on;

load (datafile);

explist =  1:length(expfreq);
% explist = explist(explist ~= 29 & explist ~= 31);

alast = [];
f = [];
for i = explist
    ind = exps == i & ~isnan(amps);
    a = amps(ind);
    m = movements(ind);
    if (~isempty(a))
        f(end+1) = expfreq(i);
        alast(end+1) = a(end);
    else
        f(end+1) = expfreq(i);
        alast(end+1) = 0;
    end
    figure(1);
    plot(m);
    xlabel('Experiment number');
    ylabel('Movement, in plate units');
    figure(2);
    ma = max(log(expfreq));
    mi = min(log(expfreq));
    d = (log(expfreq(i))-mi)/(ma-mi);
    c = [d 0 1-d];
    plot(a * 20 * 4.5,'Color',c);
    xlabel('Experiment number (unitless)');
    ylabel('Amplitude (V)');    
    box on;
    fsize = 15;
    set(gca,'FontName','Arial','FontSize', fsize) % Arial everywhere, the point size depends on the size of you Figure object, let's adjust that finally so they are close to identical in the final Figure
    h = get(gca, 'title');
    set(h ,'FontName','Arial','FontSize', fsize)
    h = get(gca, 'xlabel');
    set(h,'FontName','Arial','FontSize', fsize)
    h = get(gca, 'ylabel');
    set(h ,'FontName','Arial','FontSize', fsize)
    set(gcf,'color','w'); % white background   
end

%%
figure(3);
[f,ind] = sort(f);
alast = alast(ind);
plot(f,1 ./ alast);
xlabel('Frequency (Hz)');
ylabel('1 / Amplitude (V^{-1})');
% set(gca,'Xscale','log');
set(gca,'Yscale','log');