
% Lab 5 Active shape models
% author: Mauricio Reyes
%objective: use model from previous session to automatically segment a new image

%% set main parameters

% clear all;
%% General parameters
addpath(genpath('../libs'));
%%
search_range=8.0; %in mm
search_samples=4; %number of samples per profile
niterations=30;
nscalefactor = 0.02;
myImage_path ='../../data/image-017.mhd';

voxelSize=[0.3906,0.3906,1.0];


origin=[-35.9352,-17.5770,120.7290];%sample17
%origin=[35.9352,27.5770,120.7290];%sample17

figure
camlight('headlight');

%% Read inputs, model, image
load('SSM_KneeModel.mat');  %eigVals, eigVectors, meanShape;
dimSample=size(meanShape,1);
meanShape_3D=reshape(meanShape,[dimSample/3 3]); %transform to [npoints x 3] array to manipulate coordinates


%% Corrections to mesh to match orientation of image. This can be done later with image registration methods

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

%% Read target image and compute edge map
myImage=mha_read_volume(myImage_path);

myImageEdge=zeros(size(myImage));
for j=1:size(myImage,3)
    %smearing the detected edge
    H = fspecial('gaussian',30,10);
    %edge detection
    edgecomp=edge(myImage(:,:,j),'canny', [], 3);%,[],3
    myImageEdge(:,:,j) = exp(5*imfilter(double(edgecomp),H,'replicate'));
end
viewImage(myImageEdge, voxelSize);hold on;

%% Iterate between normal searching and procrustes and shape transformations

%currShape is our deformable (statistically) model.
currShape=meanShape_3D;
%flatten it for computations
currShape1D=reshape(currShape,dimSample,1);
plotSample(currShape1D,FV,[.3 .3 .5]);hold on;drawnow;

% niterations = ;
%store iterations
evolution=zeros(dimSample,niterations);
d = zeros(niteraions, 1);
dist = zeros(niterations, 1);

for it=1:niterations
    
    strj=strcat('Iteration:',num2str(it));
    disp(strj);
    %find strong edges
    
    disp('Searching gradient profile...')
    tic
    Y=searchProfileGridInterp(myImageEdge,currShape,pointNormals,search_range,search_samples,voxelSize);
    toc
    
    %find affine transformation
    disp('Procrustes...')
    [d,Ytrans,transform]=procrustes(Y,currShape,'reflection',false); %finds transform that fits currShape to observation Y.
    
    % update shape component
    disp('Shape component...')
    currShape=shapeUpdate(Y,transform,eVals,eVecs,meanShape);
    
    %update normals
    disp('Updating normals...')
    for i=1:dimSample/3
        pointNormals(i,:)=pointnormal(i,FV.faces,currShape,point2Cell);
    end
    
    %visualize updated shape
    currShape1D=reshape(currShape,dimSample,1);
    plotSample(currShape1D,FV,'g');
    hold on
    quiver3(currShape(:,1), currShape(:,2), currShape(:,3), ...
        Y(:,1)*nscalefactor, Y(:,2)*nscalefactor, Y(:,3)*nscalefactor,...
        'AutoScale', 'on', 'Color', 'b');
    drawnow;
    evolution(:,it)=currShape1D;
    
    if it > 1
        d(it) = sum((evolution(:,it) - evolution(:,it-1)).^2);
        dist(it) = norm(mean(evolution(:,it-1)-evolution(:,it)),2);
        disp(sprintf('d = %f', d(it)));
        disp(sprintf('dist = %f', dist(it)));
    end
end
d(1) = d(2);
dist(1) = dist(2);

disp('Iterations done.');


%% For testing. Compare against real shape (GT)

% FVSample=read_wobj('../lab4/DataSSMModel/R_Femur_17.obj');
% shapeGT=FVSample.vertices;
% fvSample.faces=FVSample.faces;

%% draw
%swap row and columns for mesh coordinates to match. why? because i,j,k
%=y,x,z - Or, rows (second component) increase X component.
shapeGT=shapeGT+repmat(origin,size(shapeGT,1),1);

temp=shapeGT(:,1);
shapeGT(:,1)=shapeGT(:,2);
shapeGT(:,2)=temp;

%plot both meshes
shapeGT1D=reshape(shapeGT,size(shapeGT,1)*3,1);
figure
plotSample(shapeGT1D,fvSample,'b');
plotSample(currShape1D,FV,'g');view([1,0,0]);
for i=1:niterations
    
    subplot(1,3,1);
    hplot=plotSample(evolution(:,i),FV,'g');view([1,0,0]);
    h2=subplot(1,3,2);copyobj(hplot,h2);view([0,1,0]);
    h3=subplot(1,3,3);copyobj(hplot,h3);view([0,0,1]);
    
    evolution3D=reshape(evolution(:,i),dimSample/3,3);
    p2pError(i)=norm(mean(shapeGT-evolution3D),2);
    pause(0.2);
end

% plot point-to-point average erro
figure; plot([1:niterations],p2pError);title('Point-to-Point distance error vs number of iterations');axis tight;



%% Tasks

% 1.- Visualize normal searching (hint: use lines or quiver3)

% 2.- Try out different values for search range and number of samples

% 3.- Try out different edge map parameters. Consider the tradeoff between edge
% accuracy, thickness (too thin can get undetetected), and removal of non
% desired edge information coming from other structures in the image.

% 3.- change the routine to have a criterion stop that stops the iterations when
%a given delta shape is lower than a defined threshold



