%%computes the dice coefficient between two images. "Value" serves to compute
%%the dice on masks with different scalars (e.j after a label connected
%%operation)

function d=dicecoeff(im1,im2,value) 

inter=0.0;
cardIm1=0.0;
cardIm2=0.0;


dim=size(im1); %assuming im2's size is the same as im1

for i=1:dim(1)
    for j=1:dim(2)
       for k=1:dim(3)
           
        if im1(i,j,k)==value;
           cardIm1=cardIm1+1;
        end

        %measure cardinality of im2
        if im2(i,j,k)==value;
           cardIm2=cardIm2+1;
        end

      %measure intersection of images
        if (im1(i,j,k)==value) && (im2(i,j,k)==value);
           inter=inter+1;
        end
end
end
end


d=2.0*inter/(cardIm1+cardIm2);

