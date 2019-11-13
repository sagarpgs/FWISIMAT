function [Q] = BW( model,residual,nt,boundary,f,dx,dt,recdepth)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [p,q]=size(model);
    q0=zeros(p,q);q1=q0;q2=q0;
    factor=(model.^2)*(dt^2); 
    
for it=1:1:nt
    q2 = 2*q1 - q0 + factor.*del2_5pt(q1,dx);        % 5 point approximation finit difference accoustic
    q2(recdepth,:) =q2(recdepth,:)+ residual(it,:);                 % add residual term ?
   
   if boundary == 1
     q2(1,:)=zeros(1,q); q2(p,:)=zeros(1,q); q2(:,1)=zeros(p,1); q2(:,q)=zeros(p,1);
   else
     q2(p,:)=zeros(1,q); q2(:,1)=zeros(p,1); q2(:,q)=zeros(p,1);
  end

   if boundary==1
      q2=my_condition(dx,dt,model,q0,q1,q2,boundary);
   end

   
   Q(:,:,nt+1-it)=q2;
  
    q0=q1;q1=q2;             % update pressure field
    
   
end

end