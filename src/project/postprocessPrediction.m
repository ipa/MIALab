function [ Pm ] = postprocessPrediction( Ps )
%POSTPROCESSPREDICTION Summary of this function goes here
%   Detailed explanation goes here

T = 0.5;
Pm = Ps > T;

% for i = 1:size(Pm, 1)
%     Pm(i,:,:) = imopen(Pm(i,:,:), strel('disk', 2));
% end
% 
% for j = 1:size(Pm, 2)
%     Pm(:,j,:) = imopen(Pm(:,j,:), strel('disk', 2));
% end

for k = 1:size(Pm, 3)
    Pm(:,:,k) = imopen(Pm(:,:,k), strel('disk', 2));
    Pm(:,:,k) = keepLargestArea(Pm(:,:,k));
    Pm(:,:,k) = imfill(Pm(:,:,k), 'holes');
end

end

