 function [ F ] = objective_f( m,seis,zs,f,dx,dt,recdepth,xs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[A,B,C]=size(seis);
        
J=1;
F=0;

for i=zs
	
	a=FW(m,i,A,xs,1,f,dx,dt,recdepth);
   
	F=F+((norm(seis(:,:,J)-a))^2)/2;
	
	J=J+1;
	clear a;
end
  
end

