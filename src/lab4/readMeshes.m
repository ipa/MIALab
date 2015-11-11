function [S,fv]=readMeshes(path2LeftMeshes)

S=[];
fv=struct('vertices',[],'faces',[]);

currentDir=pwd;
%cd(path2LeftMeshes);
meshesDir = [currentDir, '/', path2LeftMeshes, '/'];

data = dir([meshesDir, '*.obj']);   

for i = 1:length(data)

    filename = data(i).name; 
    FV=read_wobj([meshesDir, filename]);
    fv.vertices=FV.vertices;
    fv.faces=FV.faces;
  
   S(:,i)=reshape(fv.vertices,size(fv.vertices,1)*3,1);
  
end

%cd(currentDir);

