 %searches for strong edges along the search profile on myImageEdge image
 
 % currShape:shape used to sample along normal
 % pointNormals: set of normals 
 %search_range, search_samples: how long and how many samples
 
function Y=searchProfileGridInterp(myImageEdge,currShape,pointNormals,search_range,search_samples,voxelSize)

Y=zeros(size(currShape,1),3);

%gridInterpolant is a matlab function to perform a (cubic) interpolation using a
%grid (myImageEdge)
F = griddedInterpolant(myImageEdge, 'nearest');

%step size of sampling
deltarange=search_range/search_samples;

% traverse each point on shape currShape
for i=1:size(currShape,1)
     pos=currShape(i,:);
     normal=pointNormals(i,:);
     k=1;
     newpos_voxel=zeros(search_samples*2+1,3); %number of samples is 2Xnsamples plus the central sample (2n+1)
     newpos=zeros(search_samples*2+1,3);
    
     %creating profile line
      for j=-search_samples:search_samples
           newpos(k,:)=pos+j*deltarange*normal;
           newpos_voxel(k,:)=euclidean2voxel(voxelSize,newpos(k,:)); %go back to the image space to sample the intensities.
           k=k+1;
      end
     %use the interpolant to extract intensities. 
    intensities=F(newpos_voxel);
    [~,I]=max(intensities);%capture highest gradient
    Y(i,:)=newpos(I,:); %update position of points in Y.
end
    
    
    
    