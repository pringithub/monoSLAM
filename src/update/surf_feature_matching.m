function surf_feature_matching(surf_flag)

global State;
global Param;

Img = State.Ekf.img;

%local window to search instead of the whole image
window_match = Param.patchsize_match;

%for all the landmarks present
for k = 1:State.Ekf.nL
    
    features = []; 
    
    % initial patch corresponding to the current landmark
    window_init = State.Ekf.patch_matching{k};
    
    %extracting the surf features if surf_flag is true
    if surf_flag
        [feature_init, ~] = extractFeatures(uint8(window_init), Param.patchsize_match+1 * ones(1,2), ...
        'Method','SURF', 'BlockSize', 2*window_match+1, 'SURFSize',64 );
    else
        feature_init = window_init(:);
    end
    features = [features, feature_init'];
    
    
    % skipping the invalid measurements
    if isempty(State.Ekf.h{k})
        continue;
    end
    
    hk = State.Ekf.h{k};
    Sk = State.Ekf.S{k};
    
    % If the uncertainity of the measurement too high, ignore that and
    % continue
    if eig(Sk) > 500
        continue;
    end
    
    % local search region for observing the actual measurement z
    search_reg = 2 * sqrt(diag(Sk));
    search_reg = max(window_match, min(2*window_match, search_reg));
    
    %detecting the corners in the region defined by zhat(present in hk) and search_reg
    r1 = max(1,round(hk(2)-search_reg(2)));
    r2 = min(round(hk(2)+search_reg(2)),size(State.Ekf.img,1));
    c1 = max(1,round(hk(1)-search_reg(1)));
    c2 = min(round(hk(1)+search_reg(1)),size(State.Ekf.img,2));
    
    fin_region = Img( r1:r2, c1:c2);
    cor_points = detectMinEigenFeatures(uint8(fin_region));
    
    if isempty(cor_points)
            State.Ekf.individually_compatible(k) = 0;
            State.Ekf.z{k} = [];
            continue;
    end
    
    uvs = double([cor_points.Location(:,1) + max(1,round(hk(1)-search_reg(1))) - 1, ...
            cor_points.Location(:,2) + max(1,round(hk(2)-search_reg(2))) - 1]);
    
    if surf_flag
        [new_feature, ~] = extractFeatures( uint8(State.Ekf.img), uvs, ...
            'Method', 'SURF', 'BlockSize', 2*sw+1, 'SURFSize', 64);
    else
        new_feature = State.Ekf.patch_matching{k}(:);
    end
    
    features = [features, new_feature'];
    
    % calculating the correlation between the features
    corr_matrix = corrcoef(features);
    [corr, idx] = sort( corr_matrix(1,2:end), 'descend' );
    
    epsilon = 0.8; % threshold to check the correlation coefficient
    
    State.Ekf.individually_compatible(k) = 0;
    State.Ekf.z{k} = [];
    for i = 1:length(corr)
        State.Ekf.z{k} = uvs(idx(i),:)';
        if corr(i) > epsilon && is_valid_measurement( uvs(idx(i),:) )
            State.Ekf.individually_compatible(k) = 1;
            break;
        end
        
        if corr(i) < epsilon
            break;
        end
    end
end
