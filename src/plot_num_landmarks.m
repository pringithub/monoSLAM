%% MonoSLAM: Plot number of landmarks

function plot_num_landmarks()

load('saved_run.mat');

plot(num_landmarks,'k');
grid on;

end
