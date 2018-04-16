

function create_dir_from_vid(video_filename,save_folder)

v = VideoReader(video_filename);

i = 0;
while hasFrame(v)
    img = rgb2gray( readFrame(v) );
    img = img(1:3:end,1:3:end)';
    
    img_filename = sprintf('%s/img%010d.jpg',save_folder,i);
    imwrite(img, img_filename, 'jpg');
    i = i+1;
end



end