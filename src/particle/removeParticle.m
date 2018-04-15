function removeParticle(landmarkId)
global State
fprintf(strcat('remove landmark ', landmarkId, '\n'));
State.P.featureInverseDepth(landmarkId,:) = [];  
State.P.featureProbMatrix(landmarkId,:) = [];
State.P.rhoMean(landmarkId) = [];
State.P.rhoVar(landmarkId) = [];
State.P.validAsLandmark(landmarkId) = [];
State.P.usedAsLandmark(landmarkId) = [];
State.P.firstTimeInit(landmarkId) = [];
end
