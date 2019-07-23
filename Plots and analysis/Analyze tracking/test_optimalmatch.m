p1 = [100 100;200 100;300 110;400 120];
p2 = [100 100;300 100;400 100];
m = optimal_match(p1,p2);
assert(all(size(m) == [3 2]),'The number of matches was not correct');
assert(all(all(m == [1 1;3 2;4 3])),'Matches were not correct');
m2 = optimal_match(p2,p1);
assert(all(size(m2) == [3 2]),'The number of matches was not correct');
assert(all(all(m2 == [1 1;2 3;3 4])),'Matches were not correct');

p1 = [100 110;200 100;300 100;400 120];
p2 = [100 100;300 100;400 100];
m = optimal_match(p1,p2);
assert(all(size(m) == [3 2]),'The number of matches was not correct');
assert(all(all(m == [3 2;1 1;4 3])),'Matches were not correct');
m2 = optimal_match(p2,p1);
assert(all(size(m2) == [3 2]),'The number of matches was not correct');
assert(all(all(m2 == [2 3;1 1;3 4])),'Matches were not correct');
