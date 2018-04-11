%% Update particle distribution of given feature
% Input:
%   - landmarkId: sequence in all landmarks
%   - landmarkPosition: pos in world coordinate, in terms of [x0,y0,z0, theta, phi, rho]
%   - posInFrame: detected pos in current frame

function updateParticleDistribution(landmarkId, landmarkPosition, posInFrame)
    global State;
    global Param;
    
    cam_pose = State.Ekf.mu(1:13);
    R = q2r(cam_pose(4:7));

    %Update each particle
    for i = 1:100
        origin = State.Ekf.iM(1:3,landmarkId);
        direction = Param2WorldCoord(State.Ekf.iM(4:5,landmarkId));
        
        theta = landmarkPosition(4);
        phi = landmarkPosition(5);
        rho = State.P.featureInverseDepth(landmarkId, i);
        
        dir_vec = R' *( (landmark_i(1:3)-cam_pose(1:3)) * rho + ...
              [cos(phi).*sin(theta), -sin(phi), cos(phi).*cos(theta)]' );  
          
        particle_projection = camera_projection(dir_vec);
        
        SigmaFrame = [1 0; 0 1];
        State.P.featureProbMatrix(i, index) = State.P.featureProbMatrix(i, index) * normpdf(posInFrame-particle_projection, 0, SigmaFrame);
        
    end
    
    %normalize weight
    State.P.featureProbMatrix(:, index) = State.P.featureProbMatrix(:, index)/sum(State.P.featureProbMatrix(:, index));
    
    %resample
    resample(landmarkId);
    
end

function resample(LandmarkId)
    global State;
    global Param;

    x_new = [];
    w_new = [];
    c = zeros(100,1);
    u = zeros(100,1);
    c(1) = State.P.featureProbMatrix(index,1);% m*100    
    for i = 2:100
        c(i) = c(i-1) + State.P.featureProbMatrix(LandmarkId,i);
    end
    u(1) = unifrnd(0,1/numParticle);
    i = 1;
    
    for j = 1:100
        while u(j) > c(i)
            i = i+1;
        end
        x_new = [x_new State.P.featureInverseDepth(LandmarkId,i)]; %m*100
        %x_new = [x_new; particlePosMatrix(i,3*index-2:3*index)];
        w_new = [w_new 1/100];
        u(j+1) = u(j) + 1/100;
    end
    
    State.P.featureInverseDepth(LandmarkId,:) = x_new;
    State.P.featureProbMatrix(LandmarkId,:) = w_new;
end
