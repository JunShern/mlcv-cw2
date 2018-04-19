% Prepare some data to test functions on
srcFiles = dir('boat/*.pgm');
for i = 1:length(srcFiles)
  directory = strcat('boat/', srcFiles(i).name);
  images{i} = imread(directory);
end
imgA = images{1};
imgB = images{5};

figure;
imshow(imgA);
title('Image A');
figure; 
imshow(imgB);
title('Image B');

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

% Exclude outliers
[tform,inlierPtsDistorted,inlierPtsOriginal] = ...
    estimateGeometricTransform(matchedPtsDistorted, matchedPtsOriginal,...
    'similarity');

% Ready!
pointsA = inlierPtsOriginal.Location;
pointsB = inlierPtsDistorted.Location;

%%
% a) Implement a method for estimating a homography matrix given a set of corresponding
% point coordinates.

homographyMat = estimateHomography(pointsB, pointsA); % Projects B onto A

A = transpose(homographyMat);  %Your matrix in here
A(1:2,3) = 0;
t = maketform('affine', A);
imgA_hat = imtransform(imgB,t);
figure;
imshow(imgA_hat);

%%
% b) Similarly to Q1.3.a, implement a method for estimating a fundamental matrix.

fundamentalMat = estimateFundamental(pointsB, pointsA);

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

fundamentalMat = estimateFundamental(pointsA, pointsB);
[lines] = getEpipolarLines(pointsA, fundamentalMat);
drawLines(imgA, lines);
fundamental_accuracy = getFundamentalLoss(pointsB, lines');


