function normalize_state_quaternion()

global State;

dimX = length( State.Ekf.mu );

q = State.Ekf.mu(4:7);
State.Ekf.mu(4:7) = q / norm(q);

qr = q(1);
qi = q(2);
qj = q(3);
qk = q(4);

Q = [ qi^2+qj^2+qk^2,         -qr*qi,         -qr*qj,         -qr*qk;
              -qr*qi, qr^2+qj^2+qk^2,         -qi*qj,         -qi*qk;
              -qr*qj,         -qi*qj, qr^2+qi^2+qk^2,         -qj*qk;
              -qr*qk,         -qi*qk,         -qj*qk, qr^2+qi^2+qj^2 ];
Q = Q * dot(q,q)^(-3/2);

N = blkdiag( eye(3), Q, eye(dimX-7) );

State.Ekf.Sigma = N * State.Ekf.Sigma * N';