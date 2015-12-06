function [ mu, sigma, principals, princvalues ] = pca_train( x )

n = size(x,2);

% normalize data
mu = mean(x,2);
xc = bsxfun( @plus, x, -mu );
sigma = sqrt( sum( xc.^2, 2 ) / n );
xn = bsxfun( @times, xc, 1./sigma );

% principal components
%[principals,S,~] = svd(xn*xn');
[principals, ~, princvalues] = pca(xn, 'Centered', false);
% princvalues = diag(S);
% princvalues

end

