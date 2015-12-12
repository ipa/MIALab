function [X,Y]=extractFeaturesSingleImage(path2Image, path2LabelImage, proportionSamples, features)
%% EXTRACTFEATURESSINGLEIMAGE
% features = struct('Std', 1, 'Avg', 1, 'Ent', 1, 'Pos', 0, 'RelPos', 1, ...
%                  'Gauss', 0, 'LoG', 0, 'Ske', 1);
global edges;
myImage=mha_read_volume(path2Image);
% preprocess image

disp('----preprocessing image');
myImage=preProcess(myImage);
%Read label image so we sample on "femur" tissues
myImageLabel=mha_read_volume(path2LabelImage);

%Extract voxel values with class 1 (femur)
I=find(myImageLabel==1);
[If,Jf,Kf]=ind2sub(size(myImage),I);

%do the same for non femur bone
I=find(myImageLabel~=1);
[Ib,Jb,Kb]=ind2sub(size(myImage),I);

disp('----selecting samples from image...');
%take a proportion for both background and foreground samples and store per row
nsamples = round(proportionSamples*size(If,1));
samplesForeground = datasample([If,Jf,Kf],nsamples);
samplesBackground = datasample([Ib,Jb,Kb],nsamples);

%init array to hold sample values
nFeatures = sum([features.Avg, features.Gauss, features.LoG, features.Ent ...
    features.Pos*3, features.RelPos*3, features.Std, features.Ske, features.Sobel*2, ...
    features.Prewitt*2, features.Laplacian, features.Hist*5, features.Canny]);

Xf = zeros(size(samplesForeground,1), nFeatures);
Xb = zeros(size(Xf));
Yf = zeros(size(samplesForeground,1), 1);
Yb = zeros(size(Yf));

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
if (features.Hist); imgHist = zeros(size(myImage,1),size(myImage,2),size(myImage,2),5); end
if (features.Canny); imgCanny = zeros(size(myImage)); end;

h = fspecial('average');
g = fspecial('gaussian');
l = fspecial('log');
s = fspecial('sobel');
p = fspecial('prewitt');
lp = fspecial('laplacian');
ge = fspecial('gaussian', 10, 3);
edges = prctile(myImage(:),[20,40,60,80]);
for k=1:size(myImage,3)
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
    if (features.Hist);
        imgHist(:,:,k,1)=colfilt(myImage(:,:,k),[5 5], 'sliding', @h1);
        imgHist(:,:,k,2)=colfilt(myImage(:,:,k),[5 5], 'sliding', @h2);
        imgHist(:,:,k,3)=colfilt(myImage(:,:,k),[5 5], 'sliding', @h3);
        imgHist(:,:,k,4)=colfilt(myImage(:,:,k),[5 5], 'sliding', @h4);
        imgHist(:,:,k,5)=colfilt(myImage(:,:,k),[5 5], 'sliding', @h5);
    end
    if (features.Canny); imgCanny(:,:,k) = imfilter(edge(myImage(:,:,k), 'canny'), ge); end;
end

disp('----building feature vector for samples...');
for j = 1:size(samplesForeground, 1)
    idx = 1;
    if features.Avg
        Xf(j,idx) = imgAv(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3));
        Xb(j,idx) = imgAv(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3));
        idx = idx + 1;
    end
    
    if features.Std
        Xf(j,idx) = imgStd(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3));
        Xb(j,idx) = imgStd(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3));
        idx = idx + 1;
    end
    
    if features.Ent
        Xf(j,idx) = imgEnt(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3));
        Xb(j,idx) = imgEnt(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3));
        idx = idx + 1;
    end
    
    if features.Pos
        Xf(j,idx:idx+2) = [samplesForeground(j,1), samplesForeground(j,2), samplesForeground(j,3)];
        Xb(j,idx:idx+2) = [samplesBackground(j,1), samplesBackground(j,2), samplesBackground(j,3)];
        idx = idx + 3;
    end
    
    if features.RelPos
        Xf(j,idx:idx+2) = [samplesForeground(j,1)/size(myImage,1), samplesForeground(j,2)/size(myImage,2), samplesForeground(j,3)/size(myImage,3)];
        Xb(j,idx:idx+2) = [samplesBackground(j,1)/size(myImage,1), samplesBackground(j,2)/size(myImage,2), samplesBackground(j,3)/size(myImage,3)];
        idx = idx + 3;
    end
    
    if features.Gauss
        Xf(j,idx) = imgGauss(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3));
        Xb(j,idx) = imgGauss(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3));
        idx = idx + 1;
    end
    
    if features.LoG
        Xf(j,idx) = imgLoG(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3));
        Xb(j,idx) = imgLoG(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3));
        idx = idx + 1;
    end
    
    if features.Ske
        Xf(j,idx) = imgSke(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3));
        Xb(j,idx) = imgSke(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3));
        idx = idx + 1;
    end

    if features.Sobel
        Xf(j,idx) = imSobel(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3));
        Xb(j,idx) = imSobel(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3));
        idx = idx + 1;
        Xf(j,idx) = imSobelv(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3));
        Xb(j,idx) = imSobelv(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3));
        idx = idx + 1;
    end
    
    if features.Prewitt
        Xf(j,idx) = imPrewitt(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3));
        Xb(j,idx) = imPrewitt(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3));
        idx = idx + 1;
        Xf(j,idx) = imPrewittv(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3));
        Xb(j,idx) = imPrewittv(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3));
        idx = idx + 1;
    end
    
    if features.Laplacian
        Xf(j,idx) = imLaplacian(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3));
        Xb(j,idx) = imLaplacian(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3));
        idx = idx + 1;
    end
    
    if features.Hist
        Xf(j,idx) = imgHist(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3),1);
        Xb(j,idx) = imgHist(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3),1);
        idx = idx + 1;
        Xf(j,idx) = imgHist(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3),2);
        Xb(j,idx) = imgHist(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3),2);
        idx = idx + 1;
        Xf(j,idx) = imgHist(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3),3);
        Xb(j,idx) = imgHist(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3),3);
        idx = idx + 1;
        Xf(j,idx) = imgHist(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3),4);
        Xb(j,idx) = imgHist(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3),4);
        idx = idx + 1;
        Xf(j,idx) = imgHist(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3),5);
        Xb(j,idx) = imgHist(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3),5);
        idx = idx + 1;
    end
    
    if features.Canny
        Xf(j,idx) = imgCanny(samplesForeground(j,1),samplesForeground(j,2),samplesForeground(j,3));
        Xb(j,idx) = imgCanny(samplesBackground(j,1),samplesBackground(j,2),samplesBackground(j,3));
        idx = idx + 1;
    end
    
    Yf(j) = 1;
    Yb(j) = 0;
end


X = [Xf; Xb];
Y = [Yf; Yb];
end

function h = h1(v)
global edges;
h = sum(v<edges(1));
end
function h = h2(v)
global edges;
h = sum((edges(1)<=v)<edges(2));
end
function h = h3(v)
global edges;
h = sum((edges(2)<=v)<edges(3));
end
function h = h4(v)
global edges;
h = sum((edges(3)<=v)<edges(4));
end
function h = h5(v)
global edges;
h = sum(edges(4)<=v);
end