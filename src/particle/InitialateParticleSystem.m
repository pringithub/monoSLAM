%% This function initiate every global variables of the particle system

function intitiateParticleSystem()
global particleId;     % recording m particles
global particlePosMatrix;    % Position matrix of 100*3m
global particleProbMatrix;   % Probability matrix of 100*m
global SigmaFrame;      % a 2*2 covariance matrix for points in a frame
global cameraType;      % valid value : 'pinhole' or 'wideAngle'
global cameraParam;     % import from global definitions

particleId = [];
particlePosMatrix = [];
particleProbMatrix = [];
SigmaFrame = [1 0; 0 1];
cameraType = 'pinhole';

end