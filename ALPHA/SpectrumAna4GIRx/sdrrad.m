%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%        sdrrad.m
%          originally made by Todd. R. Parris
%                     arranged by Shin-ichiro Oyama
%
%          ver.1.0: Jul-06-06
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ hdr, rhdr, dp, du, cp, np,                       ...
           years1, months1, days1,                          ...
           hours1, minutes1, seconds1, nseconds1, freq1 ] = ...
           sdrrad(filename,channel,temp2)
       
           
%------
% global parameter
%------
 global_SpectrumAna4GIR;

%------
% open the file
%------
 fid  = fopen(filename);
 
 
%------
% calculate the data size
%------
%%% read the header
 hdr          = fread(fid,4,'char');
 year         = fread(fid,1,'int');
 month        = fread(fid,1,'int');
 day          = fread(fid,1,'int');
 hour         = fread(fid,1,'int');
 minutes      = fread(fid,1,'int');
 second       = fread(fid,1,'int');
 nsecond      = fread(fid,1,'int');
 record_size  = fread(fid,1,'int');
 record       = fread(fid,1,'int');
 freq         = fread(fid,1,'int');
 sfreq        = fread(fid,1,'int');
 samples_to_collect = fread(fid,1,'int');
 
 
%%% close the file
 fclose(fid);
 
 
%%% calculate the size
 record_bytes = 4*(samples_to_collect+13);
 
 
%%% set the initial value
 hdr  = 0;
 rhdr = 0;
 dp   = 0;
 np   = 0;
 nu   = 0;
 cp   = 0;


%%% prepare new arrays to be returned
 du        = zeros(record_size,samples_to_collect);
 I         = zeros(record_size,samples_to_collect);
 Q         = zeros(record_size,samples_to_collect);
 years1    = zeros(record_size,1);
 months1   = zeros(record_size,1);
 days1     = zeros(record_size,1);
 hours1    = zeros(record_size,1);
 minutes1  = zeros(record_size,1);
 seconds1  = zeros(record_size,1);
 nseconds1 = zeros(record_size,1);
 
 
 
%------
% read data
%------
%%% open the file again
 fid = fopen(filename);
 
%%% set parameters for reading parameters
 im = sqrt(-1);
 if channel == 1
 elseif channel == 2
     fseek(fid,record_bytes,0);
 elseif channel == 3
     fseek(fid,2*record_bytes,0);
 end%if channel == 1
 
 
%%% read the data
 for i=1:record_size
     
     if i == 99
         i;
     end
     hdr1                = fread(fid,4,'char');
     years1(i)           = fread(fid,1,'int');
     months1(i)          = fread(fid,1,'int');
     days1(i)            = fread(fid,1,'int');
     hours1(i)           = fread(fid,1,'int');
     minutes1(i)         = fread(fid,1,'int');
     seconds1(i)         = fread(fid,1,'int');
     nseconds1(i)        = fread(fid,1,'int');
     record_size1        = fread(fid,1,'int');
     record1             = fread(fid,1,'int');
     freq1               = fread(fid,1,'int');
     sfreq1              = fread(fid,1,'int');
     samples_to_collect1 = fread(fid,1,'int');
     
     %% the following is a small header 8 bytes long at the beggining of
     %% each IPP
     timestamp           = fread(fid,1,'int'); %% added by Todd Paris
     chid                = fread(fid,1,'int16'); %% added by Todd Paris
     framecount          = fread(fid,1,'int16'); %% added by Todd Paris
     
     for j=1:(samples_to_collect-2)
         du(i,j)=fread(fid,1,'int16')+im*fread(fid,1,'int16');
     end
     fseek(fid,2*record_bytes,0);

    
    %%% calculate the range offset value
    %%% global: RangeOffsetValue: range offset value (km)
    if i == 1 & temp2 == 2
        
        switch char(SelPulseCodingType)
            case {'CLP'}%for coded long pulse
                func_CalRangeOffsetValue_Decode4CLP_SpectrumAna4GIR(du(i,:));
            case {'uCLP'}%for coded long pulse
                func_CalRangeOffsetValue_4uCLP_SpectrumAna4GIR(du(i,:));
        end%switch char(SelPulseCodingType)
        
        %%% show the range offset value on the display
        RangeOffsetValueChar  = num2str( RangeOffsetValue );
        TmpChar               = [ '  # Range offset value (km): ' ];
        TmpChar               = [ TmpChar RangeOffsetValueChar ];
        disp( TmpChar );
        
        
        %%% prepare dami data
        hdr        = -9999;
        rhdr       = -9999;
        dp         = -9999;
        du         = -9999;
        cp         = -9999;
        np         = -9999;
        years1     = -9999;
        months1    = -9999;
        days1      = -9999;
        hours1     = -9999;
        minutes1   = -9999;
        seconds1   = -9999;
        nseconds1  = -9999;
        freq1      = -9999;
        
        
        %%% return
        return
    end%if i == 1 & temp2 == 2
 end%for i
% seconds1=60*minutes1+seconds1+1e-9*nseconds1;


%------
% close the file
%------
 fclose(fid);