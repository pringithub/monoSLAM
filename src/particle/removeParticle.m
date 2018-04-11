function removeParticle(landmarkId)
global State

State.P.featureInverseDepth(landmarkId,:) = [];  
State.P.featureProbMatrix(landmarkId,:) = [];
end