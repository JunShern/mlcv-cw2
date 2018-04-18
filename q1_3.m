% Prepare some data to test functions on
srcFiles = dir('boat/*.pgm');
for i = 1:length(srcFiles)
  directory = strcat('boat/', srcFiles(i).name);
  images{i} = imread(directory);
end
imgA = images{1};
imgB = images{5};

% figure(1);
% imshow(imgA);
% figure(2);
% imshow(imgB);
% imshow(imgA);
% title('Base image');
% figure; imshow(imgB);
% title('Transformed image');

% Detect features
ptsOriginal = detectSURFFeatures(imgA);
ptsDistorted = detectSURFFeatures(imgB);
[featuresOriginal,validPtsOriginal] = extractFeatures(imgA,ptsOriginal);
[featuresDistorted,validPtsDistorted] = extractFeatures(imgB,ptsDistorted);

% Find correspondences
index_pairs = matchFeatures(featuresOriginal,featuresDistorted);
matchedPtsOriginal  = validPtsOriginal(index_pairs(:,1));
matchedPtsDistorted = validPtsDistorted(index_pairs(:,2));
% figure; 
% showMatchedFeatures(original,distorted,...
%     matchedPtsOriginal,matchedPtsDistorted);
% title('Matched SURF points,including outliers');

% Ready!
pointsA = matchedPtsOriginal.Location;
pointsB = matchedPtsDistorted.Location;

%%
% a) Implement a method for estimating a homography matrix given a set of corresponding
% point coordinates.

homographyMat = estimateHomography(pointsA, pointsB);

%%
% b) Similarly to Q1.3.a, implement a method for estimating a fundamental matrix.

fundamentalMat = estimateFundamental(pointsA, pointsB);

%%
% c) Implement a method for projecting point coordinates from image B to A given
% Homography between the two images. Implement a method for calculating average
% distance in pixels between the original points in A and the ones projected from B. This
% average distance can be interpreted as homography accuracy HA.

pointsA_hat = projectWithHomography(pointsB, homographyMat);
homography_accuracy = getHomographyLoss(pointsA, pointsA_hat);

%%
% d) Implement a method for calculating epipolar line given point coordinates and a
% Fundamental matrix between two images. Display that line on an image in Matlab.
% Implement a method calculating the average distance of points in image B to their epipolar
% lines of the corresponding points in image A. This average distance can be interpreted as
% fundamental matrix accuracy FA. 

[epi_points, epi_vectors] = getEpipolarLines(pointsB, fundamentalMat);
drawLines(imgA, epi_points, epi_vectors);
fundamental_accuracy = getFundamentalLoss(pointsB, epi_points, epi_vectors);


