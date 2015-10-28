%% Medical Image Analysis Lab
% Author: Iwan Paolucci, Severin Tobler

%% Prepare
clear; close all; clc;
addpath(genpath('../libs'));
myImage_path='../../data/';

voxelSize=[1.2,1.2,1.2];
origin=[-37.888,-21.483,148.563];
proportionSamples=0.001;
numTrees=12;
nimages=7;

features = struct('Std', 1, 'Avg', 1, 'Ent', 1, 'Pos', 0, 'RelPos', 1, ...
                  'Gauss', 1, 'LoG', 1, 'Ske', 1);
              % additional features histogram bins with prctile function from matlab

%% Read images, preprocess and extract features
[X, Y]=extractFeaturesParallel(myImage_path, nimages, proportionSamples, features);
% [X, Y] = extractFeaturesSingleImage([myImage_path, 'image-001.mhd'], [myImage_path, 'labels-001.mhd'], proportionSamples, features);

%% Train a decision tree model
treeModel = TreeBagger(numTrees,X,Y,'OOBPred','On','oobvarimp','on');
disp('---Model built');
%save model to file
%save(strcat('treeModelEntropy_ntrees',num2str(numTrees),'_nimages',num2str(nimages),'.mat'),'treeModel','-v7.3'); %v7.3 is to be able to save large variables
%% Check quality of model with a cross-evaluation
oobErrorBaggedEnsemble = oobError(treeModel);

figure
plot(oobErrorBaggedEnsemble)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';

figure
bar(treeModel.OOBPermutedVarDeltaError);
