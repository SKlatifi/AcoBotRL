function playsignalID(id, gain, timeScale, smooth)

if (nargin < 4 || isempty(smooth))
    smooth = true;
end   

if (smooth) 
    % note: the gain stored in the modeInfo, which used by C# code, is the 
    % normalized gain [0 1], so we need to multiply it with 4.5;
    % the gain here is the ratio between the played signal and the modelled signal
    % e.g. 1 means the signal played will be the same as the modelled
    % The same applies for time duration, 1 means the same duration as modelled
    httpcommand('PlaySmoothSignalID', 'id', id, 'scale', 4.5*gain, 'timeScale', timeScale, 'bias', 3, 'envelope', 'Triangular');
else
    httpcommand('PlaySignalID', 'id', id, 'scale', 4.5*gain, 'bias', 3);    
end