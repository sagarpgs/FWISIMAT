function [ U ] = generate_wavefield( model,nt,xs,zs, boundary,f,dx,dt,recdepth)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%f2=30;f1=10;k=(f2-f1)/((nt-1)*dt);f0=(f1+f2)/2;

[p,q]=size(model);
t=(0:1:nt-1)*dt -6/(pi*sqrt(2)*f);
ricker= (1-(t) .*(t) * f^2 *2*pi^2).*exp(- (t).^2 * pi^2 * f^2 ) ;

%t=(0:1:nt-1)*dt-6/(pi*sqrt(2)*f0);
%ricker=real(((sin(pi*k*t.*(((nt-1)*dt)-t)))./(pi*k*t)).*exp(2*pi*sqrt(-1)*f0*t));

u0=zeros(p,q);u1=u0;u2=u0;
factor=(model.^2.*dt^2); 

for it=1:1:nt
    
    u2 = 2*u1 - u0 +  factor.*del2_5pt(u1,dx);    % 5 point approximation finit difference accoustic
     wave=factor.*del2_5pt(u1,dx)/dt*dt;
    u2(xs,zs) =  u2(xs,zs)+ricker(it); % add bodypoint source term
     wave(xs,zs)=wave(xs,zs)+ricker(it);
   
   if boundary == 1
     u2(1,:)=zeros(1,q); u2(p,:)=zeros(1,q); u2(:,1)=zeros(p,1); u2(:,q)=zeros(p,1);
   else
     u2(p,:)=zeros(1,q); u2(:,1)=zeros(p,1); u2(:,q)=zeros(p,1);
  end

   if boundary==1
      u2=my_condition(dx,dt,model,u0,u1,u2,boundary);
   end
 
   U(:,:,it)=u2;
     
   u0=u1;u1=u2; % update pressure field
  
end
end

