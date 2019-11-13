function [seis,ntr,fmt,dsrt,dom,x,t0,nsamps,dt,nx,sh,tr,rp,trp,trcid]=readsegy(filenm,a1,a2)
%
% Reads an SEG-Y trace into "ans"
% arguments:
% filename - The name of the SEG-Y file to be read
% a1 - The shot/rp number of the trace to be read
% a2 - The trace number to be read.
%
% Short program-driver for reading SEGY files
%    The SEGY binary tape header parameters passed here are
%    (all of them of 1x1 size, because it is a tape header,
%    so you have to write it out just once):
%    seis(nsamps by nx) Seismogram data
%    ntr   : Number of traces per shot (or record)
%    fmt  : SEGY format type, >4, "host" floating point
%    dsrt  : How is data sorted. 0 or 1 by shots; 2 by CDP gathers
%    dom   : The domain  of the data (0 or 1 - time, 7 - tau-p, etc.)
 
%       Variables are in the two temporary arrays -
%       lbuf holds long integers and ibuf holds short integers
 
%    The header parameters passed here are:
%    x (nx by 1) :  Range in km
%    t0(nx by 1) :  Start time in sec
%%%    id(nx by 1) :  Trace index integer (ie 1 through nx)
%    nsamps(nx by 1) :  Number of samples per trace
%    dt(1  by 1) :  Sample interval in sec/sample
%    nx          :  Number of traces written in
%    sh          :  Shot number
%    tr          :  Trace within the shot
%    rp          :  RP or CDP number
%    trp         :  Trace number within RP or CDP
%    trcfid      :  Trace ID; live = 1

fno = str2num(a1);
ftr = str2num(a2);
%   Open file and read the "tape" header
 
fid = fopen(filenm, 'r');
if fid == -1
    error('error opening SEG-Y file')
end

%   Read the EBCDIC header, putting into temp arrays
%   Useful information for subsequent writing is stored in appropriate variables
 
thbuf1 = fread(fid,3200)';
%disp( 'EBCDIC tape header ')
thbuf1(1,1);
%fseek(fid,3200,0);
thbuf2 = fread(fid,200,'short')';
ntr = thbuf2(7);
fmt = thbuf2(13);
dsrt = thbuf2(15);
dom = thbuf2(31);
tst = thbuf2(200);
 
if (fmt == 1)
  exit('Cannot read IBM floating point format');
end
 
%   Next read the trace headers and data, putting into temp arrays
%   Reads each header twice, first putting into ibuf in short int format
%   then into lbuf in long int format
%   Array ibuf is (nx by 120) and array lbuf is (nx by 60)
 
buftr = 40;   % Size of buffer increments
nx = 0;       % Number of traces read
nread = 0;
 
doit = 1;
while (doit)
%  T1 = fread(fid,120,'short')';
  T1 = fread(fid,120,'int16')';
  if (feof(fid) == 1) break; end
  nread = nread + 1;
 
  if (nread == 1 ) % Preassign Buffer space for trace headers/data
   nsamps = T1(58);
   bibuf = zeros(buftr,120);
   blbuf = zeros(buftr, 60);
   bseis = zeros(buftr,nsamps);
  end
 
  nsamps = T1(58);
%  fseek(fid,-240,0)
  fseek(fid,-240,'cof');
%  T2 = fread(fid,60,'long')';
  T2 = fread(fid,60,'int32')';
  if (feof(fid) == 1)
     fprintf(1,'reread of header failed.\n');
     break;
  end
  if( fmt == 2 ) T3 = fread(fid,nsamps,'long')'; end;
  if( fmt == 3 ) T3 = fread(fid,nsamps,'short')'; end;
  if( fmt > 4 ) T3 = fread(fid,nsamps,'float')'; end;
  if (feof(fid) == 1)
     fprintf(1,'read of data failed.\n');
     break;
  end
  nx = nx + 1;
  bibuf(nx,:) = T1;
  blbuf(nx,:) = T2;
  if( blbuf(nx,7) == 0 )
      no = blbuf(nx,3);
      tr = blbuf(nx,4);
  else
      no = blbuf(nx,6);
      tr = blbuf(nx,7);
  end
  bseis(nx,:) = T3;
  if( no == fno )
      if( tr == ftr )
          doit = 0;
      else
          nx = nx - 1;
      end
  else
      nx = nx - 1;
  end
                    % Allocate additional storage space for data arrays
  if ( nx > 0 )
     if( rem(nx,buftr) == 0)
       seis = [seis;bseis];
       ibuf = [ibuf;bibuf];
       lbuf = [lbuf;blbuf];
     end
  end
end
 
seis = bseis(1:nx,:);
ibuf = bibuf(1:nx,:);
lbuf = blbuf(1:nx,:);
 
fclose(fid);
 
% identify the variables inside the ibuf - the short integers
% or lbuf - the long integers, arrays to pass on
dt = bibuf(:,59) * 0.000001;
nsamps = bibuf(:,58);
x =  blbuf(:,10) * 0.001;
t0 = bibuf(:,55) * 0.001;
sh = blbuf(:,3);
tr = blbuf(:,4);
rp = blbuf(:,6);
trp = blbuf(:,7);
trcid = bibuf(:,15);
%id = [:]'
seis = bseis(:,:)';