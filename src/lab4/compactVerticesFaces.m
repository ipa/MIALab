function [ FV ] = compactVerticesFaces( FV )
%COMPACTVERTICESFACES Summary of this function goes here
%   Detailed explanation goes here

[FV.vertices, idx] = sortrows(FV.vertices);
M = [true; any(diff(FV.vertices), 2)];
FV.vertices = FV.vertices(M,:);
%normals = normals(M,:);
idx(idx) = cumsum(M);
FV.faces = idx(FV.faces);

end

