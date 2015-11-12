%Lab4&5

%objective: Statistical shape modeling and model evaluation. Build a
%statisitical shape model (SSM) from a set of meshes, which have been
%previously registered. A Generalized Procrustes algorithm( to be dicussed in
%class) is used to align the meshes before eigen-analysis. Evaluate the
%model using standard metrics and use the model to perform population-based
%analysis. Develop routines to transform meshes into volumetric images.

%% General parameters
addpath(genpath('../libs'));
%% set main parameters
clear ; close all; clc;

path2Meshes='DataSSMModel';

%% Data loading. Each element of S corresponds to a shape "flattened" as a 1D vector. FV holds topological information used for visualization.
[S,FV]=readMeshes(path2Meshes);
%% Align using GP
S_aligned=GeneralizedProcrustes(S);

%% EigenDecomposition.Outputs mean shape and eigenanalysis. 
[inputMean, eVals,eVecs]=eigenDecomp(S_aligned);

%% Animate modes of deformation. This is for visualization purposes. Each row corresponds to a principal component. Each column corresponds to the range -2:2 standard deviation.
k=1;%counter for subplot
figure(1); clf;
for m=1:3 %mode 1 to 3a
    for i = -2:2 % from -2 to 2 standard deviation
        b=zeros(size(eVals));
        b(m)=i;
        sample=drawSample(b,inputMean,eVals,eVecs);
        subplot(3,5,k);k=k+1;view([90 90]);
        plotSample(sample,FV,'b');
        axis equal;
    end
end

%% Plot 
stepsize = 0.1;
range = -3:stepsize:3;
distances = zeros(length(range), 3);
k=1;%counter for subplot
for m=1:3 %mode 1 to 3a
    j = 1;
    for i = range
        b=zeros(size(eVals));
        b(m)=i;
        sample=drawSample(b,inputMean,eVals,eVecs);
        
        dimSample = size(sample,1);
        xyz = reshape(sample,dimSample/3,3);
        
        idx1 = 11291;
        idx2 = 4872;
        s1 = xyz(idx1,:);
        s2 = xyz(idx2,:);
        
        %w = exp(-abs(i));
        dist = norm(s2 - s1);
        distances(j, m) = dist;
        j = j + 1;
    end
end

%% calc
i = range;
W = normpdf(i, 0, 1)';
distance1 = sqrt(distances(:,1).^2 + distances(:,2).^2 + distances(:,3).^2);
M = sum(distance1 .* W .* stepsize);

%% Compactness. 
for i=1:size(eVals)
    comp(i)=sum(eVals(1:i))/sum(eVals);
end
figure(2); clf;
plot(comp);title('Compactness');


%% Generalization - leave-one-out

s_error=zeros(size(eVals,1)-1,size(S_aligned,2));%to store error modes x samples. Note: the new model has n-1 modes w.r.t original

%exclude one shape at a time and recreate model.
scounter=1;
for s=1:size(S_aligned,2)  

    s_out=S_aligned(:,s);

    S_out=S_aligned; S_out(:,s)=[];

    %create model without "s_out"
    [inputMean, eVals,eVecs]=eigenDecomp(S_out);
    %project s_out on new model

    eVeVal=eVecs*diag(sqrt(eVals));

    b_projected= pinv(eVeVal)*(s_out-inputMean);

    %measure error by using different number of modes
    for mode=1:size(eVals,1)-1

        %only use first modes     
        b_projMode=zeros(size(b_projected));
        b_projMode(mode:-1:1)=b_projected(mode:-1:1);

        % reconstructed shaped. 
       % newSample=inputMean + eVecs*diag(sqrt(eVals))*b_projMode; % alternative, drawSample(b_projMode,inputMean,eVals,eVecs)
        newSample=drawSample(b_projMode,inputMean,eVals,eVecs);
        error=abs(s_out-newSample);
        subplot(10,7,scounter);plotSample(s_out,FV,'b');
        scounter=scounter+1;
        
        s_error(mode,s)=norm(newSample-s_out);
    end

end

figure;
boxplot(s_error');title('Generalization');

%% Lab 5 part 1
Cr = zeros(size(inputMean,1), 8);
for m = 1
    figure(1); clf;
    % ==========================================
    for i = 0 %hint: add an interval a:b:c
        b=zeros(size(eVals));
        b(m)=i;
        % ==========================================
        %reconstructedFemur = inputMean;
        %reconstructedFemur = reconstructedFemur + b * sqrt(eVals(mode)) * eVecs(:, mode);
        reconstructedFemur = drawSample(b,inputMean,eVals,eVecs);
        f = size(inputMean, 1) / 3;
        %Visualize mean shape for comparison purposes
        plotSample(sample,FV,'b');
        %trisurf(FV.faces, inputMean(1:f-1), inputMean(f:2*f-1), inputMean(2*f:3*f), zeros(f-1, 1));
        axis equal;
        hold on;
        %Visualize new shape
        outliedIdx = 1000;
        reconstructedFemur(20000:30000,:) = reconstructedFemur(20000:30000,:) + rand(1,1)*100;
        plotSample(reconstructedFemur,FV,'y');
        %trisurf(FV.faces, reconstructedFemur(1:f-1), reconstructedFemur(f:2*f-1), reconstructedFemur(2*f:3*f), ones(f-1, 1));
        hold off;
        %axis([-25 25 -5 5 -5 5]);
        %campos([0,0,10]);
        %title(['Mode ' num2str(m)]);
        %legend('Mean', 'Moving', 'Location', 'Best');
        %pause(0.1); % this helps with the visualization
            end
end
        %% foo
        figure(10); clf;
        n = length(inputMean);
        %for j = 1:length(inputMean)
        for k = 1:8
            Phi=  eVecs(:, k) .* sqrt(eVals(k));
            bout = ((1./Phi)' * (reconstructedFemur - inputMean)).^2;
            Cr(:,k) = (1/n) * bout ./ eVals(k);
%             Cr(:,k) = (((reconstructedFemur - inputMean) + ...
%                 eVecs(:,k)*sqrt(eVals(k))).^2) ./ eVals(k);
            subplot(8,1,k);
            plot(Cr(:,k));
        end
        %end
        %%
        figure
        plot(Cr(:,2));
        
        


%% Lab 5 part 3
FV = compactVerticesFaces(FV);
normalsTri = zeros(size(FV.faces));
for i = 1:size(FV.faces,1)
    v1 = FV.vertices(FV.faces(i,2),:) - FV.vertices(FV.faces(i,1),:);
    v2 = FV.vertices(FV.faces(i,3),:) - FV.vertices(FV.faces(i,1),:);
    normalsTri(i,:) = cross(v1,v2);
    normalsTri(i,:) = normalsTri(i,:)/norm(normalsTri(i,:));
end
normalsVer = zeros(size(FV.vertices));
for i = 1:size(FV.vertices,1)
    [idx,~] = find(FV.faces==i);
    normalsVer(i,:) = mean(normalsTri(idx,:),1);
end


kd = KDTreeSearcher(FV.vertices);
stepSize = 0.1;
xmax = max(FV.vertices(:,1));
xmin = min(FV.vertices(:,1));
ymax = max(FV.vertices(:,2));
ymin = min(FV.vertices(:,2));
zmax = max(FV.vertices(:,3));
zmin = min(FV.vertices(:,3));
idx2point = @(idx) [xmin+stepSize*idx(1), ymin+stepSize*idx(2), zmin+stepSize*idx(3)];

V = zeros(ceil((xmax-xmin)/stepSize), ceil((ymax-ymin)/stepSize), ceil((zmax-zmin)/stepSize));
for x = 1:size(V,1)
    for y = 1:size(V,2)
        for z = 1:size(V,3)
            p = idx2point([x,y,z]);
            closestVerIdx = knnsearch(FV.vertices,p);
            v = FV.vertices(closestVerIdx,:) - p;
            n = normalsVer(closestVerIdx,:);
            V(x,y,z) = sign(v*n')>=0;
        end
    end
end

%% Tasks:

% ******** First part *********
% 1. Analyze the effect of Generalized Procrustes Analysis. What happens if a constant translation or
% different alignment is applied?
% 2. What happens if b>>3? Test and analyze
% 3. You are designing a new orthopaedic implant: Use the model to measure the average and standard deviation of bone length, femur neck length, over the entire population

% ******** Second part *********

% 1. Visualize both the mean shape and any specific image. See
% differences in shape, pose, scale. This will help to understand the
% shape registration needed during ASM
% 2. Add a synthetic deformation to a specific case(s) and test the use 
% of the contribution metric to find outliers, as seen in the main lecture.
% 3. Make a routine to transform your shape into a binary image (method to
% be explained in class).
