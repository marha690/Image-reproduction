function [x,y] = getMaxPixel(image)

maxValue = max(max(image));
[x,y] = find(image==maxValue);
if (length(x) ~= 1)
    x = x(1);
end
if (length(y) ~= 1)
    y = y(1);
end