function [ DataNum4GIR, PulseCodingType, DataNum4SRIR ] = ...
               getExpNum(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      getDataNum.m
%         made by J. Turnquist, GI UAF
%
%         ver.1.0: 1-Jul-2009
%       
%        read GISRIDataNum_YYYYMMDDtxt
%
%         # pick-up - the data number for the GI receiver,
%                   - the pulse-coding type, and
%                   - data number from the SRI receiver
%
%
%       GISRIDataNum_YYYYMMDD.txt needs to be located in the same directory
%       level as the GIRx data.
%
%       This file contains a mapping of the experiment numbers from the
%       SRIRx to the GIRx. The layout of the file is VERY IMPORTANT. 
%       All fields need to be seperated by EXACLY as single space or tab.
%
% Example file:
%
%   GI receiver			SRI receiver
%   date		file#		file#		code
%   20080224	210		20080224.006	CLP
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Parse input arguments.
%%
p = inputParser;

p.addOptional('dir', pwd, @ischar)
p.addOptional('date', '9999', @ischar)


p.parse(varargin{:}); 
 
%% Open file
%%
%%% file name

 FileNameChar  = [ dir, SelDateChar, filesep, ...
                    'GISRIDataNum_', date, '.txt' ];
               
                   
%%% open the file
 fid    = fopen( FileNameChar, 'r' );
 
if ~fid
    error(['## Error: Could not open file: ', FileNameChar])
    return
end
 
%------
% prepare new arrays
%------
 DataNum4GIR       = [];
 PulseCodingType   = [];
 DataNum4SRIR      = [];
 

%% read and get information
%%
%%% set parameters
 Count4Read    = 1;
 

%%% read the firt line
 TmpChar       = fgetl(fid);
 
 
%%% while to the end of the file
 while TmpChar ~= -1
     if Count4Read <= 2
         TmpChar     = fgetl(fid);
         Count4Read  = Count4Read + 1;
         continue
     else
         %%% search space position
         FitSpace    = isspace(TmpChar);
         FitSpace    = find( FitSpace == 1 );
         
         
         %%% pick-up the file-number from the GI receiver
         TmpValue    = TmpChar(FitSpace(1)+1:FitSpace(2)-1);
         TmpValue    = str2num(TmpValue);
         DataNum4GIR = [ DataNum4GIR, TmpValue ];
         
         
         %%% pick-up the data number from the SRI receiver
         TmpValue      = TmpChar(FitSpace(3)+1:FitSpace(4)-1);
         DataNum4SRIR  = [ DataNum4SRIR, {TmpValue} ];
         
         
         %%% pick-up the pulse coding type
         TmpValue        = TmpChar(FitSpace(4)+1:end);
         PulseCodingType = [ PulseCodingType, {TmpValue} ];
     end%if Count4Read <= 2
     
     
     %%% read the next line
     TmpChar       = fgetl(fid);
     
     
     %%% increment Count4Read
     Count4Read    = Count4Read + 1;
 end%while TmpChar ~= -1
 
%------
% close the file
%------
 fclose(fid);