%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%        sdrrad2_test.m
%          originally made by Todd. R. Parris
%                     arranged by Shin-ichiro Oyama
%                       re-arranged by Jason Turnquist
%                   
%          ver.1.0: Aug-27-08
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ hdr, du,                       ...
           years, months, days,                          ...
           hours, minutes, seconds, nseconds, freq ] = ...
           sdrrad2(filename,ILCh,pulseCodingType)
       
           
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

%% read the header
fseek(fid,4*8,-1);
record_size = fread(fid,1,'int');

fseek(fid,4*3,0);
samples_to_collect = fread(fid,1,'int');

%%% calculate the size
 record_bytes = 4*(samples_to_collect+13);
 
%%% length of file in bytes
 fseek(fid,0,1); %% EOF
 file_length_bytes = ftell(fid); %% file length in bytes
 
 num_records = file_length_bytes / record_bytes;

 %%% get first channel ID 
fseek(fid, 58, -1);
framecount = fread(fid,1,'int16');
chid = (framecount - 1000)/100; %%channel ID

%%% use ion line channel to determine range offset
if ILCh
    kk = 0;
    while 1
        fseek(fid, abs((ILCh-chid+kk))*record_bytes, -1);
        fseek(fid, 10*4, 0);
        tmpfreq = fread(fid, 1, 'int');
        if ~diff(tmpfreq, fRx)
            chid = ILCh;
            return
        end
        kk = kk + 1;
    end
else
    fseek(fid, 0, -1);
end

%%% prepare new arrays to be returned
 du       = cell(3,1);
 years    = cell(3,1);
 months   = cell(3,1);
 days     = cell(3,1);
 hours    = cell(3,1);
 minutes  = cell(3,1);
 seconds  = cell(3,1);
 nseconds = cell(3,1);
 freq     = cell(3,1);
 timestamp = cell(3,1); 	
 
 for ii = 1:1:3
     du{ii}       = nan(record_size,samples_to_collect);
     years{ii}    = zeros(record_size,1);
     months{ii}   = zeros(record_size,1);
     days{ii}     = zeros(record_size,1);
     hours{ii}    = zeros(record_size,1);
     minutes{ii}  = zeros(record_size,1);
     seconds{ii}  = zeros(record_size,1);
     nseconds{ii} = zeros(record_size,1);
 end
 

%------
% read data
%------
kk = 0;
 for ii = 1:num_records
     
    %%% Check Channel ID for each record
    if ~ILCh
        fseek(fid, 58,0);
        framecount = fread(fid, 1, 'int16');
        chid = (framecount - 1000)/100;
        fseek(fid, -60, 0);
    end
     
     hdr{chid}(ii-kk,:)        	= fread(fid,4,'char');
     years{chid}(ii-kk,:)     	= fread(fid,1,'int');
     months{chid}(ii-kk,:)    	= fread(fid,1,'int');
     days{chid}(ii-kk,:)       	= fread(fid,1,'int');
     hours{chid}(ii-kk,:)      	= fread(fid,1,'int');
     minutes{chid}(ii-kk,:)    	= fread(fid,1,'int');
     seconds{chid}(ii-kk,:)    	= fread(fid,1,'int');
     nseconds{chid}(ii-kk,:)  	= fread(fid,1,'int');
     record_size               	= fread(fid,1,'int');
     record                   	= fread(fid,1,'int');
     freq{chid}               	= fread(fid,1,'int');
     sfreq                    	= fread(fid,1,'int');
     samples_to_collect         = fread(fid,1,'int');
     
     %% the following is a small header 8 bytes long at the beggining of
     %% each IPP
     timestamp{chid}(ii-kk,:) 	= fread(fid,1,'int'); %% added by Todd Paris 4 bytes
     ch                       	= fread(fid,1,'int16'); %% added by Todd Paris 2 bytes
     framecount             	= fread(fid,1,'int16'); %% added by Todd Paris 2 bytes
%      chid = (framecount - 1000)/100;
     
     %% store data in cell array 

     for jj=1:(samples_to_collect-2)
         du{chid}(ii-kk,jj) = complex(fread(fid,1,'int16'),fread(fid,1,'int16'));
     end
    
    %% Increment through the 3 channels
    if chid == 3
%         chid = 0; %% reset channel ID to 1
        kk = kk - 1;
    end
%     chid = chid + 1;
    kk = kk + 1;
    
    %%% calculate the range offset value
    %%% global: RangeOffsetValue: range offset value (km)
    if ILCh
        
        switch char(pulseCodingType)
            case {'CLP'}%for coded long pulse
                func_CalRangeOffsetValue_Decode4CLP_SpectrumAna4GIR(du{ILCh}(1,:));
            case {'uCLP'}%for coded long pulse
                func_CalRangeOffsetValue_4uCLP_SpectrumAna4GIR(du{ILCh}(1,:));
        end%switch char(SelPulseCodingType)
%         func_CalRangeOffsetValue_4uCLP_SpectrumAna4GIR(du{ILCh}(1,:));
        %%% show the range offset value on the display
        RangeOffsetValueChar  = num2str( RangeOffsetValue );
        TmpChar               = [ '  # Range offset value (km): ' ];
        TmpChar               = [ TmpChar RangeOffsetValueChar ];
        disp( TmpChar );
        
        
        %%% prepare dami data
        hdr         = -9999;
        du          = -9999;
        years       = -9999;
        months      = -9999;
        days        = -9999;
        hours       = -9999;
        minutes     = -9999;
        seconds     = -9999;
        nseconds	= -9999;
        freq        = -9999;
        
        
        %%% return
        return
    end%if i == 1 & temp2 == 2
 end%for i
% seconds1=60*minutes1+seconds1+1e-9*nseconds1;


%------
% close the file
%------
 fclose(fid);
 
 %%% 
 results = [ hdr, du,                       ...
             years, months, days,                          ...
             hours, minutes, seconds, nseconds, freq ];