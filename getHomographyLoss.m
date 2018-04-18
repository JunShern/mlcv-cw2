function [ meanDistance ] = getHomographyLoss( pointsA, pointsA_hat )
% Calculates the accuracy of the homography matrix  as the
% average distance in pixels between the original points in 
% A and the ones projected from B (A_hat)
    distances = sqrt(sum((pointsA - pointsA_hat).^2, 2));
    meanDistance = mean(distances);
end