function [ gradient ] = grad( m,seis,zs ,f,dx,dt,recdepth,xs,forward,GW)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
[nt,~]=size(seis);
gradient=zeros(size(m));
j=1;

for i=zs
    
    fw=generate_wavefield(m,nt,xs,i,1,f,dx,dt,recdepth);
    dfw=time_deri(fw,dt,m);
    seis_new=FW(m,i,nt,xs,1,f,dx,dt,recdepth);
    residual_flip=rf(seis(:,:,j),seis_new);
    dfw=GW(m);
    bw=BW(m,residual_flip,nt,1,f,dx,dt,recdepth);
    for I=1:1:nt
    gradient=gradient+ bw(:,:,I).*dfw(:,:,I);
    
    end
    j=j+1;
end

gradient=(2./m.^3).*gradient;
gradient=normalize(gradient,m,zs,nt,xs,f,dx,dt,recdepth,GW);
%gradient=gradient+gradient';
end

