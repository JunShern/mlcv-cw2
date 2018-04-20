% srcFiles = dir('tsukuba/*.ppm');
% for i = 1:length(srcFiles)
%   directory = strcat('tsukuba/', srcFiles(i).name);
%   images{i} = imread(directory);
% end

% Condition to show image or not
showImg = true;

% Reading images from the boat files
% img1 = imread('img1.pgm');
% img2 = imread('img2.pgm');

% Reading own images for testing
I1 = imread('Lab1.jpg');
I2 = imread('Lab2.jpg');

% Scaling down image by different factors
scale = 0.25;
I1 = imresize(I1, scale);
I2 = imresize(I2, scale);

% Converting to grayscale
img1 = rgb2gray(I1);
img2 = rgb2gray(I2);

% Performing harris detection for the two images
harris1 = harrisDetection(img1, 4000);
harris2 = harrisDetection(img2, 4000);

% Overlay interest points on image to evaluate
if showImg
    figure(1);
    imshow(img1);
    hold on;
    scatter(harris1(1, :), harris1(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
end

% Overlay interest points on image to evaluate
if showImg
    figure(2);
    imshow(img2);
    hold on;
    scatter(harris2(1, :), harris2(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
end

% Take output interest point matrix and get the descriptors
descriptor1 = getDescriptors(img1, harris1);
descriptor2 = getDescriptors(img2, harris2);

%[patch1,validPoints1] = extractFeatures(img1,harris1', 'Method', 'Block', 'BlockSize', 31);
%descriptor1 = hist(patch1',255)';

%[patch2,validPoints2] = extractFeatures(img2,harris2', 'Method', 'Block', 'BlockSize', 31);
%descriptors2 = hist(patch2',255)';

maximumNumMatches = length(nearestNeighbor(descriptor1, descriptor2));
% homography_accuracy = zeros(maximumNumMatches, 1);
for numMatches = 5:maximumNumMatches
    % Nearest Neighbor matching of descriptors
    matches = bestNearestNeighbors(descriptor1, descriptor2, numMatches);

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

    % Display the matched points on the photos, superimposed. Method is
    % MATLAB's
    if showImg
        p1 = cornerPoints(coord1');
        p2 = cornerPoints(coord2');
        % MATLAB function for visualization
        %figure;
        %showMatchedFeatures(img1, img2, p1, p2);
        figure(3); ax = axes;
        showMatchedFeatures(img1,img2,p1,p2,'montage','Parent',ax);
        title([numMatches ' candidate point matches']);
        legend(ax, 'Matched points 1','Matched points 2');
    end
    
    w = waitforbuttonpress;
end