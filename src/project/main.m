%% Medical Image Analysis Lab
% Author: Iwan Paolucci, Severin Tobler

%% Prepare
clear; close all; clc;

load('treeModel2.mat');
% treeModel = treeModel2;
% clear treeModel2;
addpath(genpath('../libs'));
myImage_path='../../data/';

voxelSize=[0.3906 0.3906 1];
% origin=[-37.888,-21.483,148.563];
% proportionSamples=0.05;

% features = struct('Std', 1, 'Avg', 1, 'Ent', 1, 'Pos', 0, 'RelPos', 1, ...
%                   'Gauss', 1, 'LoG', 1, 'Ske', 0, 'Sobel', 1, 'Prewitt', 1,...
%                   'Laplacian', 1, 'Hist', 0);

% for ni = 21:30
ni = 16;
%% Load Image
path2image = [myImage_path, sprintf('image-%03d.mhd', ni)];
path2label = [myImage_path, sprintf('labels-%03d.mhd', ni)];
myImage=mha_read_volume(path2image);
myLabel=mha_read_volume(path2label);
myLabel = logical(myLabel == 1);

%% Predict
[Pp, Ps] = predictImage(treeModel, myImage, features);
display(dice(Pp, myLabel));

%% Post Process
[Ppp] = postprocessPrediction(Ps);
display(dice(Ppp, myLabel));

%% Performance Curve
% display(dice(Pp, myLabel));
% display(dice(Ppp, myLabel));
figure
[RocX, RocY, ~, AUC] = perfcurve(myLabel(:), Ps(:), true);
plot(RocX, RocY, 'b');
title(sprintf('ROC Curve - AUC: %0.2f', AUC*100));

%% Create Volume Rendering
visualizeVolume(Ppp, Ps, voxelSize);

%% Add MR slices
hold on
viewImage(myImage, voxelSize);
save2pdf(sprintf('vr%03d.pdf', ni), gcf, 300);
% end