function vectorMap = create_vectormap(filename)
% create vectormap for C# code
    load('modeInfo.mat');
    for i=1:length(modeInfo.freq)
        vectorMap.signalID(i) = int16(i);
        vectorMap.freq(i) = modeInfo.freq(i);
        vectorMap.amp(i) = modeInfo.amp(i);
        vectorMap.duration(i) = modeInfo.duration(i);
        gu = modeInfo.gradient{i}.fitU(modeInfo.gradient{i}.gridx,modeInfo.gradient{i}.gridy);
        gv = modeInfo.gradient{i}.fitV(modeInfo.gradient{i}.gridx,modeInfo.gradient{i}.gridy);
        vectorMap.v0{i} = AppendField(modeInfo.gradient{i}.gridx, modeInfo.gradient{i}.gridy);
        vectorMap.v1{i} = AppendField(modeInfo.gradient{i}.gridx + gu, modeInfo.gradient{i}.gridy + gv);
    end
    save(filename, 'vectorMap');    
end

function V = AppendField(gx, gy)
    V = [];
    for i=1:size(gx,1)
        for j=1:size(gx,2)
            V = [V; gx(i,j) gy(i,j)];
        end
    end
end
