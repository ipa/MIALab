%% Medical Image Analysis Lab
% Author: Iwan Paolucci, Severin Tobler

%% Prepare
clear; close all; clc;
addpath(genpath('../libs'));
%% Load Data
myImage_path='../../data/';

% voxelSize=[1.2,1.2,1.2];
% origin=[-37.888,-21.483,148.563];

proportionSamples=0.01;
numTrees=15;
nimages=1:15;
minLeaf = 1;

features = struct('Std', 1, 'Avg', 1, 'Ent', 1, 'Pos', 0, 'RelPos', 1, ...
                  'Gauss', 1, 'LoG', 1, 'Ske', 0, 'Sobel', 1, ...
                  'Prewitt', 1, 'Laplacian', 1, 'Hist', 0, 'Canny', 0);
              % additional features histogram bins with prctile function from matlab
              

%% Read images, preprocess and extract features
[X, Y]=extractFeaturesParallel(myImage_path, nimages, proportionSamples, features);

%% Reduce dim
% K = 4;
% [ mu, s, principals, princvalues ] = pca_train( X );
% Xn = pca_project(X, mu, s, principals, K );

%% Train a decision tree model
options = statset('UseParallel', true);
treeModel = TreeBagger(numTrees,X,Y,'MinLeaf',minLeaf, 'Options', options);
disp('---Model built');

%save model to file
%save(strcat('treeModelEntropy_ntrees',num2str(numTrees),'_nimages',num2str(nimages),'.mat'),'treeModel','-v7.3'); %v7.3 is to be able to save large variables
%% Check quality of model with a cross-evaluation

% for minLeaf = 1:5:20
%     treeModel = TreeBagger(numTrees,X,Y,'OOBPred','On','oobvarimp','on','MinLeaf',minLeaf);
%     disp('---Model built');
%     oobErrorBaggedEnsemble = oobError(treeModel);
%     oobPermutedVarDeltaError = treeModel.OOBPermutedVarDeltaError;

%     save(strcat('treeModel_', minLeaf, '_', features.Std, '_', features.Avg, '_', features.Ent, '_', ...
%         features.Pos, '_',features.Gauss, '_',features.LoG, '_oobError.mat'), 'oobErrorBaggedEnsemble');
% 
%     save(strcat('treeModel_', minLeaf, '_', features.Std, '_', features.Avg, '_', features.Ent, '_', ...
%         features.Pos, '_',features.Gauss, '_',features.LoG, '_oobPermutedVarDeltaError.mat'), 'oobPermutedVarDeltaError');
% end
% figure
% plot(oobErrorBaggedEnsemble)
% xlabel 'Number of grown trees';
% ylabel 'Out-of-bag classification error';

% figure
% bar(treeModel.OOBPermutedVarDeltaError);

%% Extract feature
% [Xs] = extractFeatures([myImage_path, 'image-016.mhd'], features);
% 
% prediction = treeModel.predict(Xs);
% 
% Pm = uint8(cell2mat(prediction)) - 48;
% P = reshape(Pm, [301 339 11]);
% Pg = mat2gray(P);
% 
% figure
% for i = 1:11
%    imshow(Pg(:,:,i));
%    pause(1);
% end

% prediction = zeros(size(Xs,1));
% s = size(Xs, 1);
% for n = 1:s/10
%     begin = n*(s/10);
%     bend = begin + (s/10);
%     prediction(begin:bend) = treeModel.predict(Xs(begin:bend,:));
% end

%% Train Neural Network
% Create a Pattern Recognition Network
% hiddenLayerSize = 1;
% net = patternnet(hiddenLayerSize);
% 
% 
% % Set up Division of Data for Training, Validation, Testing
% net.divideParam.trainRatio = 70/100;
% net.divideParam.valRatio = 15/100;
% net.divideParam.testRatio = 15/100;
% 
% 
% % Train the Network
% [net,tr] = train(net,X',Y');
% 
% % Test the Network
% outputs = net(X');
% errors = gsubtract(Y',outputs);
% performance = perform(net,Y',outputs)
% 
% % View the Network
% view(net)
% 
% % Plots
% % Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, plotconfusion(Y',outputs)
% figure, ploterrhist(errors)