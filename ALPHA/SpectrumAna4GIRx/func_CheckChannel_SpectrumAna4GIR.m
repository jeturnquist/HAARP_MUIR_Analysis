%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      func_CheckChannel_SpectrumAna4GIR
%         made by Shin-ichiro Oyama, GI UAF
%
%         ver.1.0: 08-Jul-2006
%         ver.2.0: 31-Jul-2006: revise CenterFreqFromRadarFreq
%
%         # check the GI receiver channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function func_CheckChannel_SpectrumAna4GIR
%------
% set global parameter
%------
 global_SpectrumAna4GIR;
 
 
%------
% set parameters
%------
 switch DCKNum
     case 440
         CenterFreqFromRadarFreq    = 26e6;
     case 445
         CenterFreqFromRadarFreq    = 21e6;
     case 450
         CenterFreqFromRadarFreq    = 16e6;
 end%switch DCKNum
 ChannelNum                 = 3;
 ChannelType                = char(ones(1,ChannelNum));
 
 
%------
% check the receiver channel type
%------
%%%
%%% iteration over ChannelNum
%%%
 for Ichannel = 1:ChannelNum
     %%% open the file
     fid   = fopen( DataFileName4GIR, 'r' );
     
     
     %%% set parameters for reading parameters
     if Ichannel ~= 1
         fseek(fid,(Ichannel-1)*record_bytes,0);
     end%if Ichannel ~= 1
     
     
     %%% read data
     hdr          = fread(fid,4,'char');
     year         = fread(fid,1,'int');
     month        = fread(fid,1,'int');
     day          = fread(fid,1,'int');
     hour         = fread(fid,1,'int');
     minute       = fread(fid,1,'int');
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
     if Ichannel == 1
         record_bytes = 4*(samples_to_collect+13);
     end%if Ichannel == 1
     
     
     %%% check the receiver channel type
     FreqDel   = freq - CenterFreqFromRadarFreq;
     if FreqDel < 0
         ChannelType(Ichannel) = 'D';
     elseif FreqDel == 0
         ChannelType(Ichannel) = 'I';
     else
         ChannelType(Ichannel) = 'U';
     end%if FreqDel < 0
     if freq == 21e6, ChannelType(Ichannel)='I'; end %% ### testing purpose ###
 end%for Ichannel