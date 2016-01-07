%% Medical Image Analysis Lab
% Author: Iwan Paolucci, Severin Tobler
% Group : The Tree Nurses
clear; close all; clc;

%% Settings
libPath     = '../../libs/ReadData3D_version1k/';
imagePath   = '../../../data/testData/';
imageFile   = 'image-029.mhd';
showMRSlice = false;

%% Prepare
load('treeModel.mat');
addpath(genpath(libPath));

%% Load Image
fprintf('Processing File %s\n', imageFile);
path2image = [imagePath, imageFile];
myImage = mha_read_volume(path2image);

info = mha_read_header(path2image);
voxelSize = info.PixelDimensions;

%% Predict
[~, Ps] = predictImage(treeModel, myImage, features);

%% Post Process
[Ppp] = postprocessPrediction(Ps);

%% Create Volume Rendering
visualizeVolume(Ppp, Ps, voxelSize);

%% Add MR slice
if showMRSlice
    hold on
    viewImage(myImage, voxelSize);
    view([137,40]);
end
