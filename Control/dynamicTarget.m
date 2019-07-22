function ret = dynamicTarget()

    str = httpcommand('GetPosition');
    pt = sscanf(str,'%f,%f; ');	
    pt = reshape(pt,2,length(pt) / 2)';
    pixelSizeStr = httpcommand('GetSize');
    pixelSize = sscanf(pixelSizeStr,'%f,%f; ');
    pt(:,1) = pt(:,1) / pixelSize(1);
    pt(:,2) = pt(:,2) / pixelSize(2);
    t = pt + (0.5 * (pt - repmat(centroid(pt),size(pt,1),1)));
    for i = 1:size(t,1)
        ret{i} = t(i,:);
    end
    
end