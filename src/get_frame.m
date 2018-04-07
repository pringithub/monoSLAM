%% get_frame.m

function img = get_frame(frameId)

global Param;

% comment out lines below if not testing
Param.img.dir = '../data/dataset1/color/';
files = dir( sprintf('%s/r-*.jpg', Param.img.dir) );


try
    img_filename = sprintf( '%s%s', Param.img.dir, files(frameId).name );
    img = rgb2gray( imread(img_filename) );
catch err
    error( 'get_frame.m :: % not existent', img_filename );
end

end