addpath('..');

modeInfo = loadVariable('modeInfo.mat','modeInfo');

epsilon = 1e-12;

gridSize = 20;
modes = fromData(modeInfo,loadVariable('PPMap.mat','Map'),20);
%%
for i = 1:length(modes.frequencies)
    maxX = modeInfo.gradient{i}.maxX;
    maxY = modeInfo.gradient{i}.maxY;
    mU = reshape(modes.w{i}(:,1),gridSize+1,gridSize+1);
    mV = reshape(modes.w{i}(:,2),gridSize+1,gridSize+1);
    eU = feval(modeInfo.gradient{i}.fitU,[1 1]) / maxX;
    eV = feval(modeInfo.gradient{i}.fitV,[1 1]) / maxY;
    assert(abs(mU(1,1)-eU) < epsilon,'FitU doesnt match at topleft');
    assert(abs(mV(1,1)-eV) < epsilon,'FitV doesnt match at topleft');
    eU = feval(modeInfo.gradient{i}.fitU,[maxX 1]) / modeInfo.gradient{i}.maxX;
    eV = feval(modeInfo.gradient{i}.fitV,[maxX 1]) / modeInfo.gradient{i}.maxY;
    assert(abs(mU(gridSize+1,1)-eU) < epsilon,'FitU doesnt match at topleft');
    assert(abs(mV(gridSize+1,1)-eV) < epsilon,'FitV doesnt match at topleft');
    eU = feval(modeInfo.gradient{i}.fitU,[1 maxY]) / modeInfo.gradient{i}.maxX;
    eV = feval(modeInfo.gradient{i}.fitV,[1 maxY]) / modeInfo.gradient{i}.maxY;
    assert(abs(mU(1,gridSize+1)-eU) < epsilon,'FitU doesnt match at topleft');
    assert(abs(mV(1,gridSize+1)-eV) < epsilon,'FitV doesnt match at topleft');
    eU = feval(modeInfo.gradient{i}.fitU,[maxX maxY]) / modeInfo.gradient{i}.maxX;
    eV = feval(modeInfo.gradient{i}.fitV,[maxX maxY]) / modeInfo.gradient{i}.maxY;
    assert(abs(mU(gridSize+1,gridSize+1)-eU) < epsilon,'FitU doesnt match at topleft');
    assert(abs(mV(gridSize+1,gridSize+1)-eV) < epsilon,'FitV doesnt match at topleft');
end