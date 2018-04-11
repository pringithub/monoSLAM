%% MonoSLAM: Visualize camera trajectory

% mu: 13xn
% landmarks: nx3
function plot_trajectory_and_landmarks(mu_history)

global State;

scatter3(0,0,0);
%    grid on

for i = 1:State.Ekf.nL
% plot landmark
end

scatter3( mu_history(1,:), mu_history(2,:), mu_history(3,:) );
drawnow;

title('MonoSLAM Camera Trajectory');
xlabel('x');ylabel('y');zlabel('z');

end