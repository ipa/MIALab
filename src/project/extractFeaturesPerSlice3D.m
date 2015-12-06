function [X]=extractFeaturesPerSlice(myImage, features, slice)
%% EXTRACTFEATURESSINGLEIMAGE
% features = struct('Std', 1, 'Avg', 1, 'Ent', 1, 'Pos', 0, 'RelPos', 1, ...
%                  'Gauss', 0, 'LoG', 0);

% preprocess image

totalSlices = size(myImage, 3); % to calculate rel posistion
myImage = myImage(:,:,slice);
%display(size(myImage));

% disp('----preprocessing image');
myImage=preProcess(myImage);

% disp('----extracting features from image...');
[If,Jf,Kf] = size(myImage);
nSamples = If * Jf * length(slice);
%init array to hold sample values
nFeatures = sum([features.Avg, features.Gauss, features.LoG, features.Ent ...
    features.Pos*3, features.RelPos*3, features.Std, features.Sobel*2, ...
    features.Prewitt*2, features.Laplacian, features.Ske]);

X = zeros(nSamples, nFeatures);

% Compute Features
if (features.Avg); imgAv = zeros(size(myImage)); end
if (features.Std); imgStd = zeros(size(myImage)); end
if (features.Ent); imgEnt = zeros(size(myImage)); end
if (features.Gauss); imgGauss = zeros(size(myImage)); end
if (features.LoG); imgLoG = zeros(size(myImage)); end
if (features.Ske); imgSke = zeros(size(myImage)); end
if (features.Sobel);
    imSobel = zeros(size(myImage));
    imSobelv = zeros(size(myImage));
end
if (features.Prewitt);
    imPrewitt = zeros(size(myImage));
    imPrewittv = zeros(size(myImage));
end
if (features.Laplacian); imLaplacian = zeros(size(myImage)); end
voxelSize=[0.3906 0.3906 1];
h = adjustFilter(fspecial3('average',[3 3 3]));
g = adjustFilter(fspecial3('gaussian',[3 3 3]));
% l = fspecial('log');
l = fspecial3('log',[5 5 5]);
s = fspecial('sobel');
p = fspecial('prewitt');
% lp = fspecial('laplacian');
lp = adjustFilter(fspecial3('laplacian',[3 3 3]));
if (features.Avg); imgAv= imfilter(myImage,h); end
if (features.Gauss); imgGauss=imfilter(myImage,g); end
if (features.LoG); imgLoG=imfilter(myImage,l); end
if (features.Laplacian); imLaplacian=imfilter(myImage,lp); end
for k=1:Kf
%     if (features.Avg); imgAv(:,:,k)= imfilter(myImage(:,:,k),h); end
    if (features.Std); imgStd(:,:,k) = stdfilt(myImage(:,:,k)); end
    if (features.Ent); imgEnt(:,:,k)=entropyfilt(myImage(:,:,k)); end
%     if (features.Gauss); imgGauss(:,:,k)=imfilter(myImage(:,:,k),g); end
%     if (features.LoG); imgLoG(:,:,k)=imfilter(myImage(:,:,k),l); end
    if (features.Ske); imgSke(:,:,k) = colfilt(myImage(:,:,k),[3 3], 'sliding', @skewness); end
    if (features.Sobel);
        imSobel(:,:,k)=imfilter(myImage(:,:,k),s);
        imSobelv(:,:,k)=imfilter(myImage(:,:,k),s');
    end
    if (features.Prewitt);
        imPrewitt(:,:,k)=imfilter(myImage(:,:,k),p);
        imPrewittv(:,:,k)=imfilter(myImage(:,:,k),p');
    end
%     if (features.Laplacian); imLaplacian(:,:,k)=imfilter(myImage(:,:,k),lp); end
end

disp('----building feature vector for samples...');
idx = 1;
%k = median(1:Kf);
X(:,idx) = imgAv(:); idx = idx + 1;
% X(:,idx) = imgStd(:); idx = idx + 1;
% X(:,idx) = imgEnt(:); idx = idx + 1;
%X(:,4) = repelem((1:size(myImage,1)) / size(myImage,1), size(myImage, 2));
for i = 0:size(myImage, 2)-1
   X(i*size(myImage, 1)+1:(i+1)*size(myImage, 1), idx) = ...
       (1:size(myImage,1)) / size(myImage,1);
end
idx = idx + 1;
X(:,idx) = my_repelem(((1:size(myImage,2)) / size(myImage,2))', ...
    size(myImage, 1)*length(slice)); ...
     idx = idx + 1;
X(:,idx) = my_repelem(slice/totalSlices, size(myImage, 2)*size(myImage, 1)); ...
    idx = idx + 1;
%slice/totalSlices; idx = idx + 1;
X(:,idx) = imgGauss(:); idx = idx + 1;
%X(:,idx) = imgLoG(:); idx = idx + 1;
if features.Ske; X(:,idx) = imgSke(:); idx = idx + 1; end
% X(:,idx) = imSobel(:); idx = idx + 1;
% X(:,idx) = imSobelv(:); idx = idx + 1;
% X(:,idx) = imPrewitt(:); idx = idx + 1;
% X(:,idx) = imPrewittv(:); idx = idx + 1;
X(:,idx) = imLaplacian(:); idx = idx + 1;

end

function h = adjustFilter(f)
voxelSize=[0.3906 0.3906 1];
if size(f,1) == 3
    h = zeros(7, 7, 7);
    h(1,1,3) = f(1,1,1);
    h(1,4,3) = f(1,2,1);
    h(1,7,3) = f(1,3,1);
    h(4,1,3) = f(2,1,1);
    h(4,4,3) = f(2,2,1);
    h(4,7,3) = f(2,3,1);
    h(7,1,3) = f(3,1,1);
    h(7,4,3) = f(3,2,1);
    h(7,7,3) = f(3,3,1);
    
    h(1,1,4) = f(1,1,2);
    h(1,4,4) = f(1,2,2);
    h(1,7,4) = f(1,3,2);
    h(4,1,4) = f(2,1,2);
    h(4,4,4) = f(2,2,2);
    h(4,7,4) = f(2,3,2);
    h(7,1,4) = f(3,1,2);
    h(7,4,4) = f(3,2,2);
    h(7,7,4) = f(3,3,2);
    
    h(1,1,5) = f(1,1,3);
    h(1,4,5) = f(1,2,3);
    h(1,7,5) = f(1,3,3);
    h(4,1,5) = f(2,1,3);
    h(4,4,5) = f(2,2,3);
    h(4,7,5) = f(2,3,3);
    h(7,1,5) = f(3,1,3);
    h(7,4,5) = f(3,2,3);
    h(7,7,5) = f(3,3,3);
end
end