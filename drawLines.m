function drawLines( img, points, vectors )
% Implement a method calculating the average distance of points in image B 
% to their epipolar lines of the corresponding points in image A. This
% average distance can be interpreted as fundamental matrix accuracy FA. 
    figure;
    imshow(img);
    lines = parametricLinesToStandardLines(points, vectors);
    % Get the line endings at the image borders and draw them
    points = lineToBorderPoints(lines, size(img));
    line(points(:,[1,3])',points(:,[2,4])', 'color','g', 'LineWidth',1);
end