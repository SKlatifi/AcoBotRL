function Map = GeneratePPMap(modeInfo)

    s1 = size(modeInfo.gradient{1}.gridx,1); 
    s2 = size(modeInfo.gradient{1}.gridy,1); % possible bug
    s3 = length(modeInfo.freq);

    Map = struct('gU',[],'gV',[],'STD',[],'SE',[]);

    
    parfor i = 1:s3
        %[gridx,gridy] = meshgrid(1:1:size(modeInfo.gradient{i}.gridx,1), 1:1:size(modeInfo.gradient{i}.gridy,1));
        [gridx,gridy] = meshgrid(1:1:modeInfo.gradient{i}.maxX,1:1:modeInfo.gradient{i}.maxY);
        Map(i).gridx = gridx;
        Map(i).gridy = gridy;
        tic
        Map(i).gU = modeInfo.gradient{i}.fitU(gridx, gridy);
        toc
        Map(i).gV = modeInfo.gradient{i}.fitV(gridx, gridy);
        Map(i).STD = modeInfo.gradient{i}.fitSTD(gridx, gridy);
        Map(i).SE = modeInfo.gradient{i}.fitSE(gridx, gridy);
    end

end
