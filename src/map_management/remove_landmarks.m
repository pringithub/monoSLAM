function remove_landmarks(idx)
% deletes landmarks from state vector that are inconsistent
% input: index of landmarks in full state vector that will be deleted

global State;

dimX = State.Ekf.dimR;
dimL = State.Ekf.dimL;

% if index vector is not empty then remove index from state vector
while ~isempty(idx)
    i = idx(1);
    iL = State.Ekf.iL{i}; % index of landmark that will be removed
    
    State.Ekf.mu(iL) = []; % removes landmark from state vector
    State.Ekf.Sigma(iL,:) = []; % removes part of landmark in covariance
    State.Ekf.Sigma(:,iL) = []; % removes the remaining part of landmark in covariance
    
    for j = i+1:State.Ekf.nL
        State.Ekf.iL{j} = State.Ekf.iL{j} - dimL; % correct indexing of remaining landmarks
    end
    State.Ekf.iM(iL(end)+1:end) = State.Ekf.iM(iL(end)+1:end) - dimL; % shift landmarks in map oe position over
    
    % Remove landmark from all other State parameters
    State.Ekf.iM(i) = [];
    State.Ekf.iL(i) = [];
%    State.Ekf.sL(i) = [];
    State.Ekf.z(i) = [];
    State.Ekf.h(i) = [];
    State.Ekf.H(i) = [];
    State.Ekf.S(i) = [];
    State.Ekf.Q(i) = [];
    State.Ekf.status(i) = [];
    State.Ekf.matched(i) = [];
    State.Ekf.match_attempts(i) = [];
    State.Ekf.individually_compatible(i) = []; 
    State.Ekf.init_t(i) = [];
    State.Ekf.init_z(i) = [];
    State.Ekf.init_x(i) = [];
    State.Ekf.patch_matching(i) = [];
    
    % Update landmark count
    State.Ekf.nL = State.Ekf.nL - 1;
    
    % Update indexes after removing the one landmark
    idx(1) = [];
    idx = idx-1;

end


