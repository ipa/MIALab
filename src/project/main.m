%% Medical Image Analysis Lab
% Author: Iwan Paolucci, Severin Tobler

%% Prepare
clear; close all; clc;

load('finalModel.mat');
% treeModel = treeModel2;
% clear treeModel2;
addpath(genpath('../libs'));
myImage_path='../../data/';

voxelSize=[0.3906 0.3906 1];
% origin=[-37.888,-21.483,148.563];
% proportionSamples=0.05;

useRF = true;
useSSM = false;

% features = struct('Std', 1, 'Avg', 1, 'Ent', 1, 'Pos', 0, 'RelPos', 1, ...
%                   'Gauss', 1, 'LoG', 1, 'Ske', 0, 'Sobel', 1, 'Prewitt', 1,...
%                   'Laplacian', 1, 'Hist', 0);
%% Load Image
path2image = [myImage_path, 'image-017.mhd'];
path2label = [myImage_path, 'labels-017.mhd'];
myImage=mha_read_volume(path2image);
myLabel=mha_read_volume(path2label);
myLabel = logical(myLabel == 1);

%% Predict
[P, Ps] = predictImage(treeModel, myImage, features);
display(dice(P, myLabel));

%% Post Process
[P] = postprocessPrediction(Ps);
display(dice(P, myLabel));

%% Performance Curve
figure
[RocX, RocY, ~, AUC] = perfcurve(myLabel(:), Ps(:), true);
plot(RocX, RocY, 'b');
title(sprintf('ROC Curve - AUC: %0.2f', AUC*100));

%% Create Volume Rendering
visualizeVolume(P, Ps, voxelSize);