function [ meanShape_3D, meanShape, dimSample, FV, pointNormals, eVals, eVecs, point2Cell ] = loadSSM( ssmfile, origin )
%LOADSSM Summary of this function goes here
%   Detailed explanation goes here

%% Read inputs, model, image
load(ssmfile);  %eigVals, eigVectors, meanShape;
dimSample=size(meanShape,1);
meanShape_3D=reshape(meanShape,[dimSample/3 3]); %transform to [npoints x 3] array to manipulate coordinates


for i=1:dimSample/3 % add origin
    meanShape_3D(i,1)=meanShape_3D(i,1)+origin(1);
    meanShape_3D(i,2)=meanShape_3D(i,2)+origin(2);
    meanShape_3D(i,3)=meanShape_3D(i,3)+origin(3);
end

%swap row and columns for mesh coordinates to match. why? because i,j,k
%=y,x,z - Or, rows (second component) increase X component.
temp=meanShape_3D(:,1);
meanShape_3D(:,1)=meanShape_3D(:,2);
meanShape_3D(:,2)=temp;
FV.vertices=meanShape_3D;

%swap also row and columns for eigenVectors.
eVecs3D=reshape(eVecs,dimSample/3,3,9); % 9=modes, hard coded
temp=eVecs3D(:,1,:);
eVecs3D(:,1,:)=eVecs3D(:,2,:);
eVecs3D(:,2,:)=temp;
eVecs=reshape(eVecs3D,dimSample,9);

% go back to 1D vector for ASM labor
meanShape=reshape(meanShape_3D,dimSample,1);


%% Compute and store normals information
% compute point normals as the average of neighboring face normals.
point2Cell=pointCellStructure(FV.faces,meanShape_3D);

pointNormals=zeros(dimSample/3,3);
for i=1:dimSample/3
    pointNormals(i,:)=pointnormal(i,FV.faces,meanShape_3D,point2Cell);
end



end

