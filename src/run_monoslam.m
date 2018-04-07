%% run_monoslam.m
% Main function to run monoslam

function run_monoslam(numSteps, pauseLen)


global Param;
global State;

if ~exist('nSteps','var') || isempty(nSteps)
    nSteps = inf;
end

if ~exist('pauseLen','var')
    pauseLen = 0; % seconds
end


% ---------------------------------------------------------------------
% Initialize Params, Data, State
% : saves into global Params, State
% ---------------------------------------------------------------------

initialize();

% for trajectory
num_images        = Param.frame.end_id;
mu_history        = cell(1, num_images); 
Sigma_history     = cell(1, num_images);
predMu_history    = cell(1, num_images);
predSigma_history = cell(1, num_images);
prediction_times  = zeros(1, num_images);
update_times      = zeros(1, num_images);

Param.frame.dir = '../data/dataset1/color';

Param.visualize = true;


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

Param.do_save = true;
Param.do_visualize = true;



% ---------------------------------------------------------------------
% MonoSLAM Iterations
% ---------------------------------------------------------------------

State.Ekf.img = getframe( Param.frame.init_id );

for t = 2 : Param.frame.stride : num_images % why start at 2????????
    
    
    % detect new landmarks, delete inappropriate landmarks from image
    map_management();
    
    
    % control input
    % : assume stable camera motion and zero acceleration
    u = zeros(6,1);
    
    
    % EKF predict state
    motion_prediction( u, Param.dt );
    %
    predMu_history{t}    = Param.Ekf.mu;
    predSigma_history{t} = Param.Ekf.Sigma(1:3,1:3);
    
    
    % measurement prediction
    % : compute zhat
    measurement_prediction();
    
    
    % In original MonoSLAM, need to warp landmark templates 
    % : should be good without 
    
    % load a frame
    State.Ekf.img = get_frame(t);
    
    
    % get measuremtn
    feature_matching(); % skeleton ...
    
    
    % update camera pose and landmark positions
    observation_update();
    %
    mu_history{t}    = Param.Ekf.mu;
    Sigma_history{t} = Param.Ekf.Sigma(1:3,1:3);
    
    
    
    % record
    % drawnow;
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