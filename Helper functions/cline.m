% This function plots a 3D line (x,y,z) encoded with scalar color data (c)
% using the specified colormap (default=jet);
%
% SYNTAX: h=cline(x,y,z,c,colormap);
%
% DBE 09/03/02

function h=cline(x,y,c,cmap);

if nargin==0  % Generate sample data...
  x=linspace(-10,10,101);
  y=2*x.^2+3;
  c=exp(x);
  w=x-min(x)+1;
  cmap='jet';
elseif nargin<3
  fprintf('Insufficient input arguments\n');
  return;
elseif nargin==3
  cmap='jet';
end

cmap=colormap(cmap);                      % Set colormap
yy=linspace(min(c),max(c),size(cmap,1));  % Generate range of color indices that map to cmap
cm = spline(yy,cmap',c);                  % Find interpolated colorvalue
cm(cm>1)=1;                               % Sometimes iterpolation gives values that are out of [0,1] range...
cm(cm<0)=0;

% Lot line segment with appropriate color for each data pair...
  for i=1:length(x)-1
    h(i)=line([x(i) x(i+1)],[y(i) y(i+1)],'color',cm(:,i),'LineWidth',1);
  end

return
