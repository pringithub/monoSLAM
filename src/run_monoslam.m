%% run_monoslam.m
% Main function to run monoslam

function run_monoslam(numSteps, pauseLen)

clear global Param State Data

global Param;
global State;

if ~exist('nSteps','var') || isempty(nSteps)
    nSteps = inf;
end

if ~exist('pauseLen','var')
    pauseLen = 0; % seconds
end


addpath('map_management/');
addpath('particle/');
addpath('prediction/');
addpath('update/');


% ---------------------------------------------------------------------
% Initialize Params, Data, State
% : saves into global Params, State
% ---------------------------------------------------------------------

initialize();

% for trajectory
num_images        = Param.img.end_id;
mu_history        = zeros(State.Ekf.dimR, num_images); 
Sigma_history     = cell(1, num_images);
predMu_history    = zeros(State.Ekf.dimR, num_images);
predSigma_history = cell(1, num_images);
prediction_times  = zeros(1, num_images);
update_times      = zeros(1, num_images);


% ---------------------------------------------------------------------
% Record / save result
% ---------------------------------------------------------------------

Param.makeVideo = false;
if Param.makeVideo
    votype = 'VideoWriter';
    vo = VideoWriter('video_monoslam', 'MPEG-4');
    set(vo, 'FrameRate', min(5, 1/pauseLen));
    open(vo);
end

Param.save = true;
Param.visualize = false;
filename = 'saved_run.mat';
IMAGE_FIGURE = 1;
TRAJ_3D_FIGURE = 2;


% ---------------------------------------------------------------------
% MonoSLAM Iterations
% ---------------------------------------------------------------------

State.Ekf.img = get_frame( Param.img.init_id );

for t = 1 : Param.img.stride : num_images % other guys' starts at 2????????
    
    
    % detect new landmarks, delete inappropriate landmarks from image
    map_management();
    
    
    % control input
    % : assume stable camera motion and zero acceleration
    u = zeros(6,1);
    
    
    % EKF predict state
    motion_prediction( u, Param.dt );
    %
    predMu_history(:,t)  = State.Ekf.mu(1:13);
    predSigma_history{t} = State.Ekf.Sigma(1:3,1:3);
    
    
    % measurement prediction
    % : compute zhat
    measurement_prediction();
    
    
    % In original MonoSLAM, need to warp landmark templates 
    % : should be good without 
    
    % load a frame
    State.Ekf.img = get_frame(t);
    
    
    % get measurement
    surf_feature_matching(true); % skeleton ...
    
    
    % update camera pose and landmark positions
    observation_update();
    %
    mu_history(:,t)  = State.Ekf.mu(1:13);
    Sigma_history{t} = State.Ekf.Sigma(1:3,1:3);
    
    
    disp(t)
    
    if Param.visualize
        if (mod(t,10)==1)
            %{
            figure(IMAGE_FIGURE)
            imshow(State.Ekf.img);
            hold on
            landmarks = 0; % change this to something !!!!!!!!!!!!!!!!!
            hold off
            figure(TRAJ_3D_FIGURE)
            plot_trajectory_and_landmarks(mu_history,landmarks)
            %}
            figure(IMAGE_FIGURE)
            subplot(1,2,1)
            plot_image_and_features()
            subplot(1,2,2)
            plot_trajectory_and_landmarks(mu_history(1:3,:)) 
            subplot(1,2,1) % for plotting of corners
        end
    end
    
    if Param.save
        if mod(t, 50) == 0
        save(filename, ...
            'mu_history', 'Sigma_history', ...
            'predMu_history', 'predSigma_history' );
        end
    end
    
    % record
    drawnow;
    % record video
    if Param.makeVideo
        F = getframe(gcf);
        switch votype
            case 'avifile'
                vo = addframe(vo, F);
            case 'VideoWriter'
                writeVideo(vo, F);
            otherwise
                error('unrecognized votype');
        end
    end
    if pauseLen > 0
        pause(pauseLen);
    end
    
    
    
    
    
    
end % for







end
