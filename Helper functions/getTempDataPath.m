function ret = getTempDataPath()
    mpath = mfilename('fullpath');
    [pathstr,name,ext] = fileparts(mpath);
    ret = [pathstr '\..\TempData\'];
    ret = 'D:\Projects\Acobot\AcoLabControl\TempData\'; %% for under water experiments
end