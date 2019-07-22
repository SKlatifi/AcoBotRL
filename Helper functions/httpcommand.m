function [value] = httpcommand(command, varargin)

if (nargin == 0)
    value = urlread('http://localhost:2020/');
    return
end

arg = cell(1,nargin+1);
arg{1} = 'command';
arg{2} = command;
if (nargin>1)   
    for i = 1:nargin-1
        if (isnumeric(varargin{i}))
            arg{i+2} = num2str(varargin{i});
        else
            arg{i+2} = varargin{i};
        end
    end 
end

value = urlread('http://localhost:2020/','GET',arg);
 
