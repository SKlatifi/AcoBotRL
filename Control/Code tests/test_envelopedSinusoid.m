eps = 1e-3;

t = linspace(0,2,1e6);
s = envelopedSinusoid(t,1000);
assert(abs(s(1)) < eps,'The beginning of the signal is not zero');
assert(abs(s(end)) < eps,'The end of the signal is not zero');
assert(abs(max(s) - 1) < eps,'The maximum is not 1');
assert(abs(min(s) + 1) < eps,'The minimum is not -1');

t = linspace(3,7,1e6);
s = envelopedSinusoid(t,1000);
assert(abs(s(1)) < eps,'The beginning of the signal is not zero');
assert(abs(s(end)) < eps,'The end of the signal is not zero');
assert(abs(max(s) - 1) < eps,'The maximum is not 1');
assert(abs(min(s) + 1) < eps,'The minimum is not -1');

% superposed signal
t = linspace(3,7,1e6);
s = 0.5 * envelopedSinusoid(t,1000) + 0.5 * envelopedSinusoid(t,6843);
plot(t,s);
assert(abs(s(1)) < eps,'The beginning of the signal is not zero');
assert(abs(s(end)) < eps,'The end of the signal is not zero');
assert(abs(max(s) - 1) < eps,'The maximum is not 1');
assert(abs(min(s) + 1) < eps,'The minimum is not -1');