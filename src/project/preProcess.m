function imageOut=preProcess(image)

% wiener filtering
imageOut=wiener3(image);
%include here other preprocessing steps
%imageOut=median3(imageOut);


