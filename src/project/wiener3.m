% 3D version (slice-wise) wiener filtering of volumetric image
function imOut=wiener3(image)
imOut=zeros(size(image));
for i=1:size(image,3)
    imOut(:,:,i)=wiener2(image(:,:,i),[ 5 5]);   
end
