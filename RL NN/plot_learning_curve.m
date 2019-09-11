

load('D:\AcoBotRL\TempData\learning_curve\qvalue_evolution_note15.mat');
epi = 5:5:300;
error = zeros(size(epi));
for i = 1:size(NetMat,3)
    error(i) = sum(sum(abs(NetMat(:,:,end) - NetMat(:,:,i))));   
end

[fitresult, gof] = createFit(epi,error);

function [fitresult, gof] = createFit(epi,error)
%CREATEFIT1(EPI,REWARD)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : epi
%      Y Output: reward
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 30-Aug-2019 19:20:28


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( epi, error );

% Set up fittype and options.
ft = fittype( 'power1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [2.49913305241924 -0.573283184550156];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
f = figure( 'Name', 'power fit' );
set(f, 'Position', [100 100 450 300]);
h = plot( fitresult, xData, yData );
legend( h, 'Error vs. episode', 'Fitted curve', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'Episode No', 'Interpreter', 'none' );
ylabel( 'Error', 'Interpreter', 'none' );
title('Learning curve')
grid on
end
