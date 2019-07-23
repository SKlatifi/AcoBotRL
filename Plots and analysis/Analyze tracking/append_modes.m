
old_modes = 'D:\Projects\Acobot\AcoLabControl\TempData\trackModesChromaticUW_2018_20_1_m5.mat';
new_modes = 'D:\Projects\Acobot\AcoLabControl\TempData\trackModesChromaticUW_2018_20_1_extend.mat';

load(old_modes);
modeInfo_old = modeInfo;
Map_old = Map;

load(new_modes);
modeInfo_new = modeInfo;
Map_new = Map;

clear modeInfo Map

modeInfo.material(1:12) = modeInfo_new.material(1:12);
modeInfo.freq(1:12) = modeInfo_new.freq(1:12);
modeInfo.amp(1:12) = modeInfo_new.amp(1:12);
modeInfo.duration(1:12) = modeInfo_new.duration(1:12);
Map(1:12) = Map_new(1:12);

modeInfo.material(13:64) = modeInfo_old.material;
modeInfo.freq(13:64) = modeInfo_old.freq;
modeInfo.amp(13:64) = modeInfo_old.amp;
modeInfo.duration(13:64) = modeInfo_old.duration;
Map(13:64) = Map_old;

modeInfo.material(65:71) = modeInfo_new.material(13:19);
modeInfo.freq(65:71) = modeInfo_new.freq(13:19);
modeInfo.amp(65:71) = modeInfo_new.amp(13:19);
modeInfo.duration(65:71) = modeInfo_new.duration(13:19);
Map(65:71) = Map_new(13:19);

