function [ FV , eVecs] = compactVerticesFacesEVecs( FV, eVecs )
%COMPACTVERTICESFACES Summary of this function goes here
%   Detailed explanation goes here

[FV.vertices, idx] = sortrows(FV.vertices);
eVecs = eVecs(idx,:,:);
M = [true; any(diff(FV.vertices), 2)];
FV.vertices = FV.vertices(M,:);
eVecs = eVecs(M,:,:);
%normals = normals(M,:);
idx(idx) = cumsum(M);
FV.faces = idx(FV.faces);

end

