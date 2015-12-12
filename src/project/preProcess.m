function imageOut=preProcess(image)

image = mat2gray(image);

imageN = imageNormalize(image);
% imageN = mat2gray(imageN);
% wiener filtering
imageOut=wiener3(imageN);
%include here other preprocessing steps
%imageOut=median3(imageOut);

% figure; viewImage(mat2gray(image), [0.3906    0.3906    1.0000]);
% figure; viewImage(image, [0.3906    0.3906    1.0000]);
% figure; viewImage(imageN, [0.3906    0.3906    1.0000]);
% figure; viewImage(imageOut, [0.3906    0.3906    1.0000]);
% 
% imwrite(mat2gray(imageN(:,:,40)), '../../doc/results/imnormalized.png');
% imwrite(mat2gray(imageOut(:,:,40)), '../../doc/results/imwienered.png');

end