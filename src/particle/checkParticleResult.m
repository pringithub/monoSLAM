%% Compute each available feature's standard deviation, and convert the feauture with best-estimated depth distribution to a standard Gaussian one. If no features are good enough, return NaN.

function checkParticleResult()
    global State;
    global Param;
    
    stdv = zeros(State.Ekf.nL, 1);
    
    % set a threshold here.
    thres = inf;
    
    State.P.rhoMean = zeros(State.Ekf.nL,1);
    State.P.rhoVar = zeros(State.Ekf.nL,1);
    
    for i = 1:1:State.Ekf.nL
        stdv(i) = std(State.P.featureProbMatrix(i,:));
        
        % Not used in Ekf Update
        if stdv(i) < thres
            State.P.validAsLandmark(i) = 1;
        else
            State.P.validAsLandmark(i) = 0;
        end
        
        for j = 1:100
            State.P.rhoMean(i) = State.P.rhoMean(i) + State.P.featureInverseDepth(i, j) * State.P.featureProbMatrix(i, j);
        end
        
        for j = 1:100
            emex = State.P.featureInverseDepth(i,j) - State.P.rhoMean(i);
           State.P.rhoVar(i) = State.P.rhoVar(i) + emex*emex' *  State.P.featureProbMatrix(i, j);
        end
    end
   
end
