load('pfConverge.mat')
figure;

for i = 1:12
    id = 1:6;
    plot(id,k(:,i)); hold on;
end