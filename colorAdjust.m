function newImage = colorAdjust(rgbImage,lab_color)

lab_im = rgb2lab(rgbImage);

mean_L = mean(mean(lab_im(:,:,1)));
mean_a = mean(mean(lab_im(:,:,2)));
mean_b = mean(mean(lab_im(:,:,3)));

l_diff = mean_L - lab_color(1);
if(l_diff < -10)
     l_diff = -10;
end
a_diff = mean_a - lab_color(2);
b_diff = mean_b - lab_color(3);

lab_im(:,:,1) = lab_im(:,:,1) - l_diff;
lab_im(:,:,2) = lab_im(:,:,2) - a_diff;
lab_im(:,:,3) = lab_im(:,:,3) - b_diff;

newImage = lab_im;
end

