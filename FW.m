function [ seis ] = FW( model,zsn,nt,xs,boundary,f,dx,dt,recdepth)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%model=xlsread('E:\1.IIT Roorkee files\Dissertation 2015-16\my work\layer_model');
%f2=30;f1=10;k=(f2-f1)/((nt-1)*dt);f0=(f1+f2)/2; % klaudar wavelet components
[p,q]=size(model);        
 factor=(model.^2)*(dt^2);      

J=1;

for zs=zsn
    % ricker wavelet
t=(0:1:nt-1)*dt-6/(pi*sqrt(2)*f);
ricker= (1-(t) .*(t) * f^2 *2*pi^2).*exp(- (t).^2 * pi^2 * f^2 ) ;

    % klauder wavelet
%t=(0:1:nt-1)*dt-6/(pi*sqrt(2)*f0);
%ricker=real(((sin(pi*k*t.*(((nt-1)*dt)-t)))./(pi*k*t)).*exp(2*pi*sqrt(-1)*f0*t)); 


u0=zeros(p,q);u1=u0;u2=u0;
    
for it=1:nt
  
   u2 = 2*u1 - u0 +  factor.*del2_5pt(u1,dx);           % 5 point approximation finit difference accoustic
   
   u2(xs,zs) =u2(xs,zs)+ricker(it);                     % add bodypoint source term
    a = u2(recdepth,:); 
    synthetic_seismogram(:,it) = a'; %  seismogram
   
  if boundary == 1
     u2(1,:)=zeros(1,q); u2(p,:)=zeros(1,q); u2(:,1)=zeros(p,1); u2(:,q)=zeros(p,1);
   else
     u2(p,:)=zeros(1,q); u2(:,1)=zeros(p,1); u2(:,q)=zeros(p,1);
  end
  
  if boundary==1
      u2=my_condition(dx,dt,model,u0,u1,u2,boundary);
  end
  
  %if round(it/20)*20==it
   %   imagesc(u2); 
    %  colormap('bone')
     %  pause(0.1)
  %end 
   
   u0=u1;u1=u2; % update pressure field
   u2=zeros(p,q);
end;
a=synthetic_seismogram';
seis(:,:,J)=a;
J=J+1;
end

end

