%% MonoSLAM: Visualize camera trajectory

%{
tmp = (1:100)';
mu = [tmp sin(tmp) cos(tmp)];

plot_trajectory(mu,0);
%}

% mu: nx3
% q: nx3
% landmarks: nx3
function plot_trajectory( mu, q, landmarks )

    scatter3(0,0,0);
    grid on
%    hold on
    title('MonoSLAM Camera Trajectory');
    xlabel('x');ylabel('y');zlabel('z');

    num_iter = size(mu,1);
    for i = 1:num_iter
        
        %scatter3( mu(i,1),mu(i,2),mu(i,3) );
        plot3( mu(1:i,1), mu(1:i,2), mu(1:i,3) );
        drawnow;
        pause(0.2)
        
    end

    hold off

end