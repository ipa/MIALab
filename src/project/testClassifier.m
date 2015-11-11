%% Medical Image Analysis Lab
% Author: Iwan Paolucci, Severin Tobler

%% Prepare
clear; close all; clc;

load('treeModelBootstrapped_moredata.mat');
% treeModel = treeModel2;
% clear treeModel2;
addpath(genpath('../libs'));
myImage_path='../../data/';

voxelSize=[1.2,1.2,1.2];
% origin=[-37.888,-21.483,148.563];
% proportionSamples=0.05;

features = struct('Std', 1, 'Avg', 1, 'Ent', 1, 'Pos', 0, 'RelPos', 1, ...
                  'Gauss', 1, 'LoG', 1, 'Ske', 0, 'Sobel', 1, 'Prewitt', 1,...
                  'Laplacian', 1, 'Hist', 0);
%% Select Model
%treeModel = compactTreeModel79;

%% Predict Slice per slice
path2image = [myImage_path, 'image-017.mhd'];
path2label = [myImage_path, 'labels-017.mhd'];
myImage=mha_read_volume(path2image);
myLabel=mha_read_volume(path2label);
myLabel = logical(myLabel == 1);

Dice = zeros(size(myImage, 3), 10);

% figure
for k = 1:size(myImage, 3)
    display(['Processing slice ', num2str(k)]);
    
    [Xs] = extractFeaturesPerSlice(myImage, features, k);
    
    display('-- predicting');
    [prediction13, score13] = compactTreeModel13.predict(Xs);
    [prediction46, score46] = compactTreeModel46.predict(Xs);
    [prediction79, score79] = compactTreeModel79.predict(Xs);
    
    T = 0.5;
    Pm13 = score13(:,2) > T;
    Pm46 = score46(:,2) > T;
    Pm79 = score79(:,2) > T;
    Pm = (Pm13 + Pm46 + Pm79) >= 3;
    score = (score13(:,2) + score46(:,2) + score79(:,2)) / 3;
     %Pm = cell2mat(prediction) == '1';
    P = reshape(Pm, [size(myImage,1), size(myImage, 2), 1]);

    Dice(k, 1) = dice(P, myLabel(:,:,k));
    Dice(k, 10) = dice(keepLargestArea(P), myLabel(:,:,k));
    
    figure(2);
    subplot(2,2,1);
    imshow(P);
    title(['DICE: ', num2str(Dice(k))]);
    subplot(2,2,2);
    imshow(keepLargestArea(P));
    title(['Slice: ', num2str(k)]);
    subplot(2,2,3);
    imshow(myLabel(:,:,k));
    title('Ground Truth');
    subplot(2,2,4);
%     scoreTrue = score();
    scoreTrueR = mat2gray(reshape(score, [size(myImage,1), size(myImage,2),1]));
    %scoreTrueR = scoreTrueR > 0.9; %(scoreTrueR < 0.9) = 0;
    imshow(scoreTrueR);
    title('Score');
    pause(0.1);
    
    figure(1)
    imshow(scoreTrueR);
    colormap hot
    colorbar
    dice(scoreTrueR, myLabel(:,:,k));
    
    
    
%     segmented2 = bwpropfilt(scoreTrueR, 'Area', [500, Inf]);
%     imshow(segmented2);
%     dice(segmented2, myLabel(:,:,k));
%     figure
     %labelVec = myLabel(:,:,k);
     %[RocX, RocY, ~, AUC] = perfcurve(labelVec(:)', scoreTrue, true);
%     plot(RocX, RocY, 'b');
%     title(['ROC Curve - AUC: ', num2str(AUC)]);
    
%     figure
%     subplot(2,3,1)
%     imshow(Pg);
%     title(['Original Dice: ', num2str(dice(Pg, myLabel(:,:,k)))]);
%     subplot(2,3,2)
    PgE = imerode(P, strel('disk', 2));
    Dice(k, 2) = dice(PgE,  myLabel(:,:,k));
    Dice(k, 6) = dice(keepLargestArea(PgE), myLabel(:,:,k));
%     imshow(PgE);
%     title(['Erode Dice: ', num2str(dice(PgE, myLabel(:,:,k)))]);
%     subplot(2,3,3)
    PgD = imdilate(P, strel('disk', 2));
    Dice(k, 3) = dice(PgD,  myLabel(:,:,k));
    Dice(k, 7) = dice(keepLargestArea(PgD), myLabel(:,:,k));
%     imshow(PgD);
%     title(['Dilate Dice: ', num2str(dice(PgD, myLabel(:,:,k)))]);
%     subplot(2,3,4)
    PgO = imopen(P, strel('disk', 2));
    Dice(k, 4) = dice(PgO,  myLabel(:,:,k));
    Dice(k, 8) = dice(keepLargestArea(PgO), myLabel(:,:,k));
%     imshow(PgO);
%     title(['Open Dice: ', num2str(dice(PgO, myLabel(:,:,k)))]);
%     subplot(2,3,5)2
    PgC = imclose(P, strel('disk', 2));
    Dice(k, 5) = dice(PgC,  myLabel(:,:,k));
    Dice(k, 9) = dice(keepLargestArea(PgC), myLabel(:,:,k));
%     imshow(PgC);
%     title(['Close Dice: ', num2str(dice(PgC, myLabel(:,:,k)))]);
end
%display(Dice);
%save(sprintf('Dice_%d', num2str(nImg), 'Dice'));
% mean(Dice);
figure
boxplot(Dice(1:end-15,:));

%exit;