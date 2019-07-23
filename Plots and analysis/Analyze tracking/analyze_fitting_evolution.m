function maps = analyze_fitting_evolution

    load('D:\Under water vibrating plate\modelling method analysis\TracktestUW_2018_20_1\analyzed_data_alldata_exps.mat');
%     load('D:\Under water vibrating plate\modelling method analysis\Tracktest\merged_particledata.mat');
         
    id = 50;
    
    [GX,GY] = meshgrid(linspace(0,1,21),linspace(0,1,21));
    [x,y] = meshgrid(0:0.05:1,0:0.05:1);
    Map = struct('gU',[],'gV',[],'STD',[]);
    
    writerObj = VideoWriter(['D:\Under water vibrating plate\modelling method analysis\TracktestUW_2018_20_1\evolutionID',num2str(id),'.avi']);
    writerObj.FrameRate = 3; % How many frames per second.
    open(writerObj); 
    
%     % Tracktest
%     num_of_repitions = 50;
%     N = floor(length(data{id})/num_of_repitions);
%     for i = 1:num_of_repitions
%         alldata{i} = data{id}((i-1)*floor(length(data{id})/num_of_repitions)+1:i*floor(length(data{id})/num_of_repitions),:);
%     end
%     n = 1:num_of_repitions;

    % Tracktest UW        
    n = find(exps == id);
    rawdata = [];

    for i = 1:length(n)   
        i
        rawdata = [rawdata; alldata{n(i)}];
        span = 1/20;
        [d,w] = binning(rawdata,span);              	    
        fitU = makefit(d(:,1),d(:,2),d(:,3),span,w);
        fitV = makefit(d(:,1),d(:,2),d(:,4),span,w);
        UVhat = [fitU(d(:,1),d(:,2)) fitV(d(:,1),d(:,2))];
        e = d(:,3:4) - UVhat;
        variance = sum(e .^ 2,2);
        fitVar = makefit(d(:,1),d(:,2),variance,span,w);              
        fitStd = @(x,y) sqrt(max(0,fitVar(x,y)));
        Map(i).gU = fitU(GX,GY);
        Map(i).gV = fitV(GX,GY);    
        Map(i).STD = fitStd(GX,GY);
        h = quiver(x,y,Map(i).gU,Map(i).gV,4); 
        set(h,'linewidth',1.4);
        axis equal
        axis tight
        set(gcf, 'Position', [100, 100, 500, 500])
        axis([0 1 0 1]);   
        set(gca,'xtick',[])
        set(gca,'xticklabel',[])
        set(gca,'ytick',[])
        set(gca,'yticklabel',[])
        title(['Model after ',num2str(i),' experiments']);                
        frame = getframe(gcf); 
        writeVideo(writerObj, frame);
        pause(0.5);

    end
    close(writerObj);
       
    for i = 1:length(n)  
        u = Map(length(n)).gU - Map(i).gU;
        v = Map(length(n)).gV - Map(i).gV;
        Mean(i) = mean(mean(sqrt(u.^2 + v.^2)));
    end
    plot(Mean,'LineWidth',1.4);
    xlabel('Experiment number');
    ylabel('Error');
    set(gcf, 'Position', [100, 100, 500, 500])
    title('Learning curve');    

end
