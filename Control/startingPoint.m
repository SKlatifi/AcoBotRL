function startingPoint(distance)

    p1 = [0.25+0.5*rand(1),0.25+0.5*rand(1)];
    orientation = [-1+2*rand(1),-1+2*rand(1)];
    unitVector = orientation/norm(orientation);
    p2 = p1 + (distance/50)*unitVector;
    pt = [p1;p2];
    pixelSizeStr = httpcommand('GetSize');
    pixelSize = sscanf(pixelSizeStr,'%f,%f; '); 
    trackingInfo.p0 = pt .* (repmat(pixelSize',2,1));
    trackingInfo.p1 = pt .* (repmat(pixelSize',2,1));
    trackingInfo.target = pt .* (repmat(pixelSize',2,1));
    save('D:\Projects\Acobot\AcoLabControl\TempData\trackingInfo.mat','trackingInfo');
    httpcommand('SetTrackingInfoFilePath','filename','D:\Projects\Acobot\AcoLabControl\TempData\trackingInfo.mat');
    
end