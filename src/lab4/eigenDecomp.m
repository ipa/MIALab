function [inputMean, eVals,eVecs]=eigenDecomp(S)

inputMean = mean(S, 2);

numberOfSamples = size(S, 2);

% Represent the shapes as distances from the mean shape
M = S - repmat(inputMean, 1, numberOfSamples);
% Compute eigen-vectors and eigen-values of the covariance matrix of M
% using SVD decomposition
% Remember, in this method, the covariance matrix of M does not have to be
% computed. SVD of results in the eigen-vectors and eigen-values of its
% covariance matrix.

[PCA_U, PCA_W, PCA_V] = svd(M, 0);

% Rearrange and scale the terms
PCA_U = PCA_U(:, 1:end-1);
PCA_W = PCA_W(1:end-1, 1:end-1);
eig_PCA = diag(PCA_W* PCA_W') / (numberOfSamples-1);


% Store the results in properly named variables
eVals = eig_PCA;
eVecs = PCA_U;