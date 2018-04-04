%% recover a 2D position in image to a 3d unit line direction vector
% Input:
%   - 2dpos: 2d position of feature in frame
%   - frame: frame information structures
%   - Global information such as robot position and camera direction

function d = recover(posInFrame)

global cameraParam;
% cameraParam.fku;
% cameraParam.fkv;
% cameraParam.u0;
% cameraParam.v0;

u = posInFrame(1);
v = posInFrame(2);

d = zeros(3,1);

if cameraType == 'pinhole'
    d(1) = (cameraParam.u0 - u)/cameraParam.fku;
    d(2) = (cameraParam.v0 - v)/cameraParam.fkv;
    d(3) = 1;
end

if cameraType == 'wideAngle'
end

d = d/norm(d);
end

