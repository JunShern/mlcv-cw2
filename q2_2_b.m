%%
% Calculate the epipoles for images A and B. Show epipolar lines and epipoles on the
% images if possible. 

[lines] = getEpipolarLines(pointsB, fundamentalMat);
drawLines(img1, lines);

%%
% Calculate and present disparity map between images A and B.
% I1 = imread('scene1.row3.col1.ppm');
% I2 = imread('scene1.row3.col2.ppm');
I1 = imread('face1.jpg');
I2 = imread('face2.jpg');    %% First moved image, FD photos
% Scaling down image by different factors
scale_res = 0.25;   % Resolution of iPhone photo is too much, need initial resizing
I1 = imresize(I1, scale_res);
I2 = imresize(I2, scale_res);

% Converting to grayscale
img1 = rgb2gray(I1);
img2 = rgb2gray(I2);

figure();
subplot(1,3,1)
imshow(I1);
title('Image 1');

subplot(1,3,2)
imshow(I2);
title('Image 2');

% Calculate disparity map
disparityRange = [-6 10];
disparityMap = disparity(rgb2gray(I1),rgb2gray(I2),'BlockSize',...
    15,'DisparityRange',disparityRange);

subplot(1,3,3)
imshow(disparityMap,disparityRange);
title('Disparity Map');
colormap(gca,jet) 
colorbar

%%
% Calculate and display depth map.

focalLength = 0.029; % Of camera
dist = 0.20; % Between camera 1 and camera 2
depthMap = focalLength * dist./disparityMap;
depthMap(find(depthMap(:) > 10^4)) = 0;
depthMap(find(depthMap(:) < -10^4)) = 0;

figure
subplot(1,3,1)
surf(depthMap, 'edgecolor', 'none');
% axis([0 inf 0 inf -0.008 0.004])
title('focalLength = 29mm');
% colormap(gca,jet) 
% colorbar

% Change the focal length by 2mm, repeat Q2.2.c and compare. 

focalLength = 0.029 + 0.002; % Of camera
dist = 0.20; % Between camera 1 and camera 2
depthMapPlus2mm = focalLength * dist./disparityMap;
depthMapPlus2mm(find(depthMapPlus2mm(:) > 10^4)) = 0;
depthMapPlus2mm(find(depthMapPlus2mm(:) < -10^4)) = 0;

subplot(1,3,2)
surf(depthMapPlus2mm, 'edgecolor', 'none');
axis([0 inf 0 inf -0.008 0.004])
title('focalLength = 31mm');

focalLength = 0.029 - 0.002; % Of camera
dist = 0.20; % Between camera 1 and camera 2
depthMapMinus2mm = focalLength * dist./disparityMap;
depthMapMinus2mm(find(depthMapMinus2mm(:) > 10^4)) = 0;
depthMapMinus2mm(find(depthMapMinus2mm(:) < -10^4)) = 0;

subplot(1,3,3)
surf(depthMapMinus2mm, 'edgecolor', 'none');
axis([0 inf 0 inf -0.008 0.004])
title('focalLength = 27mm');

%%
% Add small random noise (e.g. Gaussian with max 2 pixel) 
% to the disparity map, repeat Q2.2.c and compare.
noisemax = 1;
noise = randn(size(disparityMap)) * (noisemax/3);
noise(noise > noisemax) = noisemax;
noise(noise < -noisemax) = -noisemax;
disparityMapNoisy = disparityMap + noise; %imnoise(disparityMap, 'gaussian', 0, 0.002); % Mean = 0, Var = 2

figure
subplot(1,2,1)
imshow(disparityMap, disparityRange);
title('Disparity Map');
colormap(gca,jet) 
colorbar

subplot(1,2,2)
imshow(disparityMapNoisy, disparityRange);
title('Disparity Map with Added Noise');
colormap(gca,jet) 
colorbar

%%
% Calculate and display depth map.

focalLength = 0.029; % Of camera
dist = 0.20; % Between camera 1 and camera 2
depthMapNoisy = focalLength * dist./disparityMapNoisy;
depthMapNoisy(find(depthMapNoisy(:) > 10^4)) = 0;
depthMapNoisy(find(depthMapNoisy(:) < -10^4)) = 0;

figure

subplot(1,2,1)
surf(depthMap, 'edgecolor', 'none');
% axis([0 inf 0 inf -0.008 0.004])
title('focalLength = 29mm');

subplot(1,2,2)
surf(depthMapNoisy, 'edgecolor', 'none');
% axis([0 inf 0 inf -0.008 0.004])
title('focalLength = 29mm');
