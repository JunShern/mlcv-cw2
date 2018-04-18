function [ lines ] = parametricLinesToStandardLines( points, vectors )
% Given M lines in the form for [x,y] = [p1,p2] + t[v1,v2]
% return M rows of (a, b, c) corresponding to the line ax + by + c = 0
    lines = zeros(size(points,1), 3);
    for i = 1:size(points, 1)
        p = points(i,:);
        v = vectors(i,:);
        a = v(2)/v(1);
        b = -1;
        c = p(2) - p(1)*(v(2)/v(1));
        lines(i,:) = [a,b,c];
    end
end