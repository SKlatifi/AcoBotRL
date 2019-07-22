function gradmap = fitVmap(P_List, V_List, numOfGrids, Span)

% fitU :    Object including the fitted model to x gradient
% fitV :    Object including the fitted model to y gradient
% Uerr :    

numGrids = 50;
span = 0.15;
if nargin >= 3
    numGrids = numOfGrids;
end
if nargin >= 4
    span = Span;
end
%% create flatted X, Y, U, V vectors
runs = size(P_List,1);
X = [];
Y = [];
U = [];
V = [];

figH = figure;

for i = 1:runs
    trail = [];
    for j = 1:size(P_List,2)-1
        idx = find(~isnan(P_List{i,j}(:,1)));
        X = [X;P_List{i,j}(idx,1)];
        Y = [Y;P_List{i, j}(idx,2)];
        U = [U; V_List{i, j+1}(idx,1)];
        V = [V; V_List{i, j+1}(idx,2)];
        
        trail = PlotTrail(trail, P_List, i, j, 0);
    end
    trail = PlotTrail(trail, P_List, i, j, 1);

    plot(P_List{i,j}(:,1),P_List{i,j}(:,2),'g+'),hold on;
end

%% create grids of U, V, Ustd and Vstd
dx = maxX /numGrids;
dy = maxY /numGrids;

[gridx,gridy] = meshgrid(dx/2:dx:maxX-dx/2,dy/2:dy:maxY-dy/2);
gridU = [];
gridV = [];
Ustd = [];
Vstd = [];

for i = 1:length(gridx)
    rowU = [];
    rowV = [];
    rowUstd = [];
    rowVstd = [];
    
    for j = 1:length(gridy)
        idx = find(X >= gridx(i,j)-dx/2 & X < gridx(i,j)+dx/2 & Y >= gridy(i,j)-dy/2 & Y < gridy(i,j)+dy/2);
        u = nan; v = nan;
        ustd = nan; vstd = nan;
        if (~isempty(idx))
            u = mean(U(idx));
            v = mean(V(idx));
            ustd = std(U(idx)); 
            vstd = std(V(idx));           
        end
        rowU = [rowU u];
        rowV = [rowV v];
        rowUstd = [rowUstd ustd];
        rowVstd = [rowVstd vstd];
    end
    gridU = [gridU; rowU];
    gridV = [gridV; rowV];
    Ustd = [Ustd; rowUstd];
    Vstd = [Vstd; rowVstd];
end

%quiver(gridx,gridy,gridU,gridV, 'k-');
%set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse')

%% fit the U and V with a function, the coefficients is currently hard coded, improvement may require
[fitU, gofU] = createFit(gridx, gridy, gridU, span);
[fitV, gofV] = createFit(gridx, gridy, gridV, span);

pU = fitU(gridx,gridy);
pV = fitV(gridx,gridy);

%% calculate Uerr and Verr by comparing the grid U and V value with the fitted model
Uerr = gridU - pU;
Verr = gridV - pV;


%% display the comparism of the original data, the grid U and V, and the fitted model
figure(figH);
quiver(gridx,gridy,gridU,gridV,2, 'b-'); hold on;
quiver(gridx,gridy,pU,pV,2,'r-');
set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse')

struct gradmap;
gradmap.fitU = fitU;
gradmap.fitV = fitV;
gradmap.Uerr = Uerr;
gradmap.Verr = Verr;
gradmap.Ustd = Ustd;
gradmap.Vstd = Vstd;
gradmap.gridx = gridx;
gradmap.gridx = gridx;

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