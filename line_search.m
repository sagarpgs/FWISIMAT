function [ alpha_armijo ] = line_search( alpha,m,P,seis,G,F,zs,f,dx,dt,recdepth,xs )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

        delta = 0.5;
        gamma =0.5*1e-5;
       
    j    = 1;
    while (j>0)
        x_new=m-alpha*P; 
     
      
       if F(x_new)<=F(m)-gamma*alpha*(norm(G'*P)) && (norm((grad(x_new,seis,zs,f,dx,dt,recdepth,xs))'*P)<=0.9*norm(G'*P))
            
           alpha_armijo = alpha; 
        
           j=0;
        else
           alpha = alpha*delta;
        end
    end
end

