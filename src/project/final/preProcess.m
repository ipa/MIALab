function imageOut=preProcess(image)

image = mat2gray(image);
imageN = imageNormalize(image);
imageOut=wiener3(imageN);

end