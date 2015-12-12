function [ Pm ] = postprocessPredictionVisual( Ps )
%POSTPROCESSPREDICTION Summary of this function goes here
%   Detailed explanation goes here

voxelSize=[0.3906 0.3906 1];
slide = 16;

T = 0.5;
Pm = Ps > T;

f = figure;
viewImage(Pm, voxelSize, slide);
print(f, '../../doc/results/beforePostprocessing2D', '-depsc');
title('beforePostprocessing2D');
f = figure;
visualizeVolume(Pm,Ps,voxelSize);
print(f, '../../doc/results/beforePostprocessing3D', '-depsc');
title('beforePostprocessing3D');

for k = 1:size(Pm, 3)
    Pm(:,:,k) = imopen(Pm(:,:,k), strel('disk', 3));
end

f = figure;
viewImage(Pm, voxelSize, slide);
print(f, '../../doc/results/afterOpening2D', '-depsc');
title('afterOpening2D');
f = figure;
visualizeVolume(Pm,Ps,voxelSize);
print(f, '../../doc/results/afterOpening3D', '-depsc');
title('afterOpening3D');

for k = 1:size(Pm, 3)
    Pm(:,:,k) = keepLargestArea(Pm(:,:,k));
end

f = figure;
viewImage(Pm, voxelSize, slide);
print(f, '../../doc/results/afterKeepLargestArea2D', '-depsc');
title('afterKeepLargestArea2D');
f = figure;
visualizeVolume(Pm,Ps,voxelSize);
print(f, '../../doc/results/afterKeepLargestArea3D', '-depsc');
title('afterKeepLargestArea3D');


for k = 1:size(Pm, 3)
    Pm(:,:,k) = imfill(Pm(:,:,k), 'holes');
end

f = figure;
viewImage(Pm, voxelSize, slide);
print(f, '../../doc/results/afterImFill2D', '-depsc');
title('afterImFill2D');
f = figure;
visualizeVolume(Pm,Ps,voxelSize);
print(f, '../../doc/results/afterImFill3D', '-depsc');
title('afterImFill3D');


labeledImage = bwlabeln(Pm, 6);
stat = regionprops(labeledImage, 'area');
[~, sortIndexes] = sort([stat.Area], 'descend');
biggestBlob = ismember(labeledImage, sortIndexes(1));
Pm = biggestBlob > 0;

f = figure;
viewImage(Pm, voxelSize, slide);
print(f, '../../doc/results/afterKeepLargestVolume2D', '-depsc');
title('afterKeepLargestVolume2D');
f = figure;
visualizeVolume(Pm,Ps,voxelSize);
print(f, '../../doc/results/afterKeepLargestVolume3D', '-depsc');
title('afterKeepLargestVolume3D');

% close all;

end

