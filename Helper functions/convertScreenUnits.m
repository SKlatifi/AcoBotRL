function ret = convertScreenUnits(value,fromUnits,toUnits)

% Example: convertScreenUnits(10,'centimeters','pixels')

units = get(0,'units'); % Store the current units to reset
set(0,'units',fromUnits);
fromScale = get(0,'screensize');
set(0,'units',toUnits);
toScale = get(0,'screensize');
gain = toScale./fromScale;
ret = value * gain(end);
set(0,'units',units)