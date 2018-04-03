
%% This function initialize a particle distribution of a new feature, each distribution is a 100*3 submatrix
% Input:
%   - LandmarkId
%   - 2D position of the landmark in current frame
function initializeParticleDistribution(LandmarkId, posInImage)
    global particleId;     % recording m particles
    global particlePosMatrix;    % Position matrix of 100*m
    global particleProbMatrix;   % Probability matrix of 100*m
    

    if (isempty(find(particleId == LandmarkId,1)))
        error('Intialize a feature already in candidates');
        pause;
    end
    
    %unit direction vector
    u = recover(posInImage);
    
    %Initialize with 100 particles, uniform distribution between 0.5 to 5m
    %away from camera.
    newProb = ones(100,1)/100;
    newPos = zeros(100,3);
    newPos(:,1) = linespace(State.Ekf.mu(1)+0.5*u(1), State.Ekf.mu(1)+5*u(1), 100);
    newPos(:,2) = linespace(State.Ekf.mu(2)+0.5*u(2), State.Ekf.mu(2)+5*u(2), 100);
    newPos(:,3) = linespace(State.Ekf.mu(3)+0.5*u(3), State.Ekf.mu(3)+5*u(3), 100);
    
    
    particleId = [particleId; LandmarkId];
    particlePosMatrix = [particlePos; newPos]
    particleProbMatrix = [particleMatrix newProb];
end


