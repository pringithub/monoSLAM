function initialize()
%initialize parameters and state

global Param
global State

%init params wrt to image
Param.img.dir = 'data/dataset2/color'; %directory
Param.img.files = dir(sprintf('%s/r-*.jpg', Param.img.dir));
Param.img.prefix = ''; %prefix
Param.img.ext = 'png'; %image type
Param.img.rate = 1/30; %image frame rate
Param.img.trajectory = ''; %ground truth
Param.img.init_id = 1;
Param.img.end_id = 604; %number of images in directory
Param.img.stride = 1; %image process speed

%init params wrt to camera
Param.cam.k1 = 0; 
Param.cam.k2 = 0;
Param.cam.fx = 525.0; %focus in x
Param.cam.fy = 525.0; %focus in y
Param.cam.Cx = 319.5; %optical center in x
Param.cam.Cy = 239.5; %optical center in y
Param.cam.nrows = 480; %image size
Param.cam.ncols = 640; %image size
Param.cam.d = 1; %camera delta
Param.cam.K = [ -Param.cam.fx/Param.cam.d, 0, Param.cam.Cx; 
                0, -Param.cam.fy/Param.cam.d, Param.cam.Cy; 
                0, 0, 1 ]; %Camera K matrix

%init params wrt map
Param.map.encoding = 'InverseDepth';
Param.map.min_nL = 12; %minimum number of landmarks in the map

%init params wrt process
Param.dt = 1/30; %same as frame rate (sec)

Param.updateMethod = 'batch'; %update method of observation model

Param.patchsize_match = 24; %patchsize used to match features between images

Param.sigma.accel = 0.0070; %sigma noise for accel input
Param.sigma.ang = 0.0070; %sigma noise for angular accel input
Param.sigma.image = 1; %sigma noise for observation
Param.sigma.inverse_depth = 1;

Param.rho_init = 1; %initial inverse depth
Param.lambda = 10; %for uncertainty ellipse in feature init step

%init state
State.Ekf.t = 0; %keeps track of time
State.Ekf.mu = [0 0 0 1 0 0 0 0 0 0 eps eps eps]'; %initialize camera at origin
init_sig = 0.025^2; %initial variance of velocity and angular rate
State.Ekf.Sigma = diag([eps eps eps eps eps eps eps ...
                    init_sig init_sig init_sig init_sig init_sig init_sig]); %covariance matrix

%State parameters
State.Ekf.iR = 1:13; % vector containing camera state
State.Ekf.dimR = 13;
State.Ekf.dimL = 6; %dimension of landmark
State.Ekf.nL = 0; %number of landmarks in state vector
State.Ekf.iM = []; % dimL*nL vector containing map indices
State.Ekf.iL = {}; %cell aray containing index of landmark i