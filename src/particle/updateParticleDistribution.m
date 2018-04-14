%% Update particle distribution of given feature
% Input:
%   - landmarkId: sequence in all landmarks
%   - landmarkPosition: pos in world coordinate, in terms of [x0,y0,z0, theta, phi, rho]
%   - posInFrame: detected pos in current frame

function updateParticleDistribution(landmarkId, posInFrame)
    global State;
    global Param;
    
    cam_pose = State.Ekf.mu(1:13);
    R = q2r(cam_pose(4:7));
    
    idx = 13+(landmarkId-1)*State.Ekf.dimL;
    landmark_i = State.Ekf.mu(idx:idx+State.Ekf.dimL);

    pd = zeros(100,2);
    rt = zeros(100,1);
    %Update each particle
    for i = 1:100
        %debug msg
        %fprintf(strcat('iter = ', num2str(i), i, '\n'));
        
        theta = landmark_i(4);
        phi = landmark_i(5);
        rho = State.P.featureInverseDepth(landmarkId, i);
        
        dir_vec = R' *( (landmark_i(1:3)-cam_pose(1:3)) * rho + ...
            [cos(phi).*sin(theta), -sin(phi), cos(phi).*cos(theta)]' ); 
        
        particle_projection = distort_fm(camera_projection(dir_vec));
        
        rt(i) = rho;
        pd(i,:) = (posInFrame-particle_projection)';
        %i
        %dir_vec
        %particle_projection
        %fprintf(strcat('rho ', num2str(rt(i)), 'pd: ', num2str(pd(i)),'\n'));
        
        State.P.featureProbMatrix(landmarkId, i) = State.P.featureProbMatrix(landmarkId, i) * normpdf(norm(posInFrame-particle_projection), 0, 1);
        
    end
    
    
    %normalize weight
    State.P.featureProbMatrix(landmarkId, :) = State.P.featureProbMatrix(landmarkId, :)/sum(State.P.featureProbMatrix(landmarkId, :));
    
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
    c(1) = State.P.featureProbMatrix(LandmarkId,1);% m*100    
    for i = 2:100
        c(i) = c(i-1) + State.P.featureProbMatrix(LandmarkId,i);
    end
    u(1) = unifrnd(0,1/100);
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