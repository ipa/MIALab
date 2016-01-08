%% Medical Image Analysis Lab
% Author: Iwan Paolucci, Severin Tobler
% Group : The Tree Nurses
% Date  : 8 January 2016
clear; close all; clc;

%% Settings
libPath     = '../../libs/ReadData3D_version1k/';
imageFile   = '../../../data/testData/image-029.mhd';
showMRSlice = false;

%% Prepare
load('treeModel.mat');
addpath(genpath(libPath));

%% Load Image
fprintf('Processing File %s\n', imageFile);
myImage = mha_read_volume(imageFile);

% read voxel size from .mhd header file
info = mha_read_header(imageFile);
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
