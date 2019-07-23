function plot_chladni_figures
    close all;
    % page size after margins is 229 x 170 mm    
    fs =[];
    basescale = {'C','C^#','D','D^#','E','F','F^#','G','G^#','A','A^#','B'};    
        
    D = load('trackModesChromatic.mat');
    [freqs,ind] = sort(D.modeInfo.freq);
    
    notenumbers = round(log2(freqs/440)*12+9);
    octaves = fix(notenumbers/12)+4;
    notenames = arrayfun(@(x,y) sprintf('%s_{%d}',x{1},y),basescale(mod(notenumbers,12)+1),octaves,'UniformOutput', false);
    
    
    D.modeInfo.freq = freqs;    
    D.Map = D.Map(ind);
    D.modeInfo.amp = D.modeInfo.amp(ind);
    D.modeInfo.duration = D.modeInfo.duration(ind);
    D.modeInfo.material = D.modeInfo.material(ind);        
    numfigs = (fix((length(D.modeInfo.freq)-1) / 28)+1);
    for i = 1:numfigs
        fs(i) = figure('Units','centimeters','Position',[1 1 16.8 22]);                    
        set(gcf,'color','w');
    end        
    for i = 1:length(D.modeInfo.freq)        
        c = mod(i-1,7);
        rp = fix((i-1)/7);
        r = 3 - mod(rp,4);
        p = fix(rp/4)+1;
        figure(fs(p));
        freq = D.modeInfo.freq(i);
        axes('Units','centimeters','Position',[2.4*c r*5.5+2.4 2.4 2.4]);
        plot_quiver(D,freq,20,0.5);
        box on;
        text(1.2,2.402,sprintf('%s (%d Hz)',notenames{i},round(freq)),'Units','centimeters','HorizontalAlignment','center','VerticalAlignment','bottom','FontName','Arial','FontSize',10);  
        axes('Units','centimeters','Position',[2.4*c r*5.5 2.4 2.4]);
        gamma = 0.02;
        Cexp = 0.184355181520987;
        w = 50e-3;        
        k = sqrt(freq / Cexp);
        knorm = k * w / pi;
        N = 10;
        S(knorm,gamma,N,'reuse');
        set(gca,'xtick',[]);
        set(gca,'xticklabel',[]);
        set(gca,'ytick',[]);
        set(gca,'yticklabel',[]);               
        i
    end    
    for i = 1:numfigs
        figure(fs(i));
        export_fig(sprintf('../../TempData/Manip%d.pdf',i));
        export_fig(sprintf('../../TempData/Manip%d.png',i),'-r600');
    end
end
    