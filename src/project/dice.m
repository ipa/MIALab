function [ DICE ] = dice(img1, img2)
%      Dice Coef = 2*intersect(A,B)/(absolute(A)+absolute(B))


union = nnz(img1) + nnz(img2);

if union == 0 % if both labels are empty
   DICE = 1;
   return;
end

DICE = 2 * nnz(img1 & img2) / (union);

end