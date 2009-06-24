%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      func_FindDataNum4GIR_SpectrumAna4GIR
%         made by Shin-ichiro Oyama, GI UAF
%
%         ver.1.0: 05-Jul-2006
%
%         # pick-up - the data number from the GI receiver,
%                   - the pulse-coding type, and
%                   - data number from the SRI receiver
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ DataNum4GIR, PulseCodingType, DataNum4SRIR ] = ...
               func_FindDataNum4GIR_SpectrumAna4GIR
%------
% set global parameter
%------
 global_SpectrumAna4GIR;
 
 
%------
% file
%------
%%% file name
 SelDateChar   = num2str(SelDate);
 FileNameChar  = [ DataDirectory4GIR, SelDateChar, filesep, ...
                   'GISRIDataNum_', SelDateChar, '.txt' ];
               
                   
%%% open the file
 fid    = fopen( FileNameChar, 'r' );
 
 
%------
% prepare new arrays
%------
 DataNum4GIR       = [];
 PulseCodingType   = [];
 DataNum4SRIR      = [];
 
 
%------
% read and get information
%------
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