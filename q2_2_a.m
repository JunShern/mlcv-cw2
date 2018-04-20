%%%% Script for Question 2, part 2a) %%%%%%%%%

% I1 = imread('scene1.row3.col1.ppm');
% I2 = imread('scene1.row3.col2.ppm');

% Reading image - just need one
I1 = imread('face1.jpg');
I2 = imread('face2.jpg');    %% First moved image, FD photos
% Scaling down image by different factors
scale_res = 0.25;   % Resolution of iPhone photo is too much, need initial resizing
I1 = imresize(I1, scale_res);
I2 = imresize(I2, scale_res);

% Converting to grayscale
img1 = rgb2gray(I1);
img2 = rgb2gray(I2);
% img1 = I1;
% img2 = I2;

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
% save('fd_manual.mat', 'matchedPts1', 'matchedPts2');

%% Automatic Correspondences

% Performing harris detection for the images
harris1 = harrisDetection(img1, 2000); %3000);
harris2 = harrisDetection(img2, 2000); %3000);

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

%%

% Remove outliers
pointsA = coord1';
pointsB = coord2';
[~,inliers] = estimateFundamentalMatrix(pointsA,pointsB,'NumTrials',4000);
pointsA = pointsA(inliers,:);
pointsB = pointsB(inliers,:);

% Estimate fundamental matrix using list of correspondences from Q1.1 or Q1.2.a.
% Calculate and discuss the FA accuracy.
fundamentalMat = estimateFundamental(pointsB, pointsA);
[lines] = getEpipolarLines(pointsB, fundamentalMat);
fundamental_accuracy = getFundamentalLoss(pointsA, lines');

%% Matlab implementation

pointsA = coord1';
pointsB = coord2';

figure;
imshow(img1); 
% title('Inliers and Epipolar Lines in First Image'); hold on;
[fLMedS,inliers] = estimateFundamentalMatrix(pointsA,pointsB,'NumTrials',4000);
epiLines = epipolarLine(fLMedS',pointsB(inliers,:));
points = lineToBorderPoints(epiLines,size(I1));
line(points(:,[1,3])',points(:,[2,4])');

