% Calculate the projection of yi (in the camera reference)
function projection = camera_projection( l_i, cam_params)

Cx = cam_params.Cx;
Cy = cam_params.Cy;
f  = cam_params.f;
x_width = 1/cam_params.dx;
y_width = 1/cam_params.dy;

projection = zeros( 2, size( l_i, 2 ) );

for i = 1:size( l_i, 2 )
    projection( 1, i ) = Cx - (l_i(1,i)/l_i(3,i))*f*x_width;
    projection( 2, i ) = Cy - (l_i(2,i)/l_i(3,i))*f*y_width;
end

