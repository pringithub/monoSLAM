%% This function is the main function of Landmark initialization part

% Inputs:
%     - feature's corresponding coordinates in the image            cell of 2*1
%     position, for example {[100;100], NaN, [300;100]}


% every feature must be initialed when this functing is begin called
function UpdateParticle(posInFrame)
global State;
global Param;


for i = 1:State.Ekf.nL
    % If current feature is already being used by the EKF system, ignore
    % and process the next feature
    if (State.Ekf.individually_compatible(landmarkId) == 1)
        continue;
    end
    
    % update current feature if it's available in current frame
    if ~isnan(posInFrame{i})
        updateParticleDistribution(i, posInFrame{i});
    end
    
end


end