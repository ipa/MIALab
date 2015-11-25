%finds faces sharing point index, then computes average normal on neighboring faces
function [normal]=pointnormal(point_index,f,v,point2Cell)

%finds all faces using point_index
cells=point2Cell{point_index};
n=[];
for fi=1:size(cells,1)
    %p holds set of points per face, each point per row (p(1), p(2), p(3))
    p=v(f(cells(fi),:),:);
    n=[n;[cross(p(3,:)-p(1,:),p(2,:)-p(1,:))]];
end

normal=mean(n,1);
normal=normal./norm(normal);