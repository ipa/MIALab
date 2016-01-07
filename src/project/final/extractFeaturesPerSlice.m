function [X]=extractFeaturesPerSlice(myImage, features, slice)
%% EXTRACTFEATURESSINGLEIMAGE

%% preprocess image

totalSlices = size(myImage, 3); % to calculate rel posistion
myImage = myImage(:,:,slice);

myImage = preProcess(myImage);

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

h = fspecial('average');
g = fspecial('gaussian');
l = fspecial('log');
s = fspecial('sobel');
p = fspecial('prewitt');
lp = fspecial('laplacian');
for k=1:Kf
    if (features.Avg); imgAv(:,:,k)= imfilter(myImage(:,:,k),h); end
    if (features.Std); imgStd(:,:,k) = stdfilt(myImage(:,:,k)); end
    if (features.Ent); imgEnt(:,:,k)=entropyfilt(myImage(:,:,k)); end
    if (features.Gauss); imgGauss(:,:,k)=imfilter(myImage(:,:,k),g); end
    if (features.LoG); imgLoG(:,:,k)=imfilter(myImage(:,:,k),l); end
    if (features.Ske); imgSke(:,:,k) = colfilt(myImage(:,:,k),[3 3], 'sliding', @skewness); end
    if (features.Sobel);
        imSobel(:,:,k)=imfilter(myImage(:,:,k),s);
        imSobelv(:,:,k)=imfilter(myImage(:,:,k),s');
    end
    if (features.Prewitt);
        imPrewitt(:,:,k)=imfilter(myImage(:,:,k),p);
        imPrewittv(:,:,k)=imfilter(myImage(:,:,k),p');
    end
    if (features.Laplacian); imLaplacian(:,:,k)=imfilter(myImage(:,:,k),lp); end
end

idx = 1;

if (features.Avg); X(:,idx) = imgAv(:); idx = idx + 1; end
if (features.Std); X(:,idx) = imgStd(:); idx = idx + 1; end
if (features.Ent); X(:,idx) = imgEnt(:); idx = idx + 1; end

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

if (features.Gauss); X(:,idx) = imgGauss(:); idx = idx + 1; end
if (features.LoG); X(:,idx) = imgLoG(:); idx = idx + 1; end
if features.Ske; X(:,idx) = imgSke(:); idx = idx + 1; end
if (features.Sobel);
    X(:,idx) = imSobel(:); idx = idx + 1;
    X(:,idx) = imSobelv(:); idx = idx + 1;
end
if (features.Prewitt); 
    X(:,idx) = imPrewitt(:); idx = idx + 1;
    X(:,idx) = imPrewittv(:); idx = idx + 1;
end
if (features.Laplacian); X(:,idx) = imLaplacian(:); idx = idx + 1; end

end