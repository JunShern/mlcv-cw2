
% Use SURF feature detection to find matching points
gray_imgA = imgA; %rgb2gray(imgA);
gray_imgB = imgB; %rgb2gray(imgB);
featurePointsA = detectSURFFeatures(gray_imgA);
featurePointsB = detectSURFFeatures(gray_imgB);

[featuresA,validPtsA] = extractFeatures(gray_imgA, featurePointsA);
[featuresB,validPtsB] = extractFeatures(gray_imgB, featurePointsB); 
index_pairs = matchFeatures(featuresA, featuresB);
pointsA = validPtsA(index_pairs(:,1)).Location;
pointsB = validPtsB(index_pairs(:,2)).Location;

%% Visualize the matched points
figure(3);
subplot(1,3,1)        % add first plot in 2 x 2 grid
imshow(imgA);
hold all;
scatter(pointsA(:,1), pointsA(:,2),'o','filled', 'MarkerFaceColor','red')

subplot(1,3,2)        % add first plot in 2 x 2 grid
imshow(imgB);
hold all;
scatter(pointsB(:,1), pointsB(:,2),'o','filled', 'MarkerFaceColor','green')

subplot(1,3,3)    % add third plot to span positions 3 and 4
showMatchedFeatures(imgA, imgB, pointsA, pointsB);

%%
% Find the homography which maps image A to image B
tform = estimateGeometricTransform(pointsA, pointsB, 'similarity');

%%

figure(1);
subplot(1,3,1)
imshow(imgA);
title('input');

subplot(1,3,2)
imshow(imgB);
title('target');

subplot(1,3,3)
outputView = imref2d(size(imgB));
output_img = imwarp(imgA, tform, 'OutputView', outputView);
% output_img = t * gray_imgA;
imshow(output_img);
title('input transformed');
% figure; imshow(Ir); 
% title('Recovered image');

outputView = imref2d(size(imgB));
Ir = imwarp(imgA,tform,'OutputView',outputView);
figure; imshow(Ir); 
title('Recovered image');