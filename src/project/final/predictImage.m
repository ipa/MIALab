function [ P, Ps ] = predictImage( treeModel,  image, features)
%PREDICTIMAGE prediction of the voxels using random forest

P = zeros(size(image));
Ps = zeros(size(image));

parfor ki = 1:size(image, 3)
    
    [Xs] = extractFeaturesPerSlice(image, features, ki);

    [~, score] = predict(treeModel, Xs);%treeModel.predict(Xs);
    T = 0.5;

    Pm = score(:,2) > T;
%     Pm = score' > T;
    Pm = reshape(Pm, [size(image,1), size(image, 2), 1]);
    P(:,:,ki) = Pm;
    Ps(:,:,ki) = reshape(score(:,2), [size(image,1), size(image,2), 1]);
end

end

