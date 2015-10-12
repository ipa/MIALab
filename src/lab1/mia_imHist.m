function [histogram] = mia_imHist( I )
%MYHIST Summary of this function goes here
%   Detailed explanation goes here

histogram = zeros(4095, 1);
sizeI = size(I,1);
sizeJ = size(I,2);

for i = 1:sizeI
    for j = 1:sizeJ
        histogram(I(i,j)) = histogram(I(i,j)) + 1;
    end
end

bar(histogram);

end


