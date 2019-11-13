clear all; close all; clc;

%% Define your real and initial model and parameters.

model=3000*ones(150,150); model(75:150,:)=4000; % Model definition
%model = awgn(model,50,'measured'); % Add white gaussian noise if necessary
%model(50:1:70,:)=4;   % initial model

%load('model.mat'); 

nt=550; % Time sampling
xs=10; zs=75;%zs=10:10:140;  % Source position (eg. make zs=10:10:140 for multiple sources)
recdepth=2;   % receriver line position
f=20;  % Peak frequency of source  
                                            
v=max(max(model)); 
dx=0.015; % vertical resolution (dx < v/(f*4))
dt=(0.6*dx)/v;   % 5 point approximation stability
     %t=(0:1:nt-1)*dt-6/(pi*sqrt(2)*f);
[p,q]=size(model);
[X,Y]=size(model);X=1:1:X; Z=1:1:Y;
m=gaussian_smoother(model,Z,X,6);   % initial model: smooth gaussian
%m=3*ones(150,150);
initial= m; % for saving purpose
factor=(model.^2)*(dt^2); 
%m = awgn(m,60,'measured');         
clear X Y;
%% Make some handy function handles

forward=@(m)FW(m,zs,nt,xs,1,f,dx,dt,recdepth); % handle of forward modelling function
seis=forward(model);  % crate seismogram

F=@(m)objective_f(m,seis,zs,f,dx,dt,recdepth,xs); % handle of objective function
GW=@(m)generate_wavefield(m,nt,xs,zs,1,f,dx,dt,recdepth); % handle of generate_wavefield function



%% Compute the gradient

gradient = grad_parallel(m,seis,zs,f,dx,dt,recdepth,xs,forward,GW); % Reverse time migration technique
% imagesc(gradient)

%% Nonlinear Conjugate gradient optimization 

k=1;
H=eye(size(m));
while (norm(gradient)>1e-20 && k<=10) % set your consitions for the iterative optimization
            
 objval(k)=F(m);   % store the objective function at each iteration
                
          if (k==1)
             P = -gradient;   % direction for 1st iteration
          else
             P = -gradient+beta.*P;    % conjugate direction 
            %yk=gradient_new-gradient;
            %sk=m_new-m;
            %tau=((yk(:)'*sk(:))/norm(sk'*H*sk));
            %H=tau.*H;
            %H=H-(H*(sk*sk')*H)/norm(sk'.*H.*sk)+(yk*yk')/norm(sk'.*yk);
           % P=-(H\gradient);
           % m = m_new; gradient = gradient_new;
          end
                     
              alfa=search(forward,P,m,seis,gradient,zs,nt,dx,dt,recdepth,xs, f); %step lenght
              m_new = m + alfa*P;       % update your model
              
              gradient_new = grad_parallel(m_new,seis,zs,f,dx,dt,recdepth,xs,forward,GW);
              
              beta1=sum(sum(gradient_new(:)'*(gradient_new(:)-gradient(:))))/sum(sum(P(:)'*(gradient_new(:)-gradient(:))));
              beta2=sum(sum(gradient_new(:)'*gradient_new(:)))/sum(sum(P(:)'*(gradient_new(:)-gradient(:))));
              
              beta = max(0,min(beta1,beta2));  % hybrid scheme for choosing beta
              clc;
              display(k);  k = k+1; % iteration number
              
              m = m_new; gradient = gradient_new;
              
                    % watch animation of improvement
                    imagesc(m, [min(min(model)) max(max(model))]) 
                     
                    xlabel('Horizontal Distance (m)'), ylabel('Depth (m)')
                    title(['FINAL MODEL at iteration ', num2str(k), 'th'] )
                    h=colorbar; ylabel(h, 'Velocity (m/s)')
                    pause(0.1)
end

%% Full waveform inversion results

subplot(2,2,1)
imagesc(model, [min(min(model)) max(max(model))])
xlabel('Horizontal Distance (m)'), ylabel('Depth (m)')
title('REAL MODEL')
h=colorbar; ylabel(h, 'Velocity (m/s)')

subplot(2,2,2)
imagesc(initial, [min(min(model)) max(max(model))])
xlabel('Horizontal Distance (m)'), ylabel('Depth (m)')
title('INITIAL MODEL')
h=colorbar; ylabel(h, 'Velocity (m/s)')

subplot(2,2,3)
imagesc(m, [min(min(model)) max(max(model))]) 
xlabel('Horizontal Distance (m)'), ylabel('Depth (m)')
title('FINAL MODEL')
h=colorbar; ylabel(h, 'Velocity (m/s)')

subplot(2,2,4)
plot(objval)
xlabel('Number of iteration'), ylabel('value')
title('OBJECTIVE FUNCTION')
