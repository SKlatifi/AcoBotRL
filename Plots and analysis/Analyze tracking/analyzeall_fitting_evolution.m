
% load('D:\Under water vibrating plate\modelling method analysis\TracktestUW_2018_20_1\analyzed_data_alldata_exps.mat');
load('D:\Under water vibrating plate\modelling method analysis\Tracktest\merged_particledata.mat');

[GX,GY] = meshgrid(linspace(0,1,21),linspace(0,1,21));
[x,y] = meshgrid(0:0.05:1,0:0.05:1);
Map = struct('gU',[],'gV',[],'STD',[]);
   
for id = 1:59
    
    % Tracktest
    num_of_repitions = 50;
    N = floor(length(data{id})/num_of_repitions);
    for i = 1:num_of_repitions
        alldata{i} = data{id}((i-1)*floor(length(data{id})/num_of_repitions)+1:i*floor(length(data{id})/num_of_repitions),:);
    end
    n = 1:num_of_repitions;
    id
    
%     % Tracktest UW 
%     n = find(exps == id);
    
    rawdata = [];

    for i = 1:length(n)              
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
    end
    maps{id} = Map;
end
    
for id = 1:59
    for i = 1:length(n)  
        u = maps{id}(length(n)).gU - maps{id}(i).gU;
        v = maps{id}(length(n)).gV - maps{id}(i).gV;
        Mean(i) = mean(mean(sqrt(u.^2 + v.^2)));
    end
    plot(Mean,'LineWidth',1.4);
    xlabel('Experiment number');
    ylabel('Error');
    set(gcf, 'Position', [100, 100, 500, 500])
    title('Learning curve');
    axis([0 50 0 2])
    hold on;
end
