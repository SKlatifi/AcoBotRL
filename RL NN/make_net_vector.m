
% load('nets5.mat');
% numGrid = 30;
% 
% X1 = linspace(0,1,numGrid);
% Y1 = linspace(0,1,numGrid);
% 
% N = numGrid;
% NN = N^2;
% NNN = N^3;
% NNNN = N^4;
% NNNNN = N^5;

% % Make a mtrix for the real-time controller
% for note = 1:length(nets)
%     note
%     tic
%     for y1 = 1:numGrid
%         for x1 = 1:numGrid
%             P = [X1(x1); Y1(y1)];
%             nets(note).NetMat(x1+N*(y1-1)) = nets(note).net(P);            
%         end
%     end       
%     toc
% end

load('nets2.mat');
numGrid = 31;
x = linspace(0,1,numGrid);
y = linspace(0,1,numGrid);

% Make a mtrix for the real-time controller
for note = 1:length(nets)
    note
    tic
    for i = 1:numGrid
        for j = 1:numGrid
            P = [x(j); y(i)];          
            nets(note).NetMat(i,j) = nets(note).net(P);            
        end
    end
    toc;
end
   