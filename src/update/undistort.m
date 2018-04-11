function uv_u = undistort(uv_d,cam)
% undistort the observation pixel coordinates with known camera parameters

% Cam parameters
Cx = cam.Cx;
Cy = cam.Cy;
k1 = cam.k1;
k2 = cam.k2;
dx = cam.d; %.dx
dy = cam.d; %.dy

uv_u = zeros(2,1);
% Correction
rd = sqrt((dx*(uv_d(1)-Cx))^2+(dy*(uv_d(2)-Cy))^2);
uv_u(1) = Cx+(uv_d(1)-Cx)*(1+k1*rd^2+k2*rd^4);
uv_u(2) = Cy+(uv_d(2)-Cy)*(1+k1*rd^2+k2*rd^4);

