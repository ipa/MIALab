function viewImage(image,voxelSize)

%% image visualization
[x,y,z] = meshgrid(1*voxelSize(1):voxelSize(2):size(image,2)*voxelSize(1),1*voxelSize(1):voxelSize(1):size(image,1)*voxelSize(1),1*voxelSize(3):voxelSize(3):size(image,3)*voxelSize(3));
xslice = []; yslice = []; zslice =[40];
h=slice(x,y,z,double(image),xslice,yslice,zslice);
set(h,'EdgeColor','none');
colormap(gray);
view([0,0,1]);axis tight; axis equal;