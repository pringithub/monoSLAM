%% Update particle distribution of given feature
function updateParticleDistribution(LandmarkId, posInFrame)
    global State;
    global Param;

    %Update each particle
    for i = 1:100
        origin = State.Ekf.iM(1:3,LandmarkId);
        direction = Param2WorldCoord(State.Ekf.iM(4:5,LandmarkId));
        
        particlePos = origin + direction * 1/i; % in form [x;y;z] wrt world
        particleInFrame = projection(particlePos);
        State.P.featureProbMatrix(i, index) = State.P.featureProbMatrix(i, index) * normpdf(posInFrame-particleInFrame, 0, SigmaFrame);
        
    end
    
    %normalize weight
    State.P.featureProbMatrix(:, index) = State.P.featureProbMatrix(:, index)/sum(State.P.featureProbMatrix(:, index));
    
    %resample
    resample(LandmarkId);
    
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