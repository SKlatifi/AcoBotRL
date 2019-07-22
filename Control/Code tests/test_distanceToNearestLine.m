addpath('..');

eps = 1e-12;

assert(abs(distanceToNearestLine([1 1],[1 0 1 2]) - 0) < eps,'Distance on the line was not computed correctly');
assert(abs(distanceToNearestLine([0 1],[1 0 1 2]) - 1) < eps,'Distance away from the line was not computed correctly');
assert(abs(distanceToNearestLine([2 1],[1 0 1 2]) - 1) < eps,'Distance away from the line was not computed correctly');

assert(abs(distanceToNearestLine([1 1],[0 1 2 1]) - 0) < eps,'Distance on the line was not computed correctly');
assert(abs(distanceToNearestLine([1 0],[0 1 2 1]) - 1) < eps,'Distance away from the line was not computed correctly');
assert(abs(distanceToNearestLine([1 2],[0 1 2 1]) - 1) < eps,'Distance away from the line was not computed correctly');

assert(abs(distanceToNearestLine([1 1],[4 5 4 10]) - 5) < eps,'Distance away from the first endpoint was not computed correctly');

assert(abs(distanceToNearestLine([1 14],[4 5 4 10]) - 5) < eps,'Distance away from the second endpoint was not computed correctly');



