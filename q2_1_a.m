%%%% Script for Question 2, part 1a) %%%%%%%%%

% Condition to show image or not and use MATLAB functions
showImg = true;
matlab_funcs = false;

% Reading image - just need one
I1 = imread('Lab1.jpg');

% Scaling down image by different factors
scale_res = 0.25;   % Resolution of iPhone photo is too much, need initial resizing
I1 = imresize(I1, scale_res);
I2 = imresize(I1, 0.5);     % Scale by factor of 2
I3 = imresize(I1, 0.33);    % Scale by factor of 3

% Converting to grayscale
img1 = rgb2gray(I1);
img2 = rgb2gray(I2);
img3 = rgb2gray(I3);
%%
% Performing harris detection for the images
harris1 = harrisDetection(img1, 3000);
harris2 = harrisDetection(img2, 3000);
harris3 = harrisDetection(img3, 3000);

% Overlay interest points on image to evaluate
if showImg
    figure;
    imshow(img1);
    hold on;
    scatter(harris1(1, :), harris1(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
end

% Overlay interest points on image to evaluate
if showImg
    figure;
    imshow(img2);
    hold on;
    scatter(harris2(1, :), harris2(2, :), 50, 'x', 'MarkerEdgeColor', 'green');
    hold off;
end

% Take output interest point matrix and get the descriptors
descriptor1 = getDescriptors(img1, harris1);
descriptor2 = getDescriptors(img2, harris2);
descriptor3 = getDescriptors(img3, harris3);

% In case want to use MATLAB functions to check performance
if matlab_funcs
    
[patch1,validPoints1] = extractFeatures(img1,harris1', 'Method', 'Block', 'BlockSize', 31);
descriptor1 = hist(patch1',255)';

[patch2,validPoints2] = extractFeatures(img2,harris2', 'Method', 'Block', 'BlockSize', 31);
descriptors2 = hist(patch2',255)';

end

% Nearest Neighbor matching of descriptors
matches = nearestNeighbor(descriptor1, descriptor2);
% matches = nearestNeighbor(descriptor1, descriptor3);

% Estimate a transformation based on the matches between A and B
% Based on matched patches, build two matrices of co-ordinates
nMatch = size(matches, 2);
coord1 = zeros(2, nMatch);
coord2 = zeros(2, nMatch);
% coord3 = zeros(2, nMatch);

for i=1:nMatch
    n = matches(1, i);
    m = matches(2, i);
    coord1(:, i) = harris1(:, n);
    coord2(:, i) = harris2(:, m);
%     coord3(:, i) = harris3(:, m);
end

% Display the matched points on the photos, superimposed. Method is
% MATLAB's
if showImg
    p1 = cornerPoints(coord1');
    p2 = cornerPoints(coord2');
%     p3 = cornerPoints(coord3');
    % MATLAB function for visualization
    %figure;
    %showMatchedFeatures(img1, img2, p1, p2);
    figure; ax = axes;
    showMatchedFeatures(img1,img2,p1,p2,'montage','Parent',ax);
%     showMatchedFeatures(img1,img3,p1,p3,'montage','Parent',ax);
    title(ax, 'Candidate point matches');
    legend(ax, 'Matched points 1','Matched points 2');
%     legend(ax, 'Matched points 1','Matched points 3');
end

%%

% Find interest points in one image by using method from Q1. Reduce the size of the
% image by a factor of 2 and run the detector again, then repeat for factor of 3. Compare
% the interest points obtained in these three cases using HA error.


% Exclude outliers
[tform,pointsA,pointsB] = estimateGeometricTransform(coord1', coord2', 'similarity');
% Plot interest points
figure;
scatter(pointsA(:,1), pointsA(:,2), 'MarkerEdgeColor', 'red');
hold on;
scatter(pointsB(:,1)*2, pointsB(:,2)*2, 'MarkerEdgeColor', 'blue');
hold on;
for i = 1:length(pointsA)
    plot([pointsA(i,1) pointsB(i,1)*2], [pointsA(i,2) pointsB(i,2)*2]);
    hold on;
end
title('Interest Points for original and 1/2-scaled');
% Get accuracy
homography_accuracy_2_to_1 = getHomographyLoss(pointsA, pointsB*2);

%%
%%%% Script for Question 2, part 1a) %%%%%%%%%

% Condition to show image or not and use MATLAB functions
showImg = true;
matlab_funcs = false;

% Reading image - just need one
I1 = imread('Lab1.jpg');

% Scaling down image by different factors
scale_res = 0.25;   % Resolution of iPhone photo is too much, need initial resizing
I1 = imresize(I1, scale_res);
I2 = imresize(I1, 0.5);     % Scale by factor of 2
I3 = imresize(I1, 0.33);    % Scale by factor of 3  

% Converting to grayscale
img1 = rgb2gray(I1);
img2 = rgb2gray(I2);
img3 = rgb2gray(I3);

% Performing harris detection for the images
harris1 = harrisDetection(img1, 3000);
harris2 = harrisDetection(img2, 3000);
harris3 = harrisDetection(img3, 3000);

% Overlay interest points on image to evaluate
if showImg
    figure;
    imshow(img1);
    hold on;
    scatter(harris1(1, :), harris1(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
end

% Overlay interest points on image to evaluate
if showImg
    figure;
    imshow(img2);
    hold on;
    scatter(harris2(1, :), harris2(2, :), 50, 'x', 'MarkerEdgeColor', 'green');
    hold off;
end

% Take output interest point matrix and get the descriptors
descriptor1 = getDescriptors(img1, harris1);
descriptor2 = getDescriptors(img2, harris2);
descriptor3 = getDescriptors(img3, harris3);

% In case want to use MATLAB functions to check performance
if matlab_funcs
    
[patch1,validPoints1] = extractFeatures(img1,harris1', 'Method', 'Block', 'BlockSize', 31);
descriptor1 = hist(patch1',255)';

[patch2,validPoints2] = extractFeatures(img2,harris2', 'Method', 'Block', 'BlockSize', 31);
descriptors2 = hist(patch2',255)';

end

% Nearest Neighbor matching of descriptors
% matches = nearestNeighbor(descriptor1, descriptor2);
matches = nearestNeighbor(descriptor1, descriptor3);

% Estimate a transformation based on the matches between A and B
% Based on matched patches, build two matrices of co-ordinates
nMatch = size(matches, 2);
coord1 = zeros(2, nMatch);
% coord2 = zeros(2, nMatch);
coord3 = zeros(2, nMatch);

for i=1:nMatch
    n = matches(1, i);
    m = matches(2, i);
    coord1(:, i) = harris1(:, n);
%     coord2(:, i) = harris2(:, m);
    coord3(:, i) = harris3(:, m);
end

% Display the matched points on the photos, superimposed. Method is
% MATLAB's
if showImg
    p1 = cornerPoints(coord1');
%     p2 = cornerPoints(coord2');
    p3 = cornerPoints(coord3');
    % MATLAB function for visualization
    %figure;
    %showMatchedFeatures(img1, img2, p1, p2);
    figure; ax = axes;
%     showMatchedFeatures(img1,img2,p1,p2,'montage','Parent',ax);
    showMatchedFeatures(img1,img3,p1,p3,'montage','Parent',ax);
    title(ax, 'Candidate point matches');
%     legend(ax, 'Matched points 1','Matched points 2');
    legend(ax, 'Matched points 1','Matched points 3');
end

%%
% Exclude outliers
[tform,pointsA,pointsB] = estimateGeometricTransform(coord1', coord3', 'similarity');
% Plot interest points
figure;
scatter(pointsA(:,1), pointsA(:,2), 'MarkerEdgeColor', 'red');
hold on;
scatter(pointsB(:,1)*3, pointsB(:,2)*3, 'MarkerEdgeColor', 'blue');
hold on;
for i = 1:length(pointsA)
    plot([pointsA(i,1) pointsB(i,1)*3], [pointsA(i,2) pointsB(i,2)*3]);
    hold on;
end
title('Interest Points for original and 1/3-scaled');
% Get accuracy
homography_accuracy_3_to_1 = getHomographyLoss(pointsA, pointsB*3);

