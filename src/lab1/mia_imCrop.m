function [ Icrop ] = mia_imCrop( I, xMin, xMax, yMin, yMax )
%MIA_IMCROP crops the image in to xMin:xMax, yMin:yMax
%   MIA_IMCROP(A, xMin, xMax, yMin, yMax) 
    Icrop = I(xMin:xMax, yMin:yMax, :);
end

