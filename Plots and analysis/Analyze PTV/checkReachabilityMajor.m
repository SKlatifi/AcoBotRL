global Map;

fileName = 'D:\Projects\Acobot\AcoLabControl\TempData\PPMap.mat';
if exist(fileName, 'file') == 2
    var = load(fileName);
    Map = var.Map;
else
    Map = GeneratePPMap(modeInfo);
    save(fileName,'Map');
end

% Check North and South

for i = 1:size(Map(1).gV,1)
    for j = 1:size(Map(1).gV,2)
        tempVectNS = zeros(1,length(Map)+1);
        tempVectWE = zeros(1,length(Map)+1);

        for k = 1:length(Map)
            if abs(Map(k).gV(i,j)) > 1.73* abs(Map(k).gU(i,j)) %tan(60) = 1.73
                tempVectNS(k) = Map(k).gV(i,j);
                tempVectWE(k) = 0;
            elseif abs(Map(k).gU(i,j)) > 1.73* abs(Map(k).gV(i,j))
                tempVectNS(k) = 0;
                tempVectWE(k) = Map(k).gU(i,j);
            else
                tempVectNS(k) = Map(k).gV(i,j);
                tempVectWE(k) = Map(k).gU(i,j);    
            end
        end
        
        southVect(i,j) = max(tempVectNS);
        northVect(i,j) = abs(min(tempVectNS));
        eastVect(i,j) = max(tempVectWE);
        westVect(i,j) = abs(min(tempVectWE));
    end
end

figure(1);
subplot(221);
h = surf(southVect, 'EdgeColor','none','LineStyle','none','FaceLighting','phong');
title('South');
xlabel('x'); ylabel('y');
set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse');
axis([0 830 0 830 0 10]);
view(0,90);

subplot(222);
h = surf(northVect,'EdgeColor','none','LineStyle','none','FaceLighting','phong');
title('North');
xlabel('x'); ylabel('y');
set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse');
axis([0 830 0 830 0 10]);
view(0,90);

subplot(223);
h = surf(eastVect, 'EdgeColor','none','LineStyle','none','FaceLighting','phong');
title('East');
xlabel('x'); ylabel('y');
set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse');
axis([0 830 0 830 0 10]);
view(0,90);

subplot(224);
h = surf(westVect, 'EdgeColor','none','LineStyle','none','FaceLighting','phong');
title('West');
xlabel('x'); ylabel('y');
set(gca,'xaxislocation','top','yaxislocation','left','xdir','normal','ydir','reverse');
axis([0 830 0 830 0 10]);
view(0,90);

fileName = 'D:\Projects\Acobot\AcoLabControl\TempData\ReachMap.mat';
RMap.north = northVect;
RMap.south = southVect;
RMap.east = eastVect;
RMap.west = westVect;
save(fileName,'RMap');

