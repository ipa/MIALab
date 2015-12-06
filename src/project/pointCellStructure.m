%finds all cells per point. Uses a structure to store cells as the number can change
% f=faces
%v= point coordinates
function point2CellStr=pointCellStructure(f,v)

%traverse all points "p" on v, and find cells using it.
for p=1:size(v,1)
    
    [cellindex,~]=find(f==p);

    point2CellStr{p}=cellindex;

end
