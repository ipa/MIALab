function x2 = pca_project( x, mu, s, principals, K )

% normalization
xc = bsxfun( @plus, x, -mu );
xn = bsxfun( @times, xc, 1./s );

% project to principal components
x2 = principals(:,1:K)' * xn';
x2 = x2';
end

