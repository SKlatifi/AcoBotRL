function p = gradient2potential(gx, gy)
% gx: M x M matrix
% gy: M x M matrix

startingline = cumsum(gx(1,:));
py = cumsum(gy);
p = repmat(startingline, length(startingline), 1) + py;

end