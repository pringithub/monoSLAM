function [new_landmark,h] = get_landmark_i( uvd )

global State;
global Param;

cam = Param.camera;
x = State.Ekf.mu( State.Ekf.iR );

fu = -cam.K(1,1);
fv = -cam.K(2,2);
u0  =  cam.K(1,3);
v0  =  cam.K(2,3);

uv = undistort( uvd, cam );
u = uv(1); v = uv(2);

xr = x(1:3); % camera center coord at the first observation of the landmark
q = x(4:7);

% h:
% the directional vector, pointing from the camera's optical center towards
% the landmark location in the world coordinate frame
hi = [ (u0-u)/fu; (v0-v)/fv; 1 ];
h = q2r(q) * hi;
new_landmark = [ xr; atan2(h(1),h(3)); ...
            atan2(-h(2),sqrt(h(1)*h(1)+h(3)*h(3))); Param.rho_init ];
h = h / norm(h);