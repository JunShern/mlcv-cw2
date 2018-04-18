function [ homographyMat ] = estimateHomography( pointsA, pointsB )
% Estimates a homography matrix given a set of corresponding
% point coordinates.

    A = zeros(2*size(pointsA, 1), 9);

    % Indexing
    n = 0;
    for i=1:size(pointsA, 1)
        % Get points from patches
        xa = pointsA(i, 1);
        ya = pointsA(i, 2);
        xb = pointsB(i, 1);
        yb = pointsB(i, 2);

        n = n + 1;
        A(n, :) = [xa ya 1 0 0 0 -xa*xb -ya*xb -xb];
        n = n + 1;
        A(n, :) = [0 0 0 xa ya 1 -xa*yb -ya*yb -yb];

    end

    ATA = A'*A;
    % Perform SVD decomposition
    [~, ~, V] = svd(ATA);

    % Select last column, normalise to last value.
    homographyMat = reshape(V(:, 9) ./ V(9, 9), 3, 3)';
end