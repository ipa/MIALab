function [ Pm ] = postprocessPrediction( Ps )
%POSTPROCESSPREDICTION Summary of this function goes here
%   Detailed explanation goes here

T = 0.5;
Pm = Ps > T;

for k = 1:size(Pm, 3)
    Pm(:,:,k) = imopen(Pm(:,:,k), strel('disk', 3));
    Pm(:,:,k) = keepLargestArea(Pm(:,:,k));
    Pm(:,:,k) = imfill(Pm(:,:,k), 'holes');
end

labeledImage = bwlabeln(Pm, 6);
stat = regionprops(labeledImage, 'area');
[~, sortIndexes] = sort([stat.Area], 'descend');

biggestBlob = ismember(labeledImage, sortIndexes(1));
Pm = biggestBlob > 0;

end

