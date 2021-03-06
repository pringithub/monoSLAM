% Update the State variables
function observation_update()

global Param;
global State;

% construct stacked H and S matrices for batch update
H = [];
z = [];
zhat = [];

for i = 1:State.Ekf.nL
    if State.Ekf.individually_compatible(i)
        H = [ H; State.Ekf.H{i} ];
        z = [ z; State.Ekf.z{i} ];
        zhat = [ zhat; State.Ekf.h{i} ];
    end
end

if isempty(H)
    return;
end
Q = eye( size(H,1) ) * Param.sigma.image_noise^2;
S = H * State.Ekf.Sigma * H' + Q;

% Kalman gain
K = State.Ekf.Sigma*H'*inv(S) ;

assert( isequal( size(z), size(zhat) ));

% update
dz = z - zhat;
if ~isempty(dz)
    State.Ekf.mu = State.Ekf.mu + K*dz;
    State.Ekf.Sigma = State.Ekf.Sigma - K*H*State.Ekf.Sigma; 
    % To do check Sigma update
    State.Ekf.Sigma = 0.5*State.Ekf.Sigma + 0.5*State.Ekf.Sigma';
    normalize_state_quaternion();
end