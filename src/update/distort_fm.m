%--------------------------------------------------------------------------
% distort_fm.m
%
% convert the pixel coords (u,v) to the revised coords
% by considering the radial distortion
%
% input:  u, v image pixel coords
% output: ud, vd image pixel coords considering the radial distortion
%
%--------------------------------------------------------------------------

function uvd = distort_fm( uv, cam )

Cx = cam.Cx; Cy = cam.Cy;
k1 = cam.k1; k2 = cam.k2;
dx = cam.dx; dy = cam.dy;


xu=(uv(1,:)-Cx)*dx;
yu=(uv(2,:)-Cy)*dy;

ru=sqrt(xu.*xu+yu.*yu);
rd=ru./(1+k1*ru.^2+k2*ru.^4);

for k=1:10
    f = rd + k1*rd.^3 + k2*rd.^5 - ru;
    f_p = 1 + 3*k1*rd.^2 + 5*k2*rd.^4;
    rd = rd - f./f_p;
end

D = 1 + k1*rd.^2 + k2*rd.^4;
xd = xu./D;
yd = yu./D;

uvd = [ xd/dx+Cx; yd/dy+Cy ];