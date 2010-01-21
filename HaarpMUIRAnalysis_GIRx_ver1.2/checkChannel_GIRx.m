function [ ChannelType ] = checkChannel_GIRx(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      checkChannel_GIRx.m
%         made by Shin-ichiro Oyama, GI UAF
%
%         ver.1.0: 08-Jul-2006
%         ver.2.0: 31-Jul-2006: revise CenterFreqFromRadarFreq
%
%         # check the GI receiver channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse input arguments.
%%
p = inputParser;

p.addRequired('dataFile', @ischar)
p.addOptional('fRx', 21e6, @isnumeric)


p.parse(varargin{:});

ChannelType = char(ones(1,3));
 
 

%% check the receiver channel type
%%% open the file
fid   = fopen( p.Results.dataFile, 'r' );
if fid < 0
    error(['## Error: Could not open file: ', p.Results.dataFile]);
end

 for Ichannel = 1:3

     fseek(fid, 10*4, 0);

     freq         = fread(fid,1,'int');
     sfreq        = fread(fid,1,'int');
     samples_to_collect = fread(fid,1,'int');
     
          
     %%% calculate the size
     if Ichannel == 1
         record_bytes = 4*(samples_to_collect+13);
     end%if Ichannel == 1
     fseek(fid,(Ichannel)*record_bytes,-1);
     
     
     
     
     %%% check the receiver channel type
     FreqDel   = freq - p.Results.fRx;
     if FreqDel < 0
         ChannelType(Ichannel) = 'D';
     elseif FreqDel == 0
         ChannelType(Ichannel) = 'I';
     else
         ChannelType(Ichannel) = 'U';
     end%if FreqDel < 0
     
 end%for Ichannel
 
%%% close the file
fclose(fid);