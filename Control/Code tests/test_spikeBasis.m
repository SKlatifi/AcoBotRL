addpath('..');

epsilon = 1e-12;

testCases = {
    {[0.5 0.5],2,[0 0 0;0 1 0;0 0 0],'Grid point in the middle not handled correctly'},...
    {[0.5 0.5],3,[0 0 0 0;0 0.25 0.25 0;0 0.25 0.25 0;0 0 0 0],'Grid point in the middle not handled correctly'},...
    {[0.25 0.5],2,[0 0 0;0.5 0.5 0;0 0 0],'Weights are not computed correctly'},...
    {[0.5 0.25],2,[0 0.5 0;0 0.5 0;0 0 0],'Weights are not computed correctly'},...
    {[0.25 0.25],2,[0.25 0.25 0;0.25 0.25 0;0 0 0],'Weights are not computed correctly'},...
    {[0 0],2,[1 0 0;0 0 0;0 0 0],'Top left grid point not handled correctly'},...
    {[1 0],2,[0 0 1;0 0 0;0 0 0],'Top right grid point not handled correctly'},...
    {[0 1],2,[0 0 0;0 0 0;1 0 0],'Botton left grid point not handled correctly'},...
    {[1 1],2,[0 0 0;0 0 0;0 0 1],'Bottom right grid point not handled correctly'},...
    {[0.25 0.5;0.5 0.25],2,{[0 0 0;0.5 0.5 0;0 0 0],[0 0.5 0;0 0.5 0;0 0 0]},'Multipoint case handled incorrectly'}
};

for i = 1:length(testCases)
   x = full(spikeBasis(testCases{i}{1}, testCases{i}{2}));
   expected = testCases{i}{3};
   if (iscell(expected))
       expCol = [];
       for j = 1:length(expected)
          newCol = expected{j}';
          newCol = newCol(:);
          expCol = [expCol newCol];
       end
   else
       expCol = expected';
       expCol = expCol(:);
   end      
   diff = x - expCol;
   assert(max(max(abs(diff))) < epsilon,testCases{i}{4});
end
