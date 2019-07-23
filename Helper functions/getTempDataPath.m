function ret = getTempDataPath()
    filepath = mfilename('fullpath');
    subpath = fileparts(filepath);
    mainpath = fileparts(subpath);
    ret = [mainpath '\TempData\'];
end