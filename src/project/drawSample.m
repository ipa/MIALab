function sample=drawSample(b,inputMean,eVals,eVecs)
sample = inputMean + eVecs*diag(sqrt(eVals))*b;

