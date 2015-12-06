% projects Y into model shape and output corresponding shape as shape
function shape=shapeUpdate(Y,transform,eVals,eVecs,meanShape)

    % move back to the space of the SSM model
    % reminder from procrustes. [D, Z, TRANSFORM] = procrustes(X, Y)
    % Transform Y (outputs Z) so it fits X
    %  Z = TRANSFORM.b * Y * TRANSFORM.T + TRANSFORM.c.
    S = ((Y-transform.c)/transform.T)/transform.b;
   
   %project S shape into shape space and compute b 
    S1D=reshape(S,size(S,1)*3,1);
    eVeVal=eVecs*diag(sqrt(eVals));
    b= pinv(eVeVal)*(S1D-meanShape);
    disp(strcat('Norm of b:',num2str(norm(b./((sqrt(eVals)))))));
    for i=1:size(b,1)
        if(b(i)>3)
            b(i)=3;
        end
        if(b(i)<-3)
            b(i)=-3;
        end
        
    end
       
    sample1D=drawSample(b,meanShape,eVals,eVecs);
    sample=reshape(sample1D,size(sample1D,1)/3,3);

    % reaply T transform to move shape to image space.  
    shape=transform.b*sample*transform.T+transform.c;
    
    