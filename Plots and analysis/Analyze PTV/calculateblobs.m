function blobs = calculateblobs(img, brightParticle, debug)

    % If particles are bright and plate is dark --> brightParticle = 1
    % If particles are dark and plate is bright --> brightParticle = 0

    DEBUG = 0;

    if (nargin>2)
        DEBUG = debug;
    end

    if (DEBUG) imshow(img), pause; end;
    
    if (brightParticle)
        I = img;
    else
        I = 255 - img;
    end
    
    if (DEBUG)imshow(I), pause;end;
    background = imopen(I,strel('disk',15));
    if (DEBUG)imshow(background), pause;end;

    I2 = I - background;
    if (DEBUG)imshow(I2), pause;end;

    level = graythresh(I2);
    bw = im2bw(I2,level);
    if (DEBUG)imshow(bw), pause;end;

    bwArea = bwareaopen(bw, 15);
    if (DEBUG)imshow(bwArea), pause;end;

    blobMeasurements = regionprops(bwArea,'centroid');
    allBlobCentroids = [blobMeasurements.Centroid];
    centroidsX = transpose(allBlobCentroids(1:2:end-1));
    centroidsY = transpose(allBlobCentroids(2:2:end));
    blobs = [centroidsX, centroidsY];
    
end