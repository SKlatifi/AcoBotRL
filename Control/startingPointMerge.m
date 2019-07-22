function startingPointMerge(p1,p2)

    pt = [p1;p2];
    pixelSizeStr = httpcommand('GetSize');
    pixelSize = sscanf(pixelSizeStr,'%f,%f; '); 
    trackingInfo.p0 = pt .* (repmat(pixelSize',2,1));
    trackingInfo.p1 = pt .* (repmat(pixelSize',2,1));
    trackingInfo.target = pt .* (repmat(pixelSize',2,1));
    save('D:\Projects\Acobot\AcoLabControl\TempData\trackingInfo.mat','trackingInfo');
    httpcommand('SetTrackingInfoFilePath','filename','D:\Projects\Acobot\AcoLabControl\TempData\trackingInfo.mat');
    
end