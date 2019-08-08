
scale = 0.2;
N_sides = 8;
t=(1/(N_sides*2):1/N_sides:1)'*2*pi;
x=sin(t);
y=cos(t);
x=scale*[x; x(1)] + 0.5;
y=scale*[y; y(1)] + 0.5;
plot(x,y)
axis([0 1 0 1])
set(gca,'Ydir','reverse')
axis square
