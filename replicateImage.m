function repImage = replicateImage(circleData,colorData, subImage, A_X, A_Y, A_Radius)
subImage = im2double(subImage);
A_mask = maskCircle(rgb2gray(subImage), A_X, A_Y, A_Radius);
A_masked = subImage .* A_mask;
% imshow(A_masked); % the image which will be used inside the large image.
A_masked = imcrop(A_masked,[(A_Y-A_Radius) (A_X- A_Radius) A_Radius*2 A_Radius*2]);
% imshow(A_masked); % the image which will be used inside the large image.
A_mask = imcrop(A_mask,[(A_Y-A_Radius) (A_X- A_Radius) A_Radius*2 A_Radius*2]);

% Make image
circleImage = zeros(circleData(1, 1),circleData(1, 2), 3);
repImage = zeros(circleData(1, 1),circleData(1, 2), 3);

f = waitbar(0,'Processing data');
len = size(circleData);
for i = 2:len(1) 
   f = waitbar(i/len(1),f,append('Make circles into images: ', sprintf('%d', i), ' of ', sprintf('%d', len(1))));
   uCircle = circleData(i,:);
   uColor = colorData(i,:);
   lab_color = [uColor(1) uColor(2) uColor(3)];
   lab_color = im2double(lab_color);
   
   % COMPOSED IMAGE
    A_scale = uCircle(3) / A_Radius;
    A_scaled = imresize(A_masked, A_scale );
    mask_scaled = imresize(A_mask, A_scale );
    
    colored_A = colorAdjust(A_scaled, lab_color);
    colored_A = lab2rgb(colored_A);
    colored_A = colored_A .* mask_scaled;
    
    [xx,yy,t] = size(A_scaled);
    eye_xx = uCircle(1) - floor(xx/2);
    eye_yy = uCircle(2) - floor(yy/2);
    test = repImage(eye_xx: eye_xx + xx - 1, eye_yy: eye_yy + yy - 1,:);
    test(colored_A ~= 0) = colored_A(colored_A ~= 0);
    repImage(eye_xx: eye_xx + xx - 1, eye_yy: eye_yy + yy - 1,:) = test;
    
end
delete(f)
end

