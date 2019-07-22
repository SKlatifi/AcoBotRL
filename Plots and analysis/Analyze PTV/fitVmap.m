function [gradmap, gofU, gofV, gofSE, gofSTD] = fitVmap(P_List, V_List, maxX, maxY, numGrids, span, spanSE, spanSTD, showFigure,  filePath, filePrefix)

% fitU :    Object including the fitted model to x gradient
% fitV :    Object including the fitted model to y gradient
% Uerr :    


if nargin < 5 || isempty(numGrids)
    numGrids = 50;
end
if nargin < 6 || isempty(span)
    span = 0.15;
end
if nargin < 7 || isempty(spanSE)
    spanSE = 0.015;
end
if nargin < 8 || isempty(spanSTD)
    spanSTD = 0.02;
end

if nargin < 9 || isempty(showFigure)
    showFigure = 0;
end
%% create flatted X, Y, U, V vectors
runs = size(P_List,1);
X = [];
Y = [];
U = [];
V = [];

if showFigure
    figH = figure;
end

for i = 1:runs
    trail = [];
    for j = 1:size(P_List,2)-1
        if isempty(V_List{i,j+1})
            continue;
        end
        idx = find(~isnan(P_List{i,j}(:,1)));
        X = [X;P_List{i,j}(idx,1)];
        Y = [Y;P_List{i, j}(idx,2)];
        U = [U; V_List{i, j+1}(idx,1)];
        V = [V; V_List{i, j+1}(idx,2)];
        
        if showFigure
            trail = PlotTrail(trail, P_List, i, j, 0);
        end
    end
    if showFigure
        trail = PlotTrail(trail, P_List, i, j, 1);
        plot(P_List{i,j}(:,1),P_List{i,j}(:,2),'g+'),hold on;
    end
end

%% create grids of U, V, Ustd and Vstd
dx = maxX /numGrids;
dy = maxY /numGrids;

[gridx,gridy] = meshgrid(dx/2:dx:maxX-dx/2,dy/2:dy:maxY-dy/2);
gridU = [];
gridV = [];
Ustd = [];
Vstd = [];
Usem = [];
Vsem = [];

for i = 1:length(gridx)
    rowU = [];
    rowV = [];
    rowUstd = [];
    rowVstd = [];
    rowUsem = [];
    rowVsem = [];
    
    for j = 1:length(gridy)
        idx = find(X >= gridx(i,j)-dx/2 & X < gridx(i,j)+dx/2 & Y >= gridy(i,j)-dy/2 & Y < gridy(i,j)+dy/2);
        u = nan; v = nan;
        ustd = nan; vstd = nan; usem = nan; vsem = nan;
        if (~isempty(idx))
            u = mean(U(idx));
            v = mean(V(idx));
            ustd = std(U(idx)); 
            vstd = std(V(idx));           
            N = length(U(idx));
            usem = ustd / sqrt(N); 
            vsem = vstd / sqrt(N);           
        end
        rowU = [rowU u];
        rowV = [rowV v];
        rowUstd = [rowUstd ustd];
        rowVstd = [rowVstd vstd];
        rowUsem = [rowUsem usem];
        rowVsem = [rowVsem vsem];
    end
    gridU = [gridU; rowU];
    gridV = [gridV; rowV];
    Ustd = [Ustd; rowUstd];
    Vstd = [Vstd; rowVstd];
    Usem = [Usem; rowUsem];
    Vsem = [Vsem; rowVsem];
end

%quiver(gridx,gridy,gridU,gridV, 'k-');
%set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse')

%% fit the U and V with a function, the coefficients is currently hard coded, improvement may require
[fitU, gofU] = createFit(gridx, gridy, gridU, span, 'U map');
[fitV, gofV] = createFit(gridx, gridy, gridV, span, 'V map');

pU = fitU(gridx,gridy);
pV = fitV(gridx,gridy);

%% calculate Uerr and Verr by comparing the grid U and V value with the fitted model
Uerr = gridU - pU;
Verr = gridV - pV;

% Squared error
SE = Uerr.^2 + Verr.^2;

[fitSE, gofSE] = createFit(gridx, gridy, SE, spanSE, 'Squared error map');

pSE = fitSE(gridx,gridy);


STD = sqrt(Ustd .^ 2 + Vstd .^ 2);
[fitSTD, gofSTD] = createFit(gridx, gridy, STD, spanSTD, 'STD map');
pSTD = fitSTD(gridx,gridy);

SEM = sqrt(Usem .^ 2 + Vsem .^ 2);
[fitSEM, gofSEM] = createFit(gridx, gridy, SEM, spanSE, 'SEM map');
pSEM = fitSEM(gridx,gridy);




%% display the comparism of the original data, the grid U and V, and the fitted model
if showFigure
    figure(figH);
    s = 3;
    quiver(gridx,gridy,gridU,gridV,s, 'b-'); hold on;
    quiver(gridx,gridy,pU,pV,s,'r-');
    title('Gradient map and fitted function');
    set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse');
    axis([-1 maxX+1 -1 maxY+1]);
    
    figure, subplot(1,4,1);
    s =5;
    quiver(gridx,gridy,Uerr,Verr,s, 'b-'); hold on;
    title('Error map');
    set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse');
    axis([-1 maxX+1 -1 maxY+1]);
    
    subplot(1,4,2);
    s =5;
    plot3(gridx,gridy,SE*s,'o','MarkerEdgeColor','k','MarkerFaceColor','r'); hold on;
    surf(gridx,gridy,pSE*s);
    title('Squared error map and fitted function');
    set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse');

    subplot(1,4,3);
    s =5;
    plot3(gridx,gridy,STD*s,'o','MarkerEdgeColor','k','MarkerFaceColor','r'); hold on;
    surf(gridx,gridy,pSTD*s);
    title('STD map and fitted function');
    set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse');    
    
    subplot(1,4,4);
    s =5;
    plot3(gridx,gridy,SEM*s,'o','MarkerEdgeColor','k','MarkerFaceColor','r'); hold on;
    surf(gridx,gridy,pSEM*s);
    title('SEM map and fitted function');
    set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse');
    tightfig;
    
    f = figure;    
    [pX,pY] = meshgrid(linspace(10,maxX-10,17),linspace(10,maxY-10,17));
    pU = fitU(pX,pY);
    pV = fitV(pX,pY);    
    axes('position', [0 0 1 1]);   
    lh = quiver(pX,pY,pU,pV,2.8,'b-');        
    set(f, 'Position', [100, 100, 700, 700]);   
    
    set(gca, 'YDir', 'reverse');
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])        
    axis([0 maxX 0 maxY] + 0.5);
    set(lh,'linewidth',1);    
    box off;
    export_fig([filePath filePrefix 'quiver.pdf']);
end

gradmap = struct;
gradmap.fitU = fitU;
gradmap.fitV = fitV;
gradmap.fitSE = fitSE;
gradmap.fitSTD = fitSTD;
gradmap.fitSEM = fitSEM;
gradmap.gridx = gridx;
gradmap.gridy = gridy;
gradmap.maxX = maxX;
gradmap.maxY = maxY;
end


% PWellV = gradient2potential(pU, pV);
% PWellU = gradient2potential(pV, pU);
% 
% [mx, my] = size(PWellV);
% 
% %pUh = -[zeros(length(PWellU),1) PWellU(:,1:end-1)-PWellU(:,2:end)];
% pUh = -[zeros(1, length(PWellU)); PWellU(1:end-1,:)-PWellU(2:end,:)];
% pVh = -[zeros(1, length(PWellV)); PWellV(1:end-1,:)-PWellV(2:end,:)];
% 
% subplot(2,2,1); surf(gridx,gridy,pUh); subplot(2,2,2); surf(gridx,gridy, pU)
% subplot(2,2,3); surf(gridx,gridy,pVh); subplot(2,2,4); surf(gridx,gridy, pV)
% 
% figure, subplot(1,2,1), surf(gridx, gridy, PWellV); subplot(1,2,2), surf(gridx, gridy, -PWellU);
% surf(gridx,gridy,PWellV);set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse')


% subplot(1,3,1);
% surf(gridx,gridy,pU);xlabel('x'); ylabel('y'); colorbar; set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse')
% subplot(1,3,2); 
% surf(gridx,gridy,pV); xlabel('x'); ylabel('y'); colorbar; set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse')
% subplot(1,3,3); 
% surf(gridx,gridy,PWell); xlabel('x'); ylabel('y'); colorbar; set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse')



%surf(gridx,gridy,fitresult(gridx,gridy))