function [ G ] = normalize( g,m,zs,nt,xs,f,dx,dt,recdepth,GW )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
G=zeros(size(g));
%wavefield=GW(m);
AA=zeros(size(m));

for S=zs
    wavefield=generate_wavefield(m,nt,xs,S,1,f,dx,dt,recdepth);
    for I=1:1:nt
      AA=AA+wavefield(:,:,I).^2;
    end
end

%for i=zs

G=g./(AA +0.001*ones(size(m))).^0.5;

%end
end

