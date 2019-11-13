function [output]=del2_5pt(input,delx)


[nrows,ncolumns]=size(input);

input2=zeros(nrows+2,ncolumns+2);
input2(2:nrows+1,2:ncolumns+1)=input;
factor=1/(delx^2);
clear input


% for first dimension

   output = (input2(3:nrows+2,2:ncolumns+1) - 2.*input2(2:nrows+1,2:ncolumns+1) +...
                  input2(1:nrows,2:ncolumns+1))*factor;

% for second dimension 

 output = (input2(2:nrows+1,3:ncolumns+2) - 2.*input2(2:nrows+1,2:ncolumns+1) +...
                 input2(2:nrows+1,1:ncolumns))*factor+ output;

