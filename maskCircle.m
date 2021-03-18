function outImage = maskCircle(img, midX, midY, radius)

[X, Y] = size(img );
[cc rr] = meshgrid(1:X, 1:Y);
out = (rr - midY).^2 + (cc - midX).^2 <= radius.^2;

outImage = out';
