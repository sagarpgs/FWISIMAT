clear all; clc;
f0=2;t0=1/f0;
k=1;
for f=0:0.1:400
ricker(k)=abs((2/sqrt(pi))*(f^2/f0^3)*(exp(-f^2/f0^2))*(exp(-2*sqrt(-1)*pi*f*(t0-10000))));
k=k+1;
end
plot(ricker(:,1:1:200))