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
K = 5;
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

%% Automatic Correspondences

% Performing harris detection for the images
harris1 = harrisDetection(img1, 4000);
harris2 = harrisDetection(img2, 4000);

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

%% Now apply Homography to both sets of coordinates

