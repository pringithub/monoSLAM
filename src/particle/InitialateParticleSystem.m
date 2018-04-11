%% This function initiate every global variables of the particle system

function intitiateParticleSystem()

global Param;
global State;

%Initialize variables in Param.
%State.P.featureCameraOrigin = [];                    % origin vector of m*3
%State.P.featureDirectionVector = [];                 % direction vector of m*3. in the form of global coordinate
State.P.featureInverseDepth = [];                     % InverseDepth vector of m*100, we use same depth distribution for every particle distribution
State.P.initFeatureInverseDepth = linspace(0.1,5,100); 
State.P.featureProbMatrix = [];                       % Probability matrix of m*100
State.P.rhoMean = [];
State.P.rhoVar = [];
State.P.validAsLandmark = [];                         % decide whether a landmark is already avalable as a landmark
end