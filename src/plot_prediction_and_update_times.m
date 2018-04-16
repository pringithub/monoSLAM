
function plot_prediction_and_update_times()

load('saved_run.mat');

subplot(2,1,1);
plot(prediction_times*1000,'k-')
axis([0 450 0 6])
ylabel('Prediction Time (ms)','FontSize',12)
%hold on
subplot(2,1,2)
plot(update_times*1000,'k-')
axis([0 450 0 150])
ylabel('Update Time (ms)','FontSize',12)


%legend('Prediction','Update');


end