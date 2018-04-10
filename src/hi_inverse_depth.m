% Compute a single measurement
% Convert inverse depth parametrization to the 2D image pixel coordinates

function zi = hi_inverse_depth(yinit, t_wc, r_wc)

global Param;
global State;

cam = Param.camera;


% Points 3D in camera coordinates
r_cw = r_wc';

yi = yinit(1:3);
theta = yinit(4);
phi = yinit(5);
rho = yinit(6);

cphi = cos(phi);
mi = [ cos(phi).*sin(theta) -sin(phi) cos(phi).*cos(theta)]';

% directional vector from camera center to the landmark
hrl = r_cw * ( (yi - t_wc) * rho + mi );

% pixel coordinates
uv_u = hu( hrl, cam );
uv_d = distort_fm( uv_u , cam ); % consider the radial distortion

zi = uv_d;
