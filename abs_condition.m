function [ u2 ] = abs_condition( u0,u1,u2,velocity,dt,dx,boundary )
[p,q]=size(velocity);
%u0=zeros(p+2,q+2); u1=u0;u2=u0; 
%u1(2:1:p+1,2:1:q+1)=input1; u0(2:1:p+1,2:1:q+1)=input0; u2(2:1:p+1,2:1:q+1)=input2;

% for bottom boundary
 u2(p,2:1:q-1)=2*u1(p,2:1:q-1)-u0(p,2:1:q-1)+...
     ((velocity(p,2:1:q-1).^2)*(dt^2)/2*dx^2).*(u1(p,1:1:q-2)-2*u1(p,2:1:q-1)+u1(p,3:1:q))-...
     (velocity(p,2:1:q-1)*dt^2/(2*dt*dx)).*(u2(p,2:1:q-1)-u2(p-1,2:1:q-1)-u1(p,2:1:q-1)+ u1(p-1,2:1:q-1));   
 
% for left boundary
 u2(2:1:p-1,1)=2*u1(2:1:p-1,1)-u0(2:1:p-1,1)+...
     ((velocity(2:1:p-1,1).^2)*(dt^2)/2*dx^2).*(u1(1:1:p-2,1)-2*u1(2:1:p-1,1)+u1(3:1:p,1))...
     +(velocity(2:1:p-1,1)*dt^2/(2*dt*dx)).*(u2(2:1:p-1,2)-u2(2:1:p-1,1)-u1(2:1:p-1,2)+u1(2:1:p-1,1));     
 
% for right boundary
 u2(2:1:p-1,q)=2*u1(2:1:p-1,q)-u0(2:1:p-1,q)+...
     ((velocity(2:1:p-1,q).^2)*(dt^2)/2*dx^2).*(u1(1:1:p-2,q)-2*u1(2:1:p-1,q)+u1(3:1:p,q))-...
     (velocity(2:1:p-1,q)*dt^2/(2*dt*dx)).*(u2(2:1:p-1,q)-u2(2:1:p-1,q-1)-u1(2:1:p-1,q)+u1(2:1:p-1,q-1));
 
 % for top boundary
    u2(1,2:1:q-1)=2*u1(1,2:1:q-1)-u0(1,2:1:q-1)+...
     ((velocity(1,2:1:q-1).^2)*(dt^2)/2*dx^2).*(u1(1,1:1:q-2)-2.*u1(1,2:1:q-1)+u1(1,3:1:q))+...
     (velocity(1,2:1:q-1)*dt^2/(2*dt*dx)).*(u2(2,2:1:q-1)-u2(1,2:1:q-1)-u1(2,2:1:q-1)+ u1(1,2:1:q-1)); 

%u2(2,2:1:q+1)=0;


%output=u2(2:1:p+1,2:1:q+1);
end


