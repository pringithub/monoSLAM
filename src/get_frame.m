%% get_frame.m

function img = get_frame(frameId)

global Param;



try
    img_filename = sprintf( '%s%s', Param.img.dir, Param.img.files(frameId).name );
    img = imread(img_filename);%rgb2gray( imread(img_filename) );
catch err
    error( 'get_frame.m :: % not existent', img_filename );
end

end