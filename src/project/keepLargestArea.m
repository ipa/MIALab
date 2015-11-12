function [ Bw ] = keepLargestArea( Bw )
%KEEPLARGESTAREA Summary of this function goes here
%   Detailed explanation goes here

if nnz(Bw) > 0
    labeledImage = bwlabel(Bw);
    stat = regionprops(labeledImage, 'area');
    [sortAreas, sortIndexes] = sort([stat.Area], 'descend');
    
    if sortAreas(1) > 10
        biggestBlob = ismember(labeledImage, sortIndexes(1));
        Bw = biggestBlob > 0;
    else
        Bw = logical(zeros(size(Bw)));
    end
end
end

