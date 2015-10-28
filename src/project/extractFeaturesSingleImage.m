function [X,Y]=extractFeaturesSingleImage(path2Image, path2LabelImage, proportionSamples, features)
%% EXTRACTFEATURESSINGLEIMAGE
% features = struct('Std', 1, 'Avg', 1, 'Ent', 1, 'Pos', 0, 'RelPos', 1, ...
%                  'Gauss', 0, 'LoG', 0, 'Ske', 1);

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
    features.Pos*3, features.RelPos*3, features.Std, features.Ske]);

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

h = fspecial('average');
g = fspecial('gaussian');
l = fspecial('log');
for k=1:size(myImage,3)
    if (features.Avg); imgAv(:,:,k)= imfilter(myImage(:,:,k),h); end
    if (features.Std); imgStd(:,:,k) = stdfilt(myImage(:,:,k)); end
    if (features.Ent); imgEnt(:,:,k)=entropyfilt(myImage(:,:,k)); end
    if (features.Gauss); imgGauss(:,:,k)=imfilter(myImage(:,:,k),g); end
    if (features.LoG); imgLoG(:,:,k)=imfilter(myImage(:,:,k),l); end
    if (features.Ske); imgSke(:,:,k) = colfilt(myImage(:,:,k),[3 3], 'sliding', @skewness); end
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
    
    Yf(j) = 1;
    Yb(j) = 0;
end


X = [Xf; Xb];
Y = [Yf; Yb];