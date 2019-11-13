function [ a ] =rf( s1,s2 )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
s=s1-s2;
[p,q]=size(s);
a(1:1:p,:)=s(p:-1:1,:);

end

