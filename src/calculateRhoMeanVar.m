function [rhoMean, rhoVar] = calculateRhoMeanVar(landmarkId)
i = landmarkId;
for j = 1:100
	State.P.rhoMean(i) = State.P.rhoMean(i) + State.P.featureInverseDepth(i, j) * State.P.featureProbMatrix(i, j);
end
        
for j = 1:100
	emex = State.P.featureInverseDepth(i,j) - State.P.rhoMean(i);
	State.P.rhoVar(i) = State.P.rhoVar(i) + emex*emex' *  State.P.featureProbMatrix(i, j);
end
end