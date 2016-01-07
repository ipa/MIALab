function [p] =  visualizeVolume( P, Ps, voxelSize )
%VISUALIZEVOLUME Visualizes the volume using marching cubes

Psmooth = smooth3(P .* Ps, 'box', 7);

figure(10); clf
isovalue = 0.5;
colorBone = [0.8824    0.8314    0.7529];
[faces, verts] = isosurface(Psmooth, isovalue);
verts(:,1) = verts(:,1) * voxelSize(1);
verts(:,2) = verts(:,2) * voxelSize(2);
verts(:,3) = verts(:,3) * voxelSize(3);
[nf, nv] = reducepatch(faces, verts, 0.2);
p = patch('Vertices', nv, ...
    'Faces', nf, ... 
    'FaceColor', colorBone, ... 
    'EdgeColor', 'none');
isonormals(Psmooth, p);
view([137,40]);
axis vis3d
camlight('headlight')
material('dull');


end

