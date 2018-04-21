%%%% Script for Question 2, part 1b) %%%%%%%%%

% Reading image - just need one
I1 = imread('Lab1.jpg');
I2 = imread('Lab6.jpg');    %% First rotated image, need HG photos

% Scaling down image by different factors
scale_res = 0.25;   % Resolution of iPhone photo is too much, need initial resizing
I1 = imresize(I1, scale_res);
I2 = imresize(I2, scale_res);

% Converting to grayscale
img1 = rgb2gray(I1);
img2 = rgb2gray(I2);

% Preparing images so can select the data manually
figure(1);
imshow(img1);
figure(2);
imshow(img2);

%% Manual Correspondences

%Select K interest points
K = 10;
for i = 1:K
    figure(1)
    [x1(i), y1(i)] = ginput(1);
    hold all;
    scatter(x1(i), y1(i),'o','filled')
    
    figure(2)
    [x2(i), y2(i)] = ginput(1);
    hold all;
    scatter(x2(i), y2(i),'o','filled')
end

matchedPts1 = [x1;y1];
matchedPts2 = [x2; y2];
save('fd_manual_Lab1_Lab2.mat', 'matchedPts1', 'matchedPts2');

%% Now apply Homography to both sets of coordinates

pointsA = matchedPts1';
pointsB = matchedPts2';
homographyMatManual = estimateHomography(pointsB, pointsA); % Projects B onto A

% Matlab projection function
A = transpose(homographyMatManual);  %Your matrix in here
A(1:2,3) = 0;
t = maketform('affine', A);
img1_hat = imtransform(img2,t);
figure
imshow(img2);
title('Input Image', 'FontSize', 24);
figure
imshow(img1);
title('Homography Target Image', 'FontSize', 24);
figure
imshow(img1_hat);
title('Transformed Image using Manual Correspondence', 'FontSize', 24);

%% Automatic Correspondences

% Performing harris detection for the images
harris1 = harrisDetection(img1, 3000);
harris2 = harrisDetection(img2, 3000);

% Take output interest point matrix and get the descriptors
descriptor1 = getDescriptors(img1, harris1);
descriptor2 = getDescriptors(img2, harris2);

% Nearest Neighbor matching of descriptors
matches = nearestNeighbor(descriptor1, descriptor2);

% Estimate a transformation based on the matches between A and B
% Based on matched patches, build two matrices of co-ordinates
nMatch = size(matches, 2);
coord1 = zeros(2, nMatch);
coord2 = zeros(2, nMatch);
for i=1:nMatch
    n = matches(1, i);
    m = matches(2, i);
    coord1(:, i) = harris1(:, n);
    coord2(:, i) = harris2(:, m);
end

%% Now apply Homography to both sets of coordinates

% Exclude outliers
[tform,pointsA,pointsB] = estimateGeometricTransform(coord1', coord2', 'similarity');
homographyMatAuto = estimateHomography(pointsB, pointsA); % Projects B onto A

% Matlab projection function
A = transpose(homographyMatAuto);  %Your matrix in here
A(1:2,3) = 0;
t = maketform('affine', A);
img1_hat = imtransform(img2,t);
figure
imshow(img1_hat);
title('Transformed Image using Automatic Correspondence', 'FontSize', 24);

