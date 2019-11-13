function [ data ] = mydata(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


[T1,texthead,binaryhead,extendedhead]=SEGY_read('E:\1.IIT Roorkee files\Dissertation 2015-16\My Work\seismic data\radexpro data\0_source.sgy');
[T2,texthead,binaryhead,extendedhead]=SEGY_read('E:\1.IIT Roorkee files\Dissertation 2015-16\My Work\seismic data\radexpro data\11_source.sgy');
[T3,texthead,binaryhead,extendedhead]=SEGY_read('E:\1.IIT Roorkee files\Dissertation 2015-16\My Work\seismic data\radexpro data\23_source.sgy');
[T4,texthead,binaryhead,extendedhead]=SEGY_read('E:\1.IIT Roorkee files\Dissertation 2015-16\My Work\seismic data\radexpro data\35_source.sgy');
[T5,texthead,binaryhead,extendedhead]=SEGY_read('E:\1.IIT Roorkee files\Dissertation 2015-16\My Work\seismic data\radexpro data\47_source.sgy');

%data(:,:,1)=T1.tracedata.data./max(max(abs(T1.tracedata.data)));
%data(:,:,2)=T2.tracedata.data./max(max(abs(T2.tracedata.data)));
data=T3.tracedata.data./max(max(abs(T3.tracedata.data)));
%data(:,:,4)=T4.tracedata.data./max(max(abs(T4.tracedata.data)));
%data(:,:,5)=T5.tracedata.data./max(max(abs(T5.tracedata.data)));
end

