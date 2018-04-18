function [ fundamentalMat ] = estimateFundamental( pointsA, pointsB )
% Estimates a fundamental matrix given a set of corresponding
% point coordinates. 

    A = zeros(size(pointsA, 1), 9);
    n = 0;

    for i=1:size(pointsA, 1)
        % Get points from patches
        xa = pointsA(i, 1);
        ya = pointsA(i, 2);
        xb = pointsB(i, 1);
        yb = pointsB(i, 2);

        n = n + 1;
        % Derived from x'Fx = 0 formula
        A(n, :) = [xa * xb, xb * ya, xb, ...
                   xa * yb, ya * yb, yb, ...
                   xa, ya, 1];
    end
    
    ATA = A' * A;
    % Perform SVD decomposition
    [~, ~, V] = svd(ATA);

    % Ideal f is : v(1, 9) ... v(9, 9), normalised
    f = V(:, 9);
    f = f/f(9);

    % Change vector into matrix.
    fundamentalMat = reshape(f, 3, 3)';
end