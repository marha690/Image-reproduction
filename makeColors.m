function [dataColors, image] = makeColors(data, inImage, numColors)
f = waitbar(0,'Preparing to colors circles... ');

rgb = im2double(inImage);
lab = rgb2lab(rgb);
lab_uint8 = lab2uint8(lab);

%Color clusters
num_colors = numColors;
[L_col,C_col] = imsegkmeans(lab_uint8,num_colors);
C_c = lab2double(C_col);
C_c_rgb = lab2rgb(C_c);

colors_rgb = label2rgb(L_col,im2double(C_c_rgb));
colors_lab = rgb2lab(colors_rgb);
image = zeros(data(1, 1),data(1, 2), 3);
dataColors(1,:) = [0, 0, 0];
len = size(data);
for i = 2:len(1) 
   unique = data(i,:);
   f = waitbar(i/len(1),f,append('Calculate colors for circles: ', sprintf('%d', i), ' of ', sprintf('%d', len(1))));
   
    circle_mask = maskCircle(colors_lab, unique(1), unique(2), unique(3));
    
    %find mean color in circle
    l = colors_lab(:,:,1);
    a = colors_lab(:,:,2);
    b = colors_lab(:,:,3);
    lab_color = [median(l(circle_mask)), median(a(circle_mask)), median(b(circle_mask))];
    rgb_color = lab2rgb(lab_color);
     
   dataColors(end+1,:) = lab_color;
   % CIRCLE IMAGE
   image = insertShape(image,'FilledCircle',[unique(2) unique(1) unique(3)],'color', rgb_color, 'Opacity', 1); 
end
delete(f);
end

