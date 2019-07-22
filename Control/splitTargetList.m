function ret = splitTargetList(list,desiredSpacing)

ret = list(1,:);

for i = 2:size(list,1)
   delta = list(i,:) - list(i-1,:);
   dist = sqrt(sum(delta .^ 2));
   steps = ceil(dist / desiredSpacing);
   blend = ((1:steps) / steps)';
   p = blend * delta;
   p(:,1) = p(:,1) + list(i-1,1);
   p(:,2) = p(:,2) + list(i-1,2);
   ret = [ret;p];
end