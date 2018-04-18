function [ meanDistance ] = getFundamentalLoss( points, epi_points, epi_vectors )
% Implement a method calculating the average distance of points in image B 
% to their epipolar lines of the corresponding points in image A. This
% average distance can be interpreted as fundamental matrix accuracy FA. 
    distance = 0;
    for i = 1:size(points, 1)
        % Calculate point to line distances
        % Given a point p, and a line defined by a + tn, 
        % distance = norm((a - p) -  ((a - p).n)n)
        a = epi_points(i,:);
        p = points(i,:);
        n = epi_vectors(i,:) / norm(epi_vectors(i,:)); % Making sure unit length
        distance = distance + norm((a - p) - ( (a - p) * n' ) .* n);
    end
    meanDistance = distance / size(points, 1);
end