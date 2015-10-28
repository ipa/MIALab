
function X=extractFeaturesImageEvaluation(myImage,nfeatures)

    % preprocess image
    dim=size(myImage);
    
    disp('----preprocessing image');
    myImage=preProcess(myImage);
        
    %init array to hold sample values
    X=zeros(dim(1)*dim(2)*dim(3),nfeatures); %nfeatures (av, std, entropy, etc..)
    
    %compute feature images
    switch nfeatures
        case 1
            imgAv=zeros(size(myImage));
            h = fspecial('average');
            for k=1:size(myImage,3)
                imgAv(:,:,k)=imfilter(myImage(:,:,k),h);
            end 
            %flaten arrays
            imgAvFlat=reshape(imgAv,[size(X,1),1]);
            %concatenate features. Note the order is important, should be as done
            %for training
            X=[imgAvFlat];
        case 2
            imgAv=zeros(size(myImage));
            imgStd=zeros(size(myImage));
            h = fspecial('average');
            for k=1:size(myImage,3)
                imgAv(:,:,k)=imfilter(myImage(:,:,k),h);
                imgStd(:,:,k) = stdfilt(myImage(:,:,k));   
            end 
            %flaten arrays
            imgAvFlat=reshape(imgAv,[size(X,1),1]);
            imgStdFlat=reshape(imgStd,[size(X,1),1]);
            %concatenate features. Note the order is important, should be as done
            %for training
            X=[imgAvFlat,imgStdFlat];
        
        case 3
            imgAv=zeros(size(myImage));
            imgStd=zeros(size(myImage));
            imgEnt=zeros(size(myImage));
            h = fspecial('average');
            for k=1:size(myImage,3)
                imgAv(:,:,k)=imfilter(myImage(:,:,k),h);
                imgStd(:,:,k) = stdfilt(myImage(:,:,k));
                imgEnt(:,:,k)=entropyfilt(myImage(:,:,k));
            end 
            %flaten arrays
            imgAvFlat=reshape(imgAv,[size(X,1),1]);
            imgStdFlat=reshape(imgStd,[size(X,1),1]);
            imgEntFlat=reshape(imgEnt,[size(X,1),1]);
            %concatenate features. Note the order is important, should be as done
            %for training
            X=[imgAvFlat,imgStdFlat,imgEntFlat];
        case 4
            imgAv=zeros(size(myImage));
            imgStd=zeros(size(myImage));
            imgEnt=zeros(size(myImage));
            imgSke=zeros(size(myImage));
            h = fspecial('average');
            for k=1:size(myImage,3)
                imgAv(:,:,k)=imfilter(myImage(:,:,k),h);
                imgStd(:,:,k) = stdfilt(myImage(:,:,k));
                imgEnt(:,:,k)=entropyfilt(myImage(:,:,k));
                imgSke(:,:,k)=skewenessfilt(myImage(:,:,k));
            end 
            %flaten arrays
            imgAvFlat=reshape(imgAv,[size(X,1),1]);
            imgStdFlat=reshape(imgStd,[size(X,1),1]);
            imgEntFlat=reshape(imgEnt,[size(X,1),1]);
            imgSkeFlat=reshape(imgSke,[size(X,1),1]);
            %concatenate features. Note the order is important, should be as done
            %for training
        case 5
            imgAv=zeros(size(myImage));
            imgStd=zeros(size(myImage));
            imgEnt=zeros(size(myImage));
            imgSke=zeros(size(myImage));
            h = fspecial('average');
            for k=1:size(myImage,3)
                imgAv(:,:,k)=imfilter(myImage(:,:,k),h);
                imgStd(:,:,k) = stdfilt(myImage(:,:,k));
                imgEnt(:,:,k)=entropyfilt(myImage(:,:,k));
                imgSke(:,:,k)=skewenessfilt(myImage(:,:,k));
            end 
            %flaten arrays
            imgAvFlat=reshape(imgAv,[size(X,1),1]);
            imgStdFlat=reshape(imgStd,[size(X,1),1]);
            imgEntFlat=reshape(imgEnt,[size(X,1),1]);
            imgSkeFlat=reshape(imgSke,[size(X,1),1]);
            %concatenate features. Note the order is important, should be as done
            %for training
            % X position of voxel
            [I,J,K]=ind2sub(size(myImage),[1:size(X,1)]);
            
            X=[imgAvFlat,imgStdFlat,imgEntFlat,imgSkeFlat,I'/dim(1)];
         case 6
            imgAv=zeros(size(myImage));
            imgStd=zeros(size(myImage));
            imgEnt=zeros(size(myImage));
            imgSke=zeros(size(myImage));
            h = fspecial('average');
            for k=1:size(myImage,3)
                imgAv(:,:,k)=imfilter(myImage(:,:,k),h);
                imgStd(:,:,k) = stdfilt(myImage(:,:,k));
                imgEnt(:,:,k)=entropyfilt(myImage(:,:,k));
                imgSke(:,:,k)=skewenessfilt(myImage(:,:,k));
            end 
            %flaten arrays
            imgAvFlat=reshape(imgAv,[size(X,1),1]);
            imgStdFlat=reshape(imgStd,[size(X,1),1]);
            imgEntFlat=reshape(imgEnt,[size(X,1),1]);
            imgSkeFlat=reshape(imgSke,[size(X,1),1]);
            %concatenate features. Note the order is important, should be as done
            %for training
            % X position of voxel
            [I,J,K]=ind2sub(size(myImage),[1:size(X,1)]);
            
            X=[imgAvFlat,imgStdFlat,imgEntFlat,imgSkeFlat,I'/dim(1),J'/dim(2)];
         case 7
            imgAv=zeros(size(myImage));
            imgStd=zeros(size(myImage));
            imgEnt=zeros(size(myImage));
            imgSke=zeros(size(myImage));
            h = fspecial('average');
            for k=1:size(myImage,3)
                imgAv(:,:,k)=imfilter(myImage(:,:,k),h);
                imgStd(:,:,k) = stdfilt(myImage(:,:,k));
                imgEnt(:,:,k)=entropyfilt(myImage(:,:,k));
                imgSke(:,:,k)=skewenessfilt(myImage(:,:,k));
            end 
            %flaten arrays
            imgAvFlat=reshape(imgAv,[size(X,1),1]);
            imgStdFlat=reshape(imgStd,[size(X,1),1]);
            imgEntFlat=reshape(imgEnt,[size(X,1),1]);
            imgSkeFlat=reshape(imgSke,[size(X,1),1]);
            %concatenate features. Note the order is important, should be as done
            %for training
            % X position of voxel
            [I,J,K]=ind2sub(size(myImage),[1:size(X,1)]);
            
            X=[imgAvFlat,imgStdFlat,imgEntFlat,imgSkeFlat,I'/dim(1),J'/dim(2),K'/dim(3)];
            
    end  
    
    
  