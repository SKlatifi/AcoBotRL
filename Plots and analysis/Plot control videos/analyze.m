function l = analyze(filename,siz,pixels)

data = load(filename);

n = size(data,1);
m = 3;
hold on;
for i = 1:m
    x = data(:,i);
    y = data(:,i+3);
    l = plot(x * siz(1) / pixels(1),(pixels(2) - y) * siz(2) / pixels(2),'b-','LineWidth',1);
end
hold off;