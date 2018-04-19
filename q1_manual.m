srcFiles = dir('boat/*.pgm');
for i = 1:length(srcFiles)
  directory = strcat('boat/', srcFiles(i).name);
  images{i} = imread(directory);
end
imgA = images{1};
imgB = images{5};

figure(1);
imshow(imgA);
figure(2);
imshow(imgB);
%%

%Select K interest points
K = 10;
for i = 1:K
    figure(1)
    pointsA(i,:) = ginput(1);
    hold all;
    scatter(pointsA(i,1), pointsA(i,2),'o','filled')
    
    figure(2)
    pointsB(i,:) = ginput(1);
    hold all;
    scatter(pointsB(i,1), pointsB(i,2),'o','filled')
end
