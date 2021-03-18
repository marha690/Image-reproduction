% Variables
% need cielab code to work: http://scarlet.stanford.edu/~brian/scielab/
Ref_Image = imread("ekorre.jpg");
FinalImage = imread("Ekorre.png");
CIED65 =  [95.05, 100, 108.9];
ppi = 81;
dist2screen1 = 15; %inch
dist2screen2 = 50; %inch
sampPerDeg1 = round(ppi / ((180/pi)*atan(1/dist2screen1)));
sampPerDeg2 = round(ppi / ((180/pi)*atan(1/dist2screen2)));

% Evaluation
xyz_Reference = rgb2xyz(im2double(Ref_Image));
xyz_Result = rgb2xyz(FinalImage);
scielab1 = scielab(sampPerDeg1, xyz_Reference, xyz_Result, CIED65, 'xyz');
scielab2 = scielab(sampPerDeg2, xyz_Reference, xyz_Result, CIED65, 'xyz');
mean(mean(scielab1))
mean(mean(scielab2))
[a,~] = ssim(finalImage, im2double(Image));
disp("SSIM: " + a);