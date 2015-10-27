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
    
    Dice = zeros(size(myImage, 3), 1);
    
    % figure
    for k = 1:size(myImage, 3)
        display(['---- Processing slice ', num2str(k)]);
        
        [Xs] = extractFeaturesPerSlice(myImage, features, k);
        
        display('---- predicting');
        prediction = treeModel.predict(Xs);
        
        Pm = uint8(cell2mat(prediction)) - 48;
        clear prediction;
        P = reshape(Pm, [size(myImage,1), size(myImage, 2), 1]);
        clear Pm;
        P1 = mat2gray(P);
        clear P;
        Pg = logical(P1);
        clear P1;
        Dice(k) = dice(Pg, myLabel(:,:,k));
        clear Pg;
    end
    
    display(Dice);
    save(sprintf('Dice_%d', i), 'Dice');
    clear myImage
    clear myLabel
end
exit;