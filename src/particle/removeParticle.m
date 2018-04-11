function removeParticle(landmarkId)
global State

State.P.featureInverseDepth(landmarkId,:) = [];  
State.P.featureProbMatrix(landmarkId,:) = [];
State.P.rhoMean(landmarkId) = [];
State.P.rhoVar(landmarkId) = [];
State.P.validAsLandmark(landmarkId) = [];
State.P.usedAsLandmark(landmarkId) = [];
end
