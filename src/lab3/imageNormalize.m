%normalize image using z-score
function imageOut=imageNormalize(imageOut)

m=mean(imageOut(:));
s=std(imageOut(:));

imageOut=(imageOut-m)./s;


