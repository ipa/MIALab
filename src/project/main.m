%% Medical Image Analysis Lab
% Author: Iwan Paolucci, Severin Tobler

%% Prepare
clear; close all; clc;

load('treeModel3.mat');
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
%% Load Image
path2image = [myImage_path, 'image-017.mhd'];
path2label = [myImage_path, 'labels-017.mhd'];
myImage=mha_read_volume(path2image);
myLabel=mha_read_volume(path2label);
myLabel = logical(myLabel == 1);

%% Predict
P = predictImage(treeModel, myImage, features);
display(dice(P, myLabel));

%% Create Volume Rendering
% figure('Name','Result of Marching Cube (MATLAB)','NumberTitle','off')
% tic
res = [0.3906 0.3906 1];
Ps = smooth3(P, 'box', 5);
figure(10); clf
isovalue = 0;
colorBone = [1.0000    0.7812    0.4975];
[faces, verts] = isosurface(Ps, isovalue);
verts(:,1) = verts(:,1) * res(1);
verts(:,2) = verts(:,2) * res(2);
verts(:,3) = verts(:,3) * res(3);
p = patch('Vertices', verts, 'Faces', faces, ... 
    'FaceColor', colorBone, ... 
    'edgecolor', 'none');
isonormals(P, p);
% toc
% pm.FaceColor = colorBone;
% pm.EdgeColor = 'none';
%p.LineStyle = ':';
%p.LineWidth = 0.1;
% colormap bone
daspect([1,1,1])
view(3);
axis vis3d
camlight
lighting flat
