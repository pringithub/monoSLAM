%% This function is the main function of Landmark initialization part

% Inputs:
%     - feature's corresponding coordinates in the image            cell of 2*1
%     position, for example {[100;100], NaN, [300;100]}


% every feature must be initialed when this functing is begin called
function updateParticle()

%debug msg
%fprintf('function updateParticle\n');

global State;
global Param;



for i = 1:State.Ekf.nL
    % If current feature is already being used by the EKF system, ignore
    % and process the next feature
%     if (State.Ekf.individually_compatible(i) == 1)
%         continue;
%     end
    
    % update current feature if theres a match
    if State.P.firstTimeInit(i) == 1
        State.P.firstTimeInit(i) = 0;
        continue;
    end
    
    if State.Ekf.individually_compatible(i) == 1
        fprintf(strcat('Update particle: ', num2str(i),'\n'));
        updateParticleDistribution(i, State.Ekf.z{i});
    end
    
end
%debug msg
%fprintf('function updateParticle finished\n');

end
