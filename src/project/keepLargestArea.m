function [ Bw ] = keepLargestArea( Bw )
%KEEPLARGESTAREA Summary of this function goes here
%   Detailed explanation goes here

T = 10;

if nnz(Bw) > 0
    labeledImage = bwlabel(Bw, 4);
    stat = regionprops(labeledImage, 'area');
    [sortAreas, sortIndexes] = sort([stat.Area], 'descend');
    
    if sortAreas(1) > T
        biggestBlob = ismember(labeledImage, sortIndexes(1));
        Bw = biggestBlob > 0;
    else
        Bw = logical(zeros(size(Bw)));
    end
end
end

