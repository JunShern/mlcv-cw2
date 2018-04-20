function [ matches ] = bestNearestNeighbors( descriptor1, descriptor2, numCorrespondences )
%nearestNeighbor Matches descriptors in describedA, describedB
%   Uses nearest neighbour check on descriptors, checking both directions
%   Inputs are MxN matrices of descriptors for image 1, image 2
%   Output is a 2xA matrix where each column is a matching pair of indices
%   from descriptor1, descriptor2

% Variable initialization
N = size(descriptor1, 2);
M = size(descriptor2, 2);
matchesAToB = zeros(N, 2); % Each row is (index_B, dist)
matchesBToA = zeros(M, 2); % Each row is (index_A, dist)

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
    [d, idxN] = min(dist);
    % Index n has been matched with idxM
    matchesAToB(n,:) = [idxN, d];
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
    [d, idxM] = min(dist);
    % Index  m has been matched with idxN
    matchesBToA(m,:) = [idxM, d];
end

% Check that patches are nearest neighbour in BOTH directions
matches = [];
nMatch = 0;
for n=1:N
    m = matchesAToB(n,1);
    if n == matchesBToA(m,1)
        nMatch = nMatch + 1;
        matches(nMatch, 1) = n;
        matches(nMatch, 2) = m;
        matches(nMatch, 3) = matchesBToA(m,2);
    end
end

% Sort matches by distance
matches = sort(matches, 3);
matches = matches(1:numCorrespondences,1:2)';
end