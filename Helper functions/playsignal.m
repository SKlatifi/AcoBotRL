function playsignal(freq, amp, duration, envelope)
% Play a signal with given freq, amp and duration.
% The envelope should be a string: Triangular, Trapezoidal, or Sinusoidal.
% If the envelope is empty, no envelope will be used.
%
if (nargin < 4)
    envelope = 'Triangular';
else
    if ~isempty(envelope) && ~ischar(envelope)
        error('envelope should be a string or empty. ');
    end
end   

if  ~isempty(envelope) 
    httpcommand('PlaySmoothSignal', 'amp', amp * 4.5, 'bias', 3, 'freq', freq, 'duration', duration,...
        'envelope',envelope);
else
    httpcommand('PlaySignal', 'amp', amp * 4.5, 'bias', 3, 'freq', freq, 'duration', duration);    
end