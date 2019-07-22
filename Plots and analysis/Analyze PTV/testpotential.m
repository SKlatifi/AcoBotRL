[gridx, gridy] = meshgrid(1:10,1:10)
F = sin(gridx/10 + 5*gridy/10);
gx = -[zeros(length(F),1) F(:,1:end-1)-F(:,2:end)];
gy = -[zeros(1, length(F)); F(1:end-1,:)-F(2:end,:)];
p = gradient2potential(gx, gy)
subplot(1,2,1); surf(gridx,gridy,F); subplot(1,2,2), surf(gridx, gridy, p);
