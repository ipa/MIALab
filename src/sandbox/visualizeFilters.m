% Gaussian
g = fspecial('gaussian',[50,50],8.33);
g = mat2gray(g);

% Average
h = ones(50,50)/9;
h = mat2gray(h,[-1,1]);

% Laplacian of Gaussian
l = fspecial('log',[50,50],8.33);
l = mat2gray(l);

% Sobel
% [1 2 1;0 0 0;-1 -2 -1]
s = fspecial('sobel');
s = mat2gray(s);
s = imresize(s,50/3,'nearest');

% Prewitt
% [1 1 1;0 0 0;-1 -1 -1]
p = fspecial('prewitt');
p = mat2gray(p);
p = imresize(p,50/3,'nearest');

% Lablacian
lp = fspecial('laplacian');
lp = mat2gray(lp);
lp = imresize(lp,50/3);

vSpace = ones(50, 5);
hSpace = ones(5, 2*50+5);
im = [g,vSpace,h; hSpace; l,vSpace,lp; hSpace; p,vSpace,p'; hSpace; s,vSpace,s'];

f = figure;
imshow(im);
colormap hot;
print(f, '../../doc/results/Filters', '-depsc');   