function [ P ] = predictImage( treeModel,  image, features)
%PREDICTIMAGE Summary of this function goes here
%   Detailed explanation goes here

P = zeros(size(image));
% figure
parfor ki = 1:size(image, 3)
    display(['Processing slice ', num2str(ki)]);
    
    [Xs] = extractFeaturesPerSlice(image, features, ki);
    
%     display('-- predicting');
%     [prediction13, score13] = compactTreeModel13.predict(Xs);
%     [prediction46, score46] = compactTreeModel46.predict(Xs);
%     [prediction79, score79] = compactTreeModel79.predict(Xs);
    
    [~, score] = treeModel.predict(Xs);
     T = 0.5;
%     Pm13 = score13(:,2) > T;
%     Pm46 = score46(:,2) > T;
%     Pm79 = score79(:,2) > T;
%     Pm = (Pm13 + Pm46 + Pm79) >= 3;
%     score = (score13(:,2) + score46(:,2) + score79(:,2)) / 3;
%     Pm = cell2mat(prediction) == '1';
    Pm = score(:,2) > T;
    Pm = reshape(Pm, [size(image,1), size(image, 2), 1]);
    Pm = imopen(Pm, strel('disk', 2));
    Pm = keepLargestArea(Pm);
    P(:,:,ki) = Pm;
    
end

end

