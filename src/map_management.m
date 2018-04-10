function map_management()
% check the total number of landmarks and
% detect new landmarks from the image, or
% delete inappropriate landmarks from the map

global State;
global Param;

% delete landmarks that have not been matched 
% or re-detected in multiple frames therefore we iterate
% through every landmark in full state vector

rem_li_idx = [];
for i = 1:State.Ekf.nL
    iL = State.Ekf.iL{i}; % current landmark index
    mi = State.Ekf.mu(iL); % current landmark state
    
    % ratio of current landmark associations over attemps to make
    % association. if the ratio is small, the landmark is interpreted as
    % not being consistent and is deleted
    ratio = State.Ekf.matched(i)/State.Ekf.match_attempts(i); 
    if (State.Ekf.match_attempts(i) > 10 && ratio < 0.5)
        rem_li_idx = [rem_li_idx, i];
    end

end
remove_landmarks(rem_li_idx);
measured = sum(State.Ekf.individually_compatible);

% detect new landmarks if total number of landmarks
% is less than threshold

if State.Ekf.nL == 0 % case when initializing    
    detect_corners(Param.map.min_nL);    
else
    if measured < Param.map.min_nL % detect more landmarks if under threshold
        corner_detection(Param.map.min_nL-measured);
    end
end

update_landmarks_attributes();
