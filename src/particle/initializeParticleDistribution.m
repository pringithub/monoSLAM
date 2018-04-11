
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

    
    v = Param2WorldCoord(LandmarkPosition(4:5));
    
    
    %Initialize with 100 particles, uniform distribution between 0.5 to 5m
    %away from camera.
    newProb = ones(100,1)/100;
    
    %State.P.particleId = [State.P.particleId; LandmarkId];
    %.P.featureCameraOrigin = [State.P.featureCameraOrigin; LandmakrPosition(1:3)'];
    %State.P.featureDirectionVector = [State.P.featureDirectionVector; v'];
    State.P.featureInverseDepth = [State.P.featureInverseDepth; State.P.initFeatureInverseDepth];
    State.P.featureProbMatrix = [State.P.featureProbMatrix; newProb];
end


