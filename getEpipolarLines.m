function [ lines ] = getEpipolarLines( points, fundamentalMat )
% Calculates epipolar lines given point coordinates and a
% fundamental matrix between two images. The line is returned
% as a list of points and a unit vector in the line direction
    
    % Convert points to homogeneous coordinates
    homogeneous_points = horzcat(points, ones(size(points, 1),1));
    % For any point x in the first image, the corresponding epipolar
    % line is l_hat = Fx. Similarly, l = F'x_hat represents the 
    % epipolar line corresponding to x in the second image.
    lines = fundamentalMat * homogeneous_points';
end