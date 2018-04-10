%% Compute each available feature's standard deviation, and convert the feauture with best-estimated depth distribution to a standard Gaussian one. If no features are good enough, return NaN.

function [landmarkId, rho, sigma] = convertFeature2stdGaussian(LandmarkId)
    global State;
    global Param;
    
    numFeature = length(particleId);
    
    stdv = zeros(numFeature, 1);
    
    for i = 1:1:State.Ekf.nL
        stdv(i) = std(State.P.featureProbMatrix(i,:));
    end
    
    % set a threshold here.
    thres = 0.5;
    if min(stdv > thres)
        [NaN, NaN, NaN];
        return;
    end
    
    bestIndex = find(stdv == min(stdv));
    bestId = particleId(bestIndex);
    
    rho = 0;
    var = zeros(3,3);
    
    for i = 1:100
        rho = rho+ State.P.featureInverseDepth(bestIndex, i) * State.P.featureProbMatrix(bestIndex, i);
    end
    
    for i = 1:100
        emex = State.P.featureInverseDepth(bestIndex, i) - rho;
        var = var + emex*emex' *  State.P.featureProbMatrix(bestIndex, i);
    end
    
    % remove current feature from the system
    
    [bestId, rho, var];
end