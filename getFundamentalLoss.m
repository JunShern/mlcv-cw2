function [ meanDistance ] = getFundamentalLoss( points, lines )
% Implement a method calculating the average distance of points in image B 
% to their epipolar lines of the corresponding points in image A. This
% average distance can be interpreted as fundamental matrix accuracy FA. 
    distance = 0;
    for i = 1:size(points, 1)
        % Calculate point to line distances
        % Given a point (x,y), and a line defined by ax + by + c = 0,
        % distance = norm(ax + by + c) / sqrt(a^2 + b^2)
        x = points(i,1);
        y = points(i,2);
        a = lines(i,1);
        b = lines(i,2);
        c = lines(i,3);
        numerator = norm(a*x + b*y + c);
        denominator = sqrt(a^2 + b^2);
        distance = distance + (numerator/denominator);
    end
    meanDistance = distance / size(points, 1);
end