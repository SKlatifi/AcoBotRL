function [fitresult, gof] = createFit(gridx, gridy, Z, Span, title, plotIt)
%CREATEFIT(GRIDX,GRIDY,GRIDU)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : gridx
%      Y Input : gridy
%      Z Output: gridU
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 23-Jul-2015 15:59:16

if nargin<6 || isempty(plotIt)
    plotIt = 0;
end

%% Fit: 'untitled fit 1'.
[xData, yData, zData] = prepareSurfaceData( gridx, gridy, Z );

% Set up fittype and options.
ft = fittype( 'loess' );
opts = fitoptions( 'Method', 'LowessFit' );
opts.Normalize = 'on';
opts.Robust = 'LAR';
opts.Span = Span;

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );

if plotIt
    % Plot fit with data.
    figure( 'Name', title);
    h = plot( fitresult, [xData, yData], zData );
    legend( h, title, 'z vs. x, y', 'Location', 'NorthEast' );
    % Label axes
    xlabel x
    ylabel y
    zlabel z
    grid on
    view( -178.5, 52.0 );
end

