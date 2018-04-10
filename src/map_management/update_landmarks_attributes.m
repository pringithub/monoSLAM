function update_landmarks_attributes

global State;

for i = 1:State.Ekf.nL
    % for every landmark increment match attempts
    if ~isempty( State.Ekf.h{i} )
        State.Ekf.match_attempts(i) = State.Ekf.match_attempts(i) + 1;
    end
    if State.Ekf.individually_compatible(i)
        State.Ekf.matched(i) = State.Ekf.matched(i) + 1;
    end

    State.Ekf.individually_compatible(i) = 0;
    State.Ekf.h{i} = [];
    State.Ekf.z{i} = [];
    State.Ekf.H{i} = [];
    State.Ekf.S{i} = [];
end
