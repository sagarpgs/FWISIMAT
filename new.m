subplot(1,3,1)
plot(v(:,200),1:1:200)
hold on
plot(model(:,200),1:1:200)
hold on
plot(initial(:,200),1:1:200)

subplot(1,3,2)
plot(v(:,400),1:1:200)
hold on
plot(model(:,400),1:1:200)
hold on
plot(initial(:,400),1:1:200)

subplot(1,3,3)
plot(v(:,600),1:1:200)
hold on
plot(model(:,600),1:1:200)
hold on
plot(initial(:,600),1:1:200)

