function motion_model(u,dt)
% EKF-SLAM prediction for Monocular vision motion model

global Param;
global State;

%Dimension of state and map
N_r  = 13;
N = length(State.Ekf.mu);

%Noise of input control
accel_noise = ?;
ang_noise = ?;

%build jacobian wrt state
mag = norm(State.Ekf.mu(11:13)*dt);
unit = [mag;State.Ekf.mu(11:13)*dt/mag);
quat = State.Ekf.mu(4:7);
W = State.Ekf.mu(11:13);

dr_dr = eye(3);
dr_dv = dt * eye(3);
dv_dv = eye(3);
dw_dw = eye(3);

dq_dq = [unit(1) -unit(2) -unit(3) -unit(4);
               unit(2)  unit(1)  unit(4) -unit(3);
               unit(3) -unit(4)  unit(1)  unit(2);
               unit(4)  unit(3)  -unit(2)  unit(1)];

dq_dquat = [quat(1) -quat(2) -quat(3) -quat(4);
               quat(2)  quat(1) -quat(4) quat(3);
               quat(3)  quat(4)  quat(1) -quat(2);
               quat(4) -quat(3) -quat(2)  quat(1)];

dquat_dw = dqwdt_dw(W,mag,dt);
dq_dw = dq_dquat * dquat_dw;

g = [ dr_dr, zeros(3,4), dr_dv, zeros(3);
     zeros(4,3),  dq_dq, zeros(4,3), dq_dw;
     zeros(3), zeros(3,4), dv_dv, zeros(3);
     zeros(3), zeros(3,4), zeros(3), dw_dw];

G = blkdiag(g,eye(N-N_r));

%build jacobian wrt control input
var_accel = eye(3)*accel_noise^2;
var_ang = eye(3)*ang_noise^2;
M = blkdiag(var_accel,var_ang);

dr_dV = eye(3)*dt;
dv_dV = eye(3);
dq_dW = dq_dw;;
dw_dW = eye(3);

V = [ dr_dV,   zeros(3);
     zeros(4,3), dq_dW;
     dv_dV,   zeros(3);
     zeros(3),   dw_dW ];

R = [ V*M*V', zeros(N_r, N-N_r);
     zeros(N-N_r, N)];

%update covariance matrix
State.Ekf.Sigma = G*State.Ekf.Sigma*G' + R;


%Update state

%linear velocity
State.Ekf.mu(8:10) = State.Ekf.mu(8:10) + u(1:3);

%angular velocity
State.Ekf.mu(11:13) = State.Ekf.mu(11:13) + u(4:6);

%position
State.Ekf.mu(1:3) = State.Ekf.mu(1:3) + State.Ekf.mu(8:10)*dt;

%quaternion
State.Ekf.mu(4:7) = quat_est(State.Ekf.mu(11:13)*dt,State.Ekf.mu(4:7))






function quaternion = qua_est(W,quaternion_prev)
    mag = (sum(W.^2)).^.5;
     if(mag ~= 0) 
         sin_mag = sin(mag/2.0)/mag;
     else
         sin_mag = 0.5;
    end
    rotation = [cos(mag/2.0);sin_mag*W'];
    a = quaternion_prev(1); b = quaternion_prev(2); c = quaternion_prev(3); d =                                                            quaternion_prev(4);
    quaternion_sqw = [a,-b,-c,-d;
    b, a,-d, c;
    c, d, a,-b;
    d,-c, b, a];

    quaternion = quaternion_sqw*rotation;



function dquat_dw = dqwdt_dW(omega, mag, delta_t)

  %// trigonometric portion of jacobian
  dquat_dw(1, 1) = (-delta_t / 2.0) * (omega(1) / mag) * sin(mag * delta_t / 2.0);
  dquat_dw(1, 2) = (-delta_t / 2.0) * (omega(2) / mag) * sin(mag * delta_t / 2.0);
  dqquat_dw(1, 3) = (-delta_t / 2.0) * (omega(3) / mag) * sin(mag * delta_t / 2.0);
  dquat_dw(2, 1) = delta_t / 2.0) * omega(1)^2 / (mag^2) ...
                    * cos(mag* delta_t / 2.0) ...
                    + (1.0 / mag) * (1.0 - (omega(1)^2) / (mag^2))...
                    * sin(mag * delta_t / 2.0);
  dquat_dw(2, 2) = (omega(1) * omega(2)/ (mag ^2)) * ...
                    ( (delta_t / 2.0) * cos(mag * delta_t / 2.0) ...
                    - (1.0 / mag) * sin(mag * delta_t / 2.0) );
  dquat_dw(2, 3) = (omega(1) * omega(3) / (mag^2)) * ...
                    ( (delta_t / 2.0) * cos(mag * delta_t / 2.0) ...
                    - (1.0 / mag) * sin(mag * delta_t / 2.0) );
  dquat_dw(3, 1) = (omega(2) * omega(1) / (mag^2)) * ...
                    ( (delta_t / 2.0) * cos(mag * delta_t / 2.0) ...
                    - (1.0 / mag) * sin(mag * delta_t / 2.0) );
  dquat_dw(3, 2) = (delta_t / 2.0) * omega(2)^2 / (mag^2) ...
                    * cos(mag * delta_t / 2.0) ...
                    + (1.0 / mag) * (1.0 - omega(2)^2 / (mag^2))...
                    * sin(mag * delta_t / 2.0);
  dquat_dw(3, 3) = (omega(2) * omega(3) / (mag^2)) * ...
                    ( (delta_t / 2.0) * cos(mag * delta_t / 2.0) ...
                    - (1.0 / mag) * sin(mag * delta_t / 2.0) );
  dquat_dw(4, 1) = (omega(3) * omega(1) / (mag^2)) * ...
                    ( (delta_t / 2.0) * cos(mag * delta_t / 2.0) ...
                    - (1.0 / mag) * sin(mag * delta_t / 2.0) );
  dquat_dw(4, 2) = (omega(3) * omega(2) / (mag^2)) * ...
                    ( (delta_t / 2.0) * cos(mag * delta_t / 2.0) ...
                    - (1.0 / mag) * sin(mag * delta_t / 2.0) );
  dquat_dw(4, 3) = (delta_t / 2.0) * omega(3)^2 / (mag^2) ...
                    * cos(mag * delta_t / 2.0) ...
                    + (1.0 / mag) * (1.0 - omega(3)^2 / (mag^2))...
                    * sin(mag * delta_t / 2.0);
