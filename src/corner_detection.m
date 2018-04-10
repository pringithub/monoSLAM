%To detect new features in the image
%It takes the input as the number of features to be detected

function uv = corner_detection( num_feat )

global State;
global Param;

img = State.Ekf.img;

%initializeing the new features in a empty vector
uv = [];
index = 1;
count = 0;
bounding_box = 30;

%taking the complete image and detecting the strongest corner points
cornerpoints = detectMinEigenFeatures(uint8(img));
st_points = cornerpoints.selectStrongest(200);
%random selection of landmark candidates
rp = randperm(size(st_points,1));
location = st_points.Location(rp,:);
nloc = size(location,1);

%to visualize the current image
if Param.do_visualize
    figure,
    imshow(unit8(img));
    hold on;
end

%predicted measurement
zhat = [];
u = [];
v = [];

for i = 1:State.Ekf.nL
    %projecting the landmarks on to the image plane
    zhat(:,i) = hi_inverse_depth(State.Ekf.mu(State.Ekf.iL{i}),State.Ekf.mu(1:3),q2r(State.Ekf.mu(4:7)));
end

%only considering those measurements whihc are compatible
zhat (:, State.Ekf.individually_compatible > 0);

while count < num_feat
    zhat = [zhat [u;v]];
    num_z = size(zhat,2);
    for i = index:nloc
        cnt = 0;
        for j = 1:num_z
            if isempty(zhat)
                continue;
            end
            plot (zhat(1,i),zhat(2,i), 'g*', 'MarkerSize', 10);
            hold on;
            
            if location(i,1)>= zhat(1,j) - bounding_box ...
                && location(i,1)<= zhat(1,j) + bounding_box ...
                && location(i,2)>= zhat(2,j) - bounding_box ...
                && location(i,2)<= zhat(2,j) + bounding_box
            else
                cnt = cnt + 1;
            end
        end
        if (cnt == num_z)
            u = location(i,1);
            v = location(i,2);
            break;
        end
    end
    uv = double([u ; v]);
    
    index = i+1;
    
    if isempty(uv)
        continue;
    end
    uv = min(max(1,round(uv)), [size(img,2);size(img,1)]);
    if ~is_valid_measurement(uv)
        u = [];
        v = [];
        continue;
    end
    add_new_features(uv);
    plot(u,v,'ro','Markersize',10);
    count = count + 1;
end

disp('corner detection is complete');
            
        
