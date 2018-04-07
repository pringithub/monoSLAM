%% MonoSLAM: Visualize camera trajectory

% mu: 13xn
% landmarks: nx3
function plot_trajectory_and_landmarks( mu, landmarks )

    scatter3(0,0,0);
%    grid on
    title('MonoSLAM Camera Trajectory');
    xlabel('x');ylabel('y');zlabel('z');

    plot3( mu(1,:), mu(2,:), mu(3,:) );
    drawnow;

end