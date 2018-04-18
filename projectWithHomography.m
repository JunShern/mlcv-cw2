function [ pointsA_hat ] = projectWithHomography( pointsB, homographyBtoA )
% Projects point coordinates from image B to A, 
% given a homography between the two images.
    % Convert points to homogeneous coordinates
    pointsB = horzcat(pointsB, ones(size(pointsB, 1),1));
    % Apply x^ = homography * x
    pointsA_hat = homographyBtoA * pointsB';
    % Convert back to cartesian coordinates
    pointsA_hat = pointsA_hat';
    pointsA_hat = pointsA_hat(:,1:2) ./ pointsA_hat(:,3);
end
