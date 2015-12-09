%% Egde Map
if useSSM
% myLabelEdge = zeros(size(myLabel));
myImageEdge = zeros(size(myImage));
% myPsEdge = zeros(size(myImage));
for j=1:size(myImage,3)
    %smearing the detected edge
    H = fspecial('gaussian', 30, 10);
    %edge detection
    edgecomp = edge(myImage(:,:,j),'canny', [], 3);%, 
    myImageEdge(:,:,j) = exp(5 * imfilter(double(edgecomp),H,'replicate'));
%     edgecomp = edge(P(:,:,j), 'canny', [], 3);
%     myPsEdge(:,:,j) = exp(5 * imfilter(double(edgecomp), H, 'replicate'));
%     edgecomp = edge(myLabel(:,:,j),'canny', [], 3);%, 
%     myLabelEdge(:,:,j) = exp(5 * imfilter(double(edgecomp),H,'replicate'));
end
% figure(3); clf
% subplot(3,1,1); viewImage(myImageEdge, voxelSize);
% subplot(3,1,2); viewImage(myPsEdge, voxelSize);
% subplot(3,1,3); viewImage(myLabelEdge, voxelSize);

% 
% Pd = zeros(size(P));
% for k = 1:size(P, 3)
%     Pd(:,:,k) = imdilate(Ps(:,:,k), strel('disk', 5));
% end
% viewImage(Pd, voxelSize);

%% Combine
myImageEdgeBoost = (myImageEdge - 1.0) .* Ps;
% myImageEdgeBoost = myImageEdge;
% myImageEdgeBoost = imfilter(myImageEdgeBoost, H+0.7, 'replicate');

figure(2); clf
subplot(2,2,1);viewImage(myImageEdge, voxelSize);
% subplot(2,2,2);viewImage(Ps, voxelSize);
subplot(2,2,3);viewImage(myImageEdgeBoost, voxelSize);
% subplot(2,2,4);viewImage(P, voxelSize);

%% Iterate between normal searching and procrustes and shape transformations
imageEdge = double(myImageEdge);

search_range=8.0; %in mm
search_samples=4; %number of samples per profile
niterations=30;
origin=[0 0 0];
origin = -[35.8488   42.7183-9*2 -116.6347];
[meanShape_3D, meanShape, dimSample, FV, pointNormals, eVals, eVecs, point2Cell] ...
    = loadSSM('SSM_KneeModel.mat', origin);

%currShape is our deformable (statistically) model.
currShape=meanShape_3D;
%flatten it for computations
currShape1D=reshape(currShape,dimSample,1);
plotSample(currShape1D,FV,[.3 .3 .5]);hold on;drawnow;
niterations = 15;
% niterations = ;
%store iterations
evolution=zeros(dimSample,niterations);
% d = zeros(niterations, 1);
% dist = zeros(niterations, 1);
figure(1); clf
plotSample(currShape1D,FV,'g');
hold on
viewImage(imageEdge, voxelSize, 40);
%% Iterate
for it=1:niterations
%     if it > 3 && mod(it, 3) >= 1
%         imageEdge = double(myImageEdgeBoost);
%     else
%         imageEdge = double(myImageEdge);
%     end
    figure(1); clf
%     viewImage(imageEdge, voxelSize, 20);hold on;
    viewImage(imageEdge, voxelSize, 40);hold on;
%     viewImage(imageEdge, voxelSize, 80);hold on;
    strj=strcat('Iteration:',num2str(it));
    disp(strj);
    %find strong edges
    
    disp('Searching gradient profile...')
    tic
    Y=searchProfileGridInterp(imageEdge,currShape,pointNormals,search_range,search_samples,voxelSize);
    toc
    
    %find affine transformation
    disp('Procrustes...')%, 'scaling', false
    [d,~,transform]=procrustes(Y,currShape, 'reflection', false); 
    %finds transform that fits currShape to observation Y.
    
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
%     quiver3(currShape(:,1), currShape(:,2), currShape(:,3), ...
%         Y(:,1)*nscalefactor, Y(:,2)*nscalefactor, Y(:,3)*nscalefactor,...
%         'AutoScale', 'on', 'Color', 'b');
    drawnow;
    evolution(:,it)=currShape1D;
    
%     if it > 1
%         d(it) = sum((evolution(:,it) - evolution(:,it-1)).^2);
%         dist(it) = norm(mean(evolution(:,it-1)-evolution(:,it)),2);
%         disp(sprintf('d = %f', d(it)));
%         disp(sprintf('dist = %f', dist(it)));
%     end
end
% d(1) = d(2);
% dist(1) = dist(2);

disp('Iterations done.');
end