function [ Pm ] = postprocessPredictionVisual( Ps )
%POSTPROCESSPREDICTION Summary of this function goes here
%   Detailed explanation goes here

voxelSize=[0.3906 0.3906 1];
slide = 40;

T = 0.5;
Pm = Ps > T;

figure;
visualizeVolume(Pm,Ps,voxelSize);
print(gcf, '../../doc/results/beforePostprocessing', '-depsc');

for k = 1:size(Pm, 3)
    Pm(:,:,k) = imopen(Pm(:,:,k), strel('disk', 3));
end

visualizeVolume(Pm,Ps,voxelSize);
print(gcf, '../../doc/results/afterOpening', '-depsc');

for k = 1:size(Pm, 3)
    Pm(:,:,k) = keepLargestArea(Pm(:,:,k));
end

visualizeVolume(Pm,Ps,voxelSize);
print(gcf, '../../doc/results/afterKeepLargestArea', '-depsc');


for k = 1:size(Pm, 3)
    Pm(:,:,k) = imfill(Pm(:,:,k), 'holes');
end

visualizeVolume(Pm,Ps,voxelSize);
print(gcf, '../../doc/results/afterImFill', '-depsc');


labeledImage = bwlabeln(Pm, 6);
stat = regionprops(labeledImage, 'area');
[~, sortIndexes] = sort([stat.Area], 'descend');
biggestBlob = ismember(labeledImage, sortIndexes(1));
Pm = biggestBlob > 0;

visualizeVolume(Pm,Ps,voxelSize);
print(gcf, '../../doc/results/afterKeepLargestVolume', '-depsc');
title('afterKeepLargestVolume3D');

% close all;

end

