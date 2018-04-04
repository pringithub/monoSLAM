%% Calculate the 2D position of a feature given its 3d position and 

function x = projection(pos)
global cameraType;

global cameraParam;
% cameraParam.fku;
% cameraParam.fkv;
% cameraParam.u0;
% cameraParam.v0;

global State;
% State.R_RW

global cameraParam;

% the position of a point feature relative to the camera
% yiW: camera position wrt world
% R_RW: rotation matrix from robot to world coordinate
% rW: feature positin wrt world
h_RL = R_RW * (yiW-rW); % [x y z] position


if cameraType == 'pinhole'
    u = cameraParam.u0 - cameraParam.fku* (h_RL(1)/h_RL(3));
    v = cameraParam.v0 - cameraParam.fkv* (h_RL(2)/h_RL(3));
end

if cameraType == 'wideAngle'
end


[u v];
end