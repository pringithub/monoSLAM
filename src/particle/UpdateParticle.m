%% This function is the main function of Landmark initialization part

% Inputs:
%     - a vector of all features detected in current frame      n*1 matrix
%     - their corresponding coordinates in the image            n*2 matrix

function UpdateParticle(featureIdVector, featurePosMatrix)
global State;
global particleId;

numFeaturesDetected = length(featureIdVector);

for i = 1:numFeaturesDetected
    
    currentId = featureIdVector(i);
    
    % If current feature is already being used by the EKF system, ignore
    % and process the next feature
    if (~isempty(find(State.EKf.landmarkVector==currentId,1)))
        continue;
    end
     
    % [x; y] position of current feature
    posInFrame = featurePosMatrix(i,:)';
    
    % if current feature is already a candidate in the particle system,
    % update its position vector.
    if (~isempty(find(particleId == currentId, 1)))
        updateParticleDistribution(currentId, posInFrame);
        continue;
    end
    
    % if current feature has never being recorded, initialize it to be
    % landmark candidate
    if (isempty(find(particleId == currentId, 1)))
        initializeParticleDistribution(currentId, posInFrame);
        continue;
    end
    
end


end