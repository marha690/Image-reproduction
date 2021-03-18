function [dataset, circleImage] = makeCircles(image, minRadius, maxRadius, colorFields)
%MAKECIRCLES Generate data for position and radius of circles

rgb = im2double(image);
lab = rgb2lab(rgb);
lab_uint8 = lab2uint8(lab);

% blur image
kernel_size = 4;
kernel = ones(kernel_size)/(kernel_size*kernel_size);
lab_filtered = imfilter(lab, kernel,'conv');
lab_uint8_blured = lab2uint8(lab_filtered);

% find color clusters
clusters = colorFields;
[L,C] = imsegkmeans(lab_uint8_blured,clusters);

%clean up clustered colors
L_blured = zeros(size(lab_uint8(:,:,1)));
L_moprh = zeros(size(lab_uint8(:,:,1)));
for i = 1:clusters   
    % mask one color
    mask = (L == i);
    
    % blur image
    kernel_size = 5;
    kernel = ones(kernel_size)/(kernel_size*kernel_size);
    blured = imfilter(mask, kernel,'conv');
    L_blured = L_blured + blured * i;

    % morphological operation to clean image
    disc_size = 2;
    se = strel('disk', disc_size);
    morphed = imopen(blured, se);
    L_moprh = L_moprh + morphed * i;
    
end

%remove no-data values
[~,L] = bwdist(L_moprh);
L_cleaned = L_moprh(L);


%%Circles
circleImage = zeros(size(L_cleaned));
[im_x, im_y, ~] = size(circleImage);
clear dataset;
dataset(1,:) = [im_x im_y 0];
f = waitbar(0,'Add circles into clusters:');
for i = 1:clusters    
    f = waitbar(i/clusters,f,append('Add circles into clusters: ', sprintf('%d', i), ' of ', sprintf('%d', clusters)));
    % select only one cluster
    L = (L_cleaned == i);
    
    % add border to L.
    border = 1;
    L(1:border,:,:) = 0;
    L(end-border+1:end,:,:) = 0;
    L(:,1:border,:) = 0;
    L(:,end-border+1:end,:) = 0;
    
    % make circles
    distance_ref = (L ~= 1);
    while true
        distance_map = bwdist(distance_ref,'euclidean');    
        max_distance = max(max(distance_map));
        if(max_distance > maxRadius)
            max_distance = maxRadius;
        end
        
        [x, y] = getMax(distance_map);
        circle_mask = maskCircle(distance_map, x, y, max_distance);
        distance_ref = distance_ref + (circle_mask == 1);
        dataset(end+1,:) = [x y max_distance];
        
        if (max_distance <= minRadius) % end of loop
           break;
        end
    end
    
        % create colors only where circles exist
    distance_ref = (distance_ref == 1);
    clusterMask = L .*distance_ref;
    color_image(:,:,1) = clusterMask;
    color_image(:,:,2) = clusterMask;
    color_image(:,:,3) = clusterMask;

    circleImage = circleImage + color_image;
end
f = waitbar(1, f, 'Add additional circles between clusters ...');
% padding with more circles in edges of clusters
distance_ref = (circleImage(:,:,1) ~= 0);
border = 1;
distance_ref(1:border,:,:) = 1;
distance_ref(end-border+1:end,:,:) = 1;
distance_ref(:,1:border,:) = 1;
distance_ref(:,end-border+1:end,:) = 1;

while true
    distance_map = bwdist(distance_ref,'euclidean');    
    max_distance = max(max(distance_map));
    

    if(max_distance > maxRadius)
        max_distance = maxRadius;
    end
   
    [x, y] = getMax(distance_map);
    
    circle_mask = maskCircle(distance_map, x, y, max_distance);
    distance_ref = distance_ref + (circle_mask == 1);
    dataset(end+1,:) = [x y max_distance];
    
    % end of loop
    if (max_distance <= minRadius)
       break;
    end
end
delete(f);
circleImage = distance_ref;
end

