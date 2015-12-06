function posVox=euclidean2voxel(voxelsize,posEu)

posVox(1) = double(posEu(1))/voxelsize(1);
posVox(2) = double(posEu(2))/voxelsize(2);
posVox(3) = double(posEu(3))/voxelsize(3);

