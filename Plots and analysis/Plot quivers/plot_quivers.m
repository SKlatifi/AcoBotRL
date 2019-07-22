function plot_quivers
    npoints = 25;
    filePath = getTempDataPath();    
    
    D = load('trackModesChromatic.mat');        
           
    plot_and_export(D,3951);    
    plot_and_export(D,7902);
    
    function plot_and_export(D,freq)
       f = figure;    
       axes('position', [0 0 1 1]);   
       set(f, 'Position', [100, 100, 700, 700]);   
       plot_quiver(D,freq,npoints);       
       filePrefix = sprintf('%d',freq);
       export_fig([filePath filePrefix 'quiver.pdf']);
    end

end