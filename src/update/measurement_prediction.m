function measurement_prediction()

% Predicts the measurement zhat
global State;
global Param;

cam_params = Param.camera;

cam_pose = State.Ekf.mu(1:13); % Camera pose
landmarks = State.Ekf.mu(14:end); % Landmarks in the Map

R = q2r( cam_pose(4:7) ); % Get the Rotation matrix from quaternion

nL = State.Ekf.nL;
dimL = State.Ekf.dimL; 

for i = 1:nL
    idx = 13+(i-1)*dimL;
    landmark_i = State.Ekf.mu(idx:idx+dimL);
    
    % Direction from camera to the landmark
    theta = landmark_i(4);
    phi = landmark_i(5);
    rho = landmark_i(6);
    dir_vec = R' *( (landmark_i(1:3)-cam_pose(1:3)) * rho + ...
              [cos(phi).*sin(theta), -sin(phi), cos(phi).*cos(theta)]' );  
    
    % projective camera model
    landmark_projection = camera_projection( dir_vec );
    
    % radial distortion
    zhat(:,i) = distort_fm( landmark_projection );
    
    if is_valid_measurement(zhat(:,i)) == false
        State.Ekf.h{i} = []; 
        State.Ekf.H{i} = [];
        State.Ekf.Q{i} = [];
        State.Ekf.S{i} = [];
        State.Ekf.status(i) = 0;
        continue;
    end
    
    State.Ekf.h{i} = zhat(:,i);
    Hi = calculate_Hi( cam_pose, landmark_i, zhat(:,i), cam_params, i, nL );
    Qi = eye(2) * Param.sigma.image_noise^2;
    Si = Hi * State.Ekf.Sigma * Hi' + Qi;
    State.Ekf.H{i} = Hi;
    State.Ekf.Q{i} = Qi;
    State.Ekf.S{i} = Si; 
end