%computes a generalized procrustes aligment. Samples are per column and
%should have same number of points

function alignedSamples=GeneralizedProcrustes(samples)

nSamples = size(samples,2);
sampleMean = mean(samples,2);
nIter=10;

for i=1:nIter
    
    for j=1:nSamples
        
        [d, regSample, tr] = procrustes(sampleMean, samples(:,j));
        alignedSamples(:,j)=regSample;
        
    end
    sampleMean=mean(alignedSamples,2);
end

