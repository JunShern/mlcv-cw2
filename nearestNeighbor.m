function [ matches ] = nearestNeighbor( descriptor1, descriptor2 )
%nearestNeighbor Matches descriptors in describedA, describedB
%   Uses nearest neighbour check on descriptors, checking both directions
%   Inputs are MxN matrices of descriptors for image 1, image 2
%   Output is a 2xA matrix where each column is a matching pair of indices
%   from descriptor1, descriptor2

% Variable initialization
N = size(descriptor1, 2);
M = size(descriptor2, 2);
matchesAToB = zeros(1, N);
matchesBToA = zeros(1, M);

% Iterate over patches in A and match with B
for n=1:N
    % Get description for iteration
    descA = descriptor1(:, n);
    dist = zeros(1, M);
    for m = 1:M
        % Compare to each described patch from image B
        descB = descriptor2(:, m);
        dist(m) = sum(abs(descA - descB));
    end
    [~, idxM] = min(dist);
    % Index n has been matched with idxM
    matchesAToB(n) = idxM;
end

% Iterate over patches in B and match with A
for m=1:M
    % Get description for iteration
    descB = descriptor2(:, m);
    dist = zeros(1, N);
    for n=1:N
        % Compare to each described patch from image B
        descA = descriptor1(:, n);
        dist(n) = sum(abs(descA - descB));
    end
    [~, idxN] = min(dist);
    % Index  m has been matched with idxN
    matchesBToA(m) = idxN;
end

% Check that patches are nearest neighbour in BOTH directions
matches = [];
nMatch = 0;
for n=1:N
    m = matchesAToB(n);
    if n == matchesBToA(m)
        nMatch = nMatch + 1;
        matches(1, nMatch) = n;
        matches(2, nMatch) = m;
    end
end

end