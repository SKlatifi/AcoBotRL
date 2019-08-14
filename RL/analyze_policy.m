
load('policy5000.mat');

for i = 1:size(thetaLearn,1)
    plot(thetaLearn(i,:));
    hold on;
    legend;    
end


