function plot_image_and_features()

global State;

imshow(State.Ekf.img);
%hold on
%scatter(State.Ekf.h(:,1),State.Ekf.h(:,2),'*');
%hold off

end
