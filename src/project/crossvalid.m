%% Medical Image Analysis Lab
% Author: Iwan Paolucci, Severin Tobler

%% Prepare
clear; close all; clc;
addpath(genpath('../libs'));
%% Load Data
myImage_path='../../data/';

proportionSamples=0.01;
numTrees=15;
minLeaf = 1;

features = struct('Std', 1, 'Avg', 1, 'Ent', 1, 'Pos', 0, 'RelPos', 1, ...
                  'Gauss', 1, 'LoG', 1, 'Ske', 0, 'Sobel', 1, ...
                  'Prewitt', 1, 'Laplacian', 1, 'Hist', 0, 'Canny', 0);

N = 20;
K = 5;
rng(0);
nimages = crossvalind('Kfold', N, K)';

dicesp = zeros(ceil(N/K), K);
dicespp = zeros(ceil(N/K), K);
% rocs = zeros(3, K);
for i = 1:K
fprintf('Validate with K = %d\n', i);
ntest = find(nimages == i);
ntrain = find(nimages ~= i);
disp('extract features');
[X, Y]=extractFeaturesParallel(myImage_path, ntrain, proportionSamples, features);

disp('build model');
options = statset('UseParallel', true);
treeModel = TreeBagger(numTrees,X,Y,'MinLeaf',minLeaf, 'Options', options);
treeModel = treeModel.compact();
clear X Y;
% disp('---Model built');

for j = 1:length(ntest)
    fprintf('Segmenting image %d\n', j);
    nim = ntest(j);
    path2image = [myImage_path, sprintf('image-%03.f.mhd', nim) ];
    path2label = [myImage_path, sprintf('labels-%03.f.mhd', nim)];
    myImage=mha_read_volume(path2image);
    myLabel=mha_read_volume(path2label);
    myLabel = logical(myLabel == 1);
    
    [Pp, Ps] = predictImage(treeModel, myImage, features);
    dicesp(j, i) = dice(Pp, myLabel);
    [Ppp] = postprocessPrediction(Ps);
    dicespp(j, i) = dice(Ppp, myLabel);
    
    fprintf('segmented with dice %f\n', dicespp(j, i));
    
    save(sprintf('results/crossvd/Ps-%03.f.mat', j), 'Ps');
end

save(sprintf('results/crossvd/treeModel-cv%d.mat', i), 'treeModel', 'features');

end

save('results/crossvd/dices.mat', 'dicesp', 'dicespp');
