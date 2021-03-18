%% User input
MinRadius = 3;
MaxRadius = 60;
Colors = 24;
ColorFields = 6;
Image = imread("ekorre.jpg");
OutName = "Ekorre.png";
A = imread("plate.jpg"); % Image to use inside circles.
A_X = 630 / 2 + 6;  % x position of circle in image
A_Y = 630 / 2 + 6; % y position of circle in image
A_Radius = 246; % radius of circle in image

% Processing cirlces and colors.
[circleData, circleImage] = makeCircles(Image, MinRadius, MaxRadius, ColorFields);
[colorData, coloredCirclesImage] = makeColors(circleData, Image, Colors);

% Insert sub-images
%image to use, with x,y and radius known
A = im2double(imread("plate.jpg"));
A_X = 630 / 2 + 6; %up/down
A_Y = 630 / 2 + 6; %left/right
A_Radius = 246;

finalImage = replicateImage(circleData, colorData, A, A_X, A_Y, A_Radius);

% Save result
imwrite(finalImage,OutName);

%%  Show images
figure; imshow(Image);
figure; imshow(circleImage);
figure; imshow(coloredCirclesImage);
figure; imshow(finalImage);

