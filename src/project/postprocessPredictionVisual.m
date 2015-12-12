function [ Pm ] = postprocessPredictionVisual( Ps , Label, path )
%POSTPROCESSPREDICTION Summary of this function goes here
%   Detailed explanation goes here

voxelSize=[0.3906 0.3906 1];

T = 0.5;
Pm = Ps > T;

dices = zeros(5,1);

dices(1) = dice(Pm, Label);
figure;
visualizeVolume(Pm,Ps,voxelSize);
print(gcf, [path 'beforePostprocessing'], '-depsc');

for k = 1:size(Pm, 3)
    Pm(:,:,k) = imopen(Pm(:,:,k), strel('disk', 3));
end

dices(2) = dice(Pm, Label);
visualizeVolume(Pm,Ps,voxelSize);
print(gcf, [path 'afterOpening'], '-depsc');

for k = 1:size(Pm, 3)
    Pm(:,:,k) = keepLargestArea(Pm(:,:,k));
end

dices(3) = dice(Pm, Label);
visualizeVolume(Pm,Ps,voxelSize);
print(gcf, [path 'afterKeepLargestArea'], '-depsc');


for k = 1:size(Pm, 3)
    Pm(:,:,k) = imfill(Pm(:,:,k), 'holes');
end

dices(4) = dice(Pm, Label);
visualizeVolume(Pm,Ps,voxelSize);
print(gcf, [path 'afterImFill'], '-depsc');


labeledImage = bwlabeln(Pm, 6);
stat = regionprops(labeledImage, 'area');
[~, sortIndexes] = sort([stat.Area], 'descend');
biggestBlob = ismember(labeledImage, sortIndexes(1));
Pm = biggestBlob > 0;

dices(5) = dice(Pm, Label);
visualizeVolume(Pm,Ps,voxelSize);
print(gcf, [path 'afterKeepLargestVolume'], '-depsc');
title('afterKeepLargestVolume3D');

save([path 'dices.m', 'dices']);

end

