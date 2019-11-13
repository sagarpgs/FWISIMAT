%% for single source

function [ alpha ] = search( f,P,m,seis,g ,zs,nt,dx,dt,recdepth,xs, freq)
%a=1;
%seis_new=f(m);
%dseis=seis-seis_new;

%while max(max(a*abs(P)))>max(max(abs(m)))/100
 % a=0.5*a;
    
%end

%jd=(f(m+a*P)-seis_new)./a;

%alpha=((jd(:)'*dseis(:))/(jd(:)'*jd(:)));

%% for multiple sources

a=1; j=1;dseis=zeros(size(seis(:,:,1))); jd=dseis;
while max(max(a*abs(P)))>max(max(abs(m)))/100
    a=0.5*a;
end

for i=zs
seis_new=FW(m,i,nt,xs,1,freq,dx,dt,recdepth);
dseis=dseis + (seis(:,:,j)-seis_new);
jd1=FW(m+a*P,i,nt,xs,1,freq,dx,dt,recdepth);
jd=jd+(jd1-seis_new)./a;
j=j+1;

end

alpha=((jd(:)'*dseis(:))/(jd(:)'*jd(:)));

end




