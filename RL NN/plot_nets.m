

numGrid = 20;
lims = [0.2 0.8 0.1 0.5];
x = linspace(lims(1),lims(2),numGrid);
y = linspace(lims(3),lims(4),numGrid);
[X,Y] = meshgrid(x,y);
note = 15;
epi_start = 5;
epi_end = 300;
epi_inc = 5;
v = VideoWriter(strcat('q_value_evolution_note',num2str(note),'.avi'));
v.FrameRate = 3;
open(v);

% Make a mtrix for the real-time controller
NetMat = zeros(numGrid,numGrid,epi_end/epi_inc);

for epi = epi_start:epi_inc:epi_end
    epi
    datapath = getTempDataPath();
    load(strcat(datapath,'nets',num2str(epi),'.mat'));
    for i = 1:numGrid
        for j = 1:numGrid
            P = [x(j); y(i)];          
            NetMat(i,j,epi/epi_inc) = nets(note).net(P);            
        end
    end
    surf(X,Y,NetMat(:,:,epi/epi_inc));
    xlabel('x');
    ylabel('y');
    zlabel('Action vlaue');
    axis([lims -0.005 0.005]);
    title(strcat('Episode No:   ',num2str(epi)));
    frame = getframe(gcf);
    writeVideo(v,frame);
end

close(v);
