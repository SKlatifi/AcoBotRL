function x = dropOutModes(folderName,oldData,dropOutNum,newData)  
   
    load(oldData);
    beforeNum = length(Map);
    [~,idx] = sort(modeInfo.freq);
    i = 1:length(idx); 
    if length(i)/dropOutNum >= 2
        r = beforeNum/dropOutNum;
        idx = idx(mod(i,r)>=1);
    else
        r = length(i)/(length(i)-dropOutNum);
        idx = idx(mod(i,r)<1);
    end
    x = length(idx);
    modeInfoNew.freq = modeInfo.freq(idx);
    modeInfoNew.amp = modeInfo.amp(idx);
    modeInfoNew.duration = modeInfo.duration(idx);
    modeInfoNew.material = modeInfo.material(idx);
    MapNew = Map(idx);
    newFileName = strcat(folderName,newData);
    modeInfo = modeInfoNew;
    Map = MapNew;
    save(newFileName,'Map','modeInfo');
    
end