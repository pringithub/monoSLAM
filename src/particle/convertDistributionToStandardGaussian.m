%% Compute each available feature's standard deviation, and convert the feauture with best-estimated depth distribution to a standard Gaussian one.

function [landmarkId, mu, sigma] = convert2StandardGaussian(LandmarkId)
    global particleId;
    global particlePosMatrix;
    global particleProbMatrix;
    
    numFeature = length(particleId);
    
    stdv = zeros(numFeature, 1);
    
    for i = 1:numFeature
        stdv = std(particleProbMatrix(:,i));
    end
    
    % set a threshold here.
    thres = 0.5;
    if min(stdv > thres)
        [NaN, NaN, NaN];
        return;
    end
    
    bestIndex = find(stdv == min(stdv));
    bestId = particleId(bestIndex);
    
    mu = 0;
    cov = zeros(3,3);
    
    for i = 1:100
        mu = mu + particlePosMatrix(i,3*bestIndex-2:3*bestIndex)' * particleProbMatrix(i, bestIndex);
    end
    
    for i = 1:100
        emex = particlePosMatrix(i,3*bestIndex-2:3*bestIndex)' - mu;
        cov = cov + emex*emex' *  particleProbMatrix(i, bestIndex);
    end
    
    
    [bestId, mu, cov];
end