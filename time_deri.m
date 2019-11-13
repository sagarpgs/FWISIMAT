function [ dttu ] = time_deri( U,dt,m)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%U=GW(m);
[p,q,r]=size(U);
input=zeros(p,q,r+2);
input(:,:,2:1:r+1)=U;
clear U;
dttu=(1/(dt^2))*(input(:,:,1:1:r)-2*input(:,:,2:1:r+1)+input(:,:,3:1:r+2));

end

