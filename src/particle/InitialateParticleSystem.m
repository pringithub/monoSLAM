%% This function initiate every global variables of the particle system

function intitiateParticleSystem()
global particleId;     % recording m particles
global particlePosMatrix;    % Position matrix of 100*3m
global particleProbMatrix;   % Probability matrix of 100*m
global SigmaFrame;      % a 2*2 covariance matrix for points in a frame
global cameraType;      % valid value : 'pinhole' or 'wideAngle'
global cameraParam;     % import from global definitions
global minLandmarks;
global maxLandmarks;
global maxParticles;

particleId = [];
particlePosMatrix = [];
particleProbMatrix = [];
SigmaFrame = [1 0; 0 1];
cameraType = 'pinhole';
minLandmarks = 5;
maxLandmarks = Inf; % For this project, we will keep maxFeature to be Inf to reach maximum accuracy. Computational difficultis are ignored for this now.
maxParticles = Inf;

end