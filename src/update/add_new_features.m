function add_new_features(uv_d)
% augment state vector and covariance matrix
% also updates all parameneters with respect to the state and observation
% inputs: pixel coordinate of new feature (rxc)

global State;
global Param;

ud = uv_d(1);
vd = uv_d(2);

% given the pixel coordinates of detected feature, obtain the 6 parameters
% describing the robot pose
[mi,n] = hinv(uv_d);

% augment state vector
State.Ekf.mu = [State.Ekf.mu; mi];

% augment covariance matirx
aug_sig(uv_d);

% Update state paameters with inf of new landmark
dimX = State.Ekf.dimR;           % dimension of camera pose
dimL = State.Ekf.dimL;           % dimension of landmark
prev = dimL*State.Ekf.nL + dimX; % tail position of prev state

State.Ekf.iM(dimL*State.Ekf.nL + (1:dimL) ) = prev + (1:dimL); %update new map index
State.Ekf.iL{State.Ekf.nL+1 } = prev + (1:dimL); %update new landmark index

% Initialize observation model parameters
State.Ekf.h{ State.Ekf.nL+1 } = [];
State.Ekf.z{ State.Ekf.nL+1 } = [];
State.Ekf.H{ State.Ekf.nL+1 } = [];
State.Ekf.S{ State.Ekf.nL+1 } = [];
State.Ekf.Q{ State.Ekf.nL+1 } = [];
State.Ekf.status( State.Ekf.nL+1 ) = true;
State.Ekf.matched( State.Ekf.nL+1 ) = 0;
State.Ekf.match_attempts( State.Ekf.nL+1 ) = 0;
State.Ekf.individually_compatible( State.Ekf.nL+1 ) = 0;
State.Ekf.init_t{ State.Ekf.nL+1 } = State.Ekf.t;
State.Ekf.init_z{ State.Ekf.nL+1 } = uv_d;
State.Ekf.init_x{ State.Ekf.nL+1 } = State.Ekf.mu( State.Ekf.iR );

% add patch around the given pixel coords
del_match = Param.patchsize_match;
State.Ekf.patch_matching{State.Ekf.nL+1} = State.Ekf.I(vd-del_match:vd+del_match, ud-del_match:ud+del_match);

% Update number of total landmarks
State.Ekf.nL = State.Ekf.nL + 1;

