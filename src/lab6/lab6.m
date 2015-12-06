% Lab6. Combining RF classification with ASM

%% load RF model
load('treeModel_nfeatures7_ntrees10_nimages10.mat');
nfeatures=size(treeModel.VarAssoc,1);% get number of features used by the model
%% segment image with RF model

%segment image
disp('---extracting feature...');
X=extractFeaturesImageEvaluation(myImage,nfeatures);
disp('---segmenting image...');

[Yc,scores] = predict(treeModel,double(X));

disp('---converting to volume...');

myImage_segmented=cell2mat(Yc);
myImage_segmented=str2num(myImage_segmented(:));
myImage_segmented=reshape(myImage_segmented,size(myImage));  

myImage_segmented=reshape(scores(:,2),size(myImage));  

figure;viewImage(myImage_segmented, voxelSize);

%% combine RF (myImage_segmented) and edge map (myImageEdge)

myImageEdgeBoost= (myImageEdge-1.0) .* myImage_segmented;

subplot(1,3,1);viewImage(myImageEdge, voxelSize);
subplot(1,3,2);viewImage(myImage_segmented, voxelSize);
subplot(1,3,3);viewImage(myImageEdgeBoost, voxelSize);


%% Tasks:
% 1.- Compare the error progression obtained with the previous edge map and
% with the new boosted edge map
%2.- Experiment with different combinations of edge map from Lab. 5 and the
%RF-generated classification. 
  

