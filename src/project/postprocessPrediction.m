function [ Pm ] = postprocessPrediction( Ps )
%POSTPROCESSPREDICTION Summary of this function goes here
%   Detailed explanation goes here

T = 0.5;
Pm = Ps > T;

for k = 1:size(Pm, 3)
    Pm(:,:,k) = imfill(Pm(:,:,k), 'holes');
    Pm(:,:,k) = keepLargestArea(Pm(:,:,k));
    Pm(:,:,k) = imopen(Pm(:,:,k), strel('disk', 2));
end

end

