%% Update particle distribution of given feature
function updateParticleDistribution(LandmarkId, posInframe)
    global particleId;
    global particlePosMatrix;
    global SigmaFrame;
    global particleProbMatrix;

    index = find(particleId == LandmarkId);

    %Update each particle
    for i = 1:100
        particlePos = (particlePosMatrix(i,3*index-2:3*index))'; % in form [x;y;z] wrt world
        particleInFrame = projection(particlePos);
        particleProbMatrix(i, index) = particleProbMatrix(i, index) * normpdf(posInframe-particleInFrame, 0, SigmaFrame);
        
    end
    
    %normalize weight
    particleProbMatrix(:, index) = particleProbMatrix(:, index)/sum(particleProbMatrix(:, index));
    
    %resample
    resample();
    
end

function resample()
    global particleProbMatrix;
    global particlePosMatrix;

    x_new = [];
    w_new = [];
    c = zeros(100,1);
    u = zeros(100,1);
    c(1) = particleProbMatrix(1, index);
    for i = 2:100
        c(i) = c(i-1) + particleProbMatrix(i, index);
    end
    u(1) = unifrnd(0,1/numParticle);
    i = 1;
    
    for j = 1:100
        while u(j) > c(i)
            i = i+1;
        end
        x_new = [x_new; particlePosMatrix(i,3*index-2:3*index)];
        w_new = [w_new; 1/100];
        u(j+1) = u(j) + 1/100;
    end
    
    particlePosMatrix(:, 3*index-2:3*index) = x_new;
    particleProbMatrix(:, index) = w_new;
end