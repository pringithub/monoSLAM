% transform Inverse Depth Parametrization to standard unit vector in world
% coordinate
function v = Param2WorldCoord(param)

theta = param(1);
phi = param(2);

v = [cos(phi)*sin(theta); ...
     -sin(phi); ...
     cos(phi)*cos(theta)];
 
v = v/norm(v);

end