% Calculate the projection of yi (in the camera reference)
function projection = camera_projection( l_i )

global Param;

Cx = Param.camera.Cx;
Cy = Param.camera.Cy;
f  = Param.camera.fx; % f = fx = fy 
x_width = 1/Param.camera.d; %camera.dx
y_width = 1/Param.camera.d; %camera.dy

projection = zeros( 2, size( l_i, 2 ) );

for i = 1:size( l_i, 2 )
    projection( 1, i ) = Cx - (l_i(1,i)/l_i(3,i))*f*x_width;
    projection( 2, i ) = Cy - (l_i(2,i)/l_i(3,i))*f*y_width;
end

