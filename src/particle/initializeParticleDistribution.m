
%% This function initialize a particle distribution of a new feature, each distribution is a 100*3 submatrix
% Input:
%   - LandmarkId
%   - LandmarkPosition: [x0,y0,z0, theta, phi, rho]'

% THIS FUNCTION ALWAYS ASSUMES THAT YOU ARE INITIALING LANDMARK n RIGHT AFTER [1,2,3, ..., n-1]

function initializeParticleDistribution(LandmarkId, LandmarkPosition)
    global particleId;     % recording m particles
    
    % deprecated
    %global particlePosMatrix;    % Position matrix of 100*m
    
    global State;
    global Param;
    
    

%     if (isempty(find(particleId == LandmarkId,1)))
%         error('Intialize a feature already in candidates');
%         pause;
%     end
    
    v = Param2WorldCoord(LandmarkPosition(4:5));
    
    
    %Initialize with 100 particles, uniform distribution between 0.5 to 5m
    %away from camera.
    newProb = ones(1,100)/100;
    
    %State.P.particleId = [State.P.particleId; LandmarkId];
    %.P.featureCameraOrigin = [State.P.featureCameraOrigin; LandmakrPosition(1:3)'];
    %State.P.featureDirectionVector = [State.P.featureDirectionVector; v'];
    State.P.featureInverseDepth = [State.P.featureInverseDepth; State.P.initFeatureInverseDepth];
    State.P.featureProbMatrix = [State.P.featureProbMatrix; newProb];
    State.P.validAsLandmark = [State.P.validAsLandmark; 0];
    State.P.usedAsLandmark = [State.P.usedAsLandmark; 0];
    State.P.firstTimeInit = [State.P.firstTimeInit; 1];
end


