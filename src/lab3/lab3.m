% Lab 3
% author: Mauricio Reyes
%Objectives: Use RF model to pre-classify a test image

%% General parameters
clear all;
path2Images='../../data/';
voxelSize=[1.2,1.2,1.2];
origin=[-37.888,-21.483,148.563];
resampleScale=1.0; %optional to speed up, 
testImages_index=[11:20]; %range of images to test.
rescaleFactor=0.5;
voxelSize=[voxelSize(1)*rescaleFactor voxelSize(2)*rescaleFactor voxelSize(3)];

%%
% Read Model (of your choice, built from lab2) Make sure the number of
% features and order of them coincide 
load('treeModel.mat');
nfeatures=size(treeModel.VarAssoc,1);% get number of features used by the model
 %% Test model on evaluation dataset. Use dice  as evaluation metric.
 %read and extract features from testing images
disp('---testing model on evaluation dataset...');
diceScores=zeros(size(testImages_index,1),1);
%diceScores_post=zeros(size(testImages_index,1),1);

for i=1:size(testImages_index,2);
    %read image and label
    path2Image=strcat(path2Images,'image-0',num2str(testImages_index(i)),'.mhd');
    disp(strcat('---reading image ',path2Image));
    myImage=mha_read_volume(path2Image);
    myImage=imresize(myImage,rescaleFactor);
    
    %read label image
    path2LabelImage=strcat(path2Images,'labels-0',num2str(testImages_index(i)),'.mhd');
    myLabelImage=mha_read_volume(path2LabelImage);
    myLabelImage=imresize(myLabelImage,rescaleFactor,'nearest');
    
    %segment image
    disp('---extracting feature...');
    X=extractFeaturesImageEvaluation(myImage,nfeatures);
    disp('---segmenting image...');
tic
    [Yc,scores] = predict(treeModel,double(X));
toc
    disp('---converting to volume...');
tic
    myImage_segmented=cell2mat(Yc);
    myImage_segmented=str2num(myImage_segmented(:));
    myImage_segmented=reshape(myImage_segmented,size(myImage));
    
  
    
    
toc
    figure;
    subplot(1,2,1);
    viewImage(myImage,voxelSize);
    subplot(1,2,2);
    viewImage(myImage_segmented,voxelSize);

    %compute dice coefficient
    disp('--computing dice...');
    diceScores(i)=dicecoeff(myImage_segmented,myLabelImage,1.0)
    
    %postProcess and compare
%     myImage_segmented_postProc=spatialRegularization(myImage_segmented);
%     disp('--computing dice. post-processed image..');
%     diceScores_post(i)=dicecoeff(myImage_segmented_postProc,myLabelImage,1.0)
    

end



%% Tasks:

%  1. Understand the code functionality
%  2.- visualize the scores (output from the predict function) as images.
% Interpret the results.

%  3. Add a postprocessing step to eliminate spurious results. Visualize
% results and check Dice coefficient.

 






