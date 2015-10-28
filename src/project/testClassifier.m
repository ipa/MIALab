%% Medical Image Analysis Lab
% Author: Iwan Paolucci, Severin Tobler

%% Prepare
clear; close all; clc;

load('treeModel.mat');

addpath(genpath('../libs'));
myImage_path='../../data/';

voxelSize=[1.2,1.2,1.2];
origin=[-37.888,-21.483,148.563];
proportionSamples=0.05;

features = struct('Std', 1, 'Avg', 1, 'Ent', 1, 'Pos', 0, 'RelPos', 1, ...
                  'Gauss', 1, 'LoG', 1, 'Sobel', 1, 'Prewitt', 1, 'Laplacian', 1);
%% Predict Slice per slice
path2image = [myImage_path, 'image-017.mhd'];
path2label = [myImage_path, 'labels-017.mhd'];
myImage=mha_read_volume(path2image);
myLabel=mha_read_volume(path2label);
myLabel = logical(myLabel == 1);

Dice = zeros(size(myImage, 3), 1);

% figure
for k = 1:size(myImage, 3)
    display(['Processing slice ', num2str(k)]);
    
    [Xs] = extractFeaturesPerSlice(myImage, features, k);
    
    display('-- predicting');
    prediction = treeModel.predict(Xs);
    
    Pm = uint8(cell2mat(prediction)) - 48;
    clear prediction;
    P = reshape(Pm, [size(myImage,1), size(myImage, 2), 1]);
    clear Pm;
    P1 = mat2gray(P);
    clear P;
    %P2 = imerode(P1, strel('disk', 3));
    Pg = logical(P1);
    clear P1;
    Dice(k) = dice(Pg, myLabel(:,:,k));
    clear Pg;

%     subplot(1,3,1);
%     imshow(Pg);
%     title(['DICE: ', num2str(Dice(k))]);
%     subplot(1,3,2);
%     imshow(myImage(:,:,k),[]);
%     title(['Slice: ', num2str(k)]);
%     subplot(1,3,3);
%     imshow(myLabel1(:,:,k));
%     title('Ground Truth');
%     pause(0.1);
end
display(Dice);
save(sprintf('Dice_%d', num2str(nImg), 'Dice'));
% mean(Dice);
% figure
% boxplot(Dice);

exit;