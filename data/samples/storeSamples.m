clear all;
myImage_path='/Users/Severin/_Uni Bern/3. Semester/Medical Image Analysis Lab/Data/';
voxelSize=[1.2,1.2,1.2];
origin=[-37.888,-21.483,148.563];

% loop through each image
path2InputImages=strcat(myImage_path,'image*.mhd');

dirlist_InputImages = dir(path2InputImages);

for i = 1:20 

    path2Image=strcat(myImage_path,dirlist_InputImages(i).name);
    
% blablabla

    myImage = mha_read_volume(path2Image);
    myImage = mat2gray(myImage(:,:,round(end/2)));
    imwrite(myImage, ['image' num2str(i) '.png']);
end