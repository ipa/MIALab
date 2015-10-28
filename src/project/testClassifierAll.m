%% Medical Image Analysis Lab
% Author: Iwan Paolucci, Severin Tobler

%% Prepare
clear; close all; clc;

load('treeModel.mat');

addpath(genpath('../libs'));
myImage_path='../../data/';

nImages = 2;

features = struct('Std', 1, 'Avg', 1, 'Ent', 1, 'Pos', 0, 'RelPos', 1, ...
    'Gauss', 1, 'LoG', 1, 'Sobel', 1, 'Prewitt', 1, 'Laplacian', 1);
%% Predict Slice per slice
path2InputImages = strcat(myImage_path,'image*.mhd');
path2LabelImages = strcat(myImage_path,'labels*.mhd');

dirlist_InputImages = dir(path2InputImages);
dirlist_LabelImages = dir(path2LabelImages);

for i = 1:nImages
    display(['=== processing image ', num2str(i)]);
    %strings pointing to each image
    path2Image = strcat(myImage_path,dirlist_InputImages(i).name);
    path2LabelImage = strcat(myImage_path,dirlist_LabelImages(i).name);
    
    myImage = mha_read_volume(path2Image);
    myLabel = mha_read_volume(path2LabelImage);
    myLabel = logical(myLabel == 1);
    
    Dice = zeros(size(myImage, 3), 5);
    
    % figure
    for k = 1:size(myImage, 3)
        display(['Processing slice ', num2str(k)]);
        
        [Xs] = extractFeaturesPerSlice(myImage, features, k);
        
        display('-- predicting');
        [prediction, ~] = treeModel.predict(Xs);
        
        Pm = uint8(cell2mat(prediction)) - 48;
        %clear prediction;
        P = reshape(Pm, [size(myImage,1), size(myImage, 2), 1]);
        %clear Pm;
        %P1 = mat2gray(P);
        %clear P;
        %P2 = imerode(P1, strel('disk', 3));
        Pg = logical(mat2gray(P));
        %clear P1;
        Dice(k, 1) = dice(Pg, myLabel(:,:,k));
        %clear Pg;
        
        %     subplot(2,2,1);
        %     imshow(Pg);
        %     title(['DICE: ', num2str(Dice(k))]);
        %     subplot(2,2,2);
        %     imshow(myImage(:,:,k),[]);
        %     title(['Slice: ', num2str(k)]);
        %     subplot(2,2,3);
        %     imshow(myLabel(:,:,k));
        %     title('Ground Truth');
        %     subplot(2,2,4);
        % scoreTrue = score(:,2);
        %     scoreTrueR = mat2gray(reshape(scoreTrue, [size(myImage,1), size(myImage,2),1]));
        % %     scoreTrueR(scoreTrueR < 0.9) = 0;
        %     imshow(scoreTrueR);
        %     title('Score');
        %     pause(0.1);
        
        %     figure
        % labelVec = myLabel(:,:,k);
        % [RocX, RocY, ~, AUC] = perfcurve(labelVec(:)', scoreTrue, true);
        %     plot(RocX, RocY, 'b');
        %     title(['ROC Curve - AUC: ', num2str(AUC)]);
        
        %     figure
        %     subplot(2,3,1)
        %     imshow(Pg);
        %     title(['Original Dice: ', num2str(dice(Pg, myLabel(:,:,k)))]);
        %     subplot(2,3,2)
        PgE = imerode(Pg, strel('disk', 2));
        Dice(k, 2) = dice(PgE,  myLabel(:,:,k));
        %     imshow(PgE);
        %     title(['Erode Dice: ', num2str(dice(PgE, myLabel(:,:,k)))]);
        %     subplot(2,3,3)
        PgD = imdilate(Pg, strel('disk', 2));
        Dice(k, 3) = dice(PgD,  myLabel(:,:,k));
        %     imshow(PgD);
        %     title(['Dilate Dice: ', num2str(dice(PgD, myLabel(:,:,k)))]);
        %     subplot(2,3,4)
        PgO = imopen(Pg, strel('disk', 2));
        Dice(k, 4) = dice(PgO,  myLabel(:,:,k));
        %     imshow(PgO);
        %     title(['Open Dice: ', num2str(dice(PgO, myLabel(:,:,k)))]);
        %     subplot(2,3,5)2
        PgC = imclose(Pg, strel('disk', 2));
        Dice(k, 5) = dice(PgC,  myLabel(:,:,k));
        %     imshow(PgC);
        %     title(['Close Dice: ', num2str(dice(PgC, myLabel(:,:,k)))]);
    end
    
    display(Dice);
    save(sprintf('Dice_%d', i), 'Dice');
    clear myImage
    clear myLabel
end
exit;