n = 10000;
x = rand(n,1);
y = rand(n,1);
% generate data with outliers
z = sin(10 * x) .* cos(10 * y) + 0.1 * randn(n,1) + (rand(n,1) > 0.98) * 100;

plot3(x,y,z,'k.');

h = 1/160;
[xx,yy] = meshgrid(0:h:1,0:h:1);


tic;
[d,c] = binning([x y z],1/50,300);
toc;

tic;
fit2 = makefit(d(:,1),d(:,2),d(:,3),0.1,c);
toc;

tic;
surf(xx,yy,fit2(xx,yy));
toc;

tic;
fit = makefit(x,y,z,0.1);
toc;

%tic;
%surf(xx,yy,fit(xx,yy));
%toc;

