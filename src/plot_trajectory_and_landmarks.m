%% MonoSLAM: Visualize camera trajectory

% mu: 13xn
% landmarks: nx3
function plot_trajectory_and_landmarks(mu_history)

global State;
global Param;

static_or_anim = 0;


close all;





if static_or_anim
    figure
    %
    subplot(4,1,1);
    scatter3( mu_history(1,:), mu_history(2,:), mu_history(3,:) );
    title('MonoSLAM Camera Trajectory');
    xlabel('x');ylabel('y');zlabel('z');
    %
    subplot(4,1,2)
    scatter(mu_history(1,:),mu_history(2,:))
    xlabel('x');ylabel('y');
    %
    subplot(4,1,3);
    scatter(mu_history(1,:),mu_history(3,:))
    xlabel('x');ylabel('z');
    %
    subplot(4,1,4);
    scatter(mu_history(2,:),mu_history(3,:))
    xlabel('y');ylabel('z');
    %
    drawnow;
else
    figure('position', [72 545 900 400])
    subplot(1,2,2);
    scatter3(0,0,0);
    hold on
    %axis([-2 2 -2 2 -2 2]);
    view(14,-37)
    %    grid on
    title('MonoSLAM Camera Trajectory');
    xlabel('x');ylabel('y');zlabel('z');
    for frame = 1:150%length(mu_history)
        frame
        subplot(1,2,1);
        img_filename = sprintf( '%s%s', Param.img.dir, Param.img.files(frame).name );
        %img = rgb2gray( imread(img_filename) );
        imshow( imread(img_filename) );
        %
        subplot(1,2,2);
    	scatter3( mu_history(1,frame), mu_history(2,frame), mu_history(3,frame), 'k' );
        drawnow;
        pause(1/30);
    end
    hold off;
    title('MonoSLAM Camera Trajectory');
    xlabel('x');ylabel('y');zlabel('z');
end


end