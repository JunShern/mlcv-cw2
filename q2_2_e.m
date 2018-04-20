% Present stereo rectified pair of your images.
% (Requires fundamental matrix and two sets of points, from q2_2_a.m)

[t1, t2] = estimateUncalibratedRectification(fundamentalMat,...
    pointsA, pointsB, size(img2));

[I1Rect,I2Rect] = rectifyStereoImages(img1, img2, t1, t2);

figure;
imshow(stereoAnaglyph(I1Rect,I2Rect));