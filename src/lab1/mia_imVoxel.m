function [ average, variance ] = mia_imVoxel( I, x, y, z )
%MIA_IMVOXEL Computes the average and the variance of a voxel
%   mia_imVoxel(I, x, y, z) computes the average and the variance
%   of a 3x3x3 volume around the voxel at position x, y, z.
    voxel = I(x-1:x+1, y-1:y+1, z-1:z+1);
   
    average = mean(voxel(:));
    variance = var(voxel(:));
end

