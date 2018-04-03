%% This function initiate every global variables of the particle intitiateParticleSystem

function intitiateParticleSystem()
global particleId;     % recording m particles
global particlePosMatrix;    % Position matrix of 100*3m
global particleProbMatrix;   % Probability matrix of 100*m
global SigmaFrame;      % a 2*2 covariance matrix for points in a frame

particleId = [];
particlePosMatrix = [];
particleProbMatrix = [];
SigmaFrame = [1 0; 0 1];
end
