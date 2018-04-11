function Hi = calculate_Hi( cam_pose, yi, zi, cam_params, i, nL )

Hi11 = dh_dhrl( cam_params, cam_pose, yi, zi ) * dhrl_drw( cam_pose, yi );
Hi12 = dh_dhrl( cam_params, cam_pose, yi, zi ) * dhrl_dqwr( cam_pose, yi );
Hi = [ Hi11  Hi12 zeros( 2, 6 )];

for j=1:nL
    if j == i
        Hii = dh_dhrl( cam_params, cam_pose, yi, zi ) * dhrl_dy( cam_pose, yi );
        Hi = [Hi    Hii];
    else
        Hi = [Hi    zeros(2,6)];
    end
end

return

function a = dhrl_dy( cam_pose, yi )

rw = cam_pose( 1:3 );
Rrw = inv( q2r( cam_pose( 4:7 ) ) );
lambda = yi(6);
phi = yi(5);
theta = yi(4);

dmi_dthetai = Rrw*[cos(phi)*cos(theta)  0   -cos(phi)*sin(theta)]';
dmi_dphii = Rrw*[-sin(phi)*sin(theta)  -cos(phi)   -sin(phi)*cos(theta)]';

a = [lambda*Rrw  dmi_dthetai dmi_dphii Rrw*(yi(1:3)-rw) ];

return

function a = dhrl_dqwr( cam_pose, yi )

rw = cam_pose( 1:3 );
qwr = cam_pose( 4:7 );
lambda = yi(6);
phi = yi(5);
theta = yi(4);
mi = [cos(phi)*sin(theta)   -sin(phi)  cos(phi)*cos(theta)]';

dqbar_by_dq = diag([1 -1 -1 -1]);

% Conjugate
q_bar=-qwr;
q_bar(1)=qwr(1);

a = dRq_times_a_by_dq( q_bar, ((yi(1:3) - rw)*lambda + mi) )*dqbar_by_dq;

return

function a = dhrl_drw( cam_pose, yi )

a = -( inv( q2r( cam_pose(4:7) ) ) )*yi(6);

return

function a = dh_dhrl( cam_params, cam_pose, yi, zi )

a = inv(jacob_undistort_fm( cam_params, zi ))*dhu_dhrl( cam_params, cam_pose, yi);

return

function a = dhu_dhrl( cam_params, cam_pose, yi )

fx = cam_params.fx;
fy = cam_params.fy;
ku = 1/cam_params.dx;
kv = 1/cam_params.dy;
rw = cam_pose( 1:3 );
Rrw = inv(q2r( cam_pose( 4:7 ) ));

theta = yi(4);
phi = yi(5);
rho = yi(6);
mi = [cos(phi)*sin(theta)   -sin(phi)  cos(phi)*cos(theta)]';

hc = Rrw*( (yi(1:3) - rw)*rho + mi );
hcx = hc(1);
hcy = hc(2);
hcz = hc(3);
a = [-fx*ku/(hcz)       0           hcx*fx*ku/(hcz^2);
    0               -fy*kv/(hcz)    hcy*fy*kv/(hcz^2)];

return