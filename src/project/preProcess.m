function imageOut=preProcess(image)
imageN = imageNormalize(image);
% wiener filtering
imageOut=wiener3(imageN);
%include here other preprocessing steps
%imageOut=median3(imageOut);


