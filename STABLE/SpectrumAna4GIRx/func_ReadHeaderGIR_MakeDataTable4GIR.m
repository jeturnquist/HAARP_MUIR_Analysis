%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      func_ReadHeaderGIR_MakeDataTable4GIR.m
%          made by Shin-ichiro Oyama, GI UAF
%
%          ver.1.0: Jun-27-06
%
%          # read header of the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ Year, Month, Day, Hour, Minute, Second, Nsecond] =  ...
         func_ReadHeaderGIR_MakeDataTable4GIR( SelFileName )
%------
% set global parameters
%------
 global_MakeDataTable4GIR;
 
 
%------
% open file
%------
 fid    = fopen(SelFileName);
 
 
%------
% read the header
%------
 hdr          =   fread(fid,4,'char');
 Year         =   fread(fid,1,'int');
 Month        =   fread(fid,1,'int');
 Day          =   fread(fid,1,'int');
 Hour         =   fread(fid,1,'int');
 Minute       =   fread(fid,1,'int');
 Second       =   fread(fid,1,'int');
 Nsecond      =   fread(fid,1,'int');
 

%------
% check the data size
%------
 if length(Year) == 0
     Year         =   9999;
     Month        =   9999;
     Day          =   9999;
     Hour         =   9999;
     Minute       =   9999;
     Second       =   9999;
     Nsecond      =   9999;
 end%if length(Year) == 0



%------
% close the file
%------
 fclose(fid);