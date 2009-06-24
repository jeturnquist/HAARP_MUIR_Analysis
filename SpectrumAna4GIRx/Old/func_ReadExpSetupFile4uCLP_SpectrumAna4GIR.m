%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_ReadExpSetupFile_Decode4CLP_SpectrumAna4GIR
%          made by S. Oyama, GI UAF
%                   arranged by Jason Turnquist, GI UAF
%        ( ver.1.0: Aug-17-2006 )
%            copied from func_ReadExpSetupFile_Decode4CLP_SpectrumAna4GIR.m
%
%          # 3/15/06: read the experiment setup file (****.tuf)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function func_ReadExpSetupFile_Decode4CLP_SpectrumAna4GIR(        ...
     DataNum4GIR, PulseCodingType );
     
         
%------
% set global parameters
%------
 global_SpectrumAna4GIR;
 

 
%======
% sampling rate
%======
%------
% file name
%------
%%
%% directory
%%
 DirectoryChar    = [ DataDirectory4SRIR, char(SelDataNum4SRIR), ...
                      '\Setup\' ];
 
 
%%
%% unix command
%%
 switch OSChar
     case { 'Linux' }
         CommandChar   = [ 'ls -1 ' DirectoryChar '*.fco' ];
     case { 'Windows' }
         CommandChar   = [ 'dir /ON /B ' DirectoryChar '*.fco' ];
 end%switch OSChar
 
 

%%
%% execute the command and return results
%%
 [ tmp, CommandResults ] = unix( CommandChar );
 

%%
%% file name
%%
 FileNameChar  = [ DirectoryChar, CommandResults(1:end-1) ];
 

%------
% get information
%------

 DotPos             = findstr( FileNameChar, '.' );
 DotPos             = DotPos(end-1:end);
 SamplingRateChar   = FileNameChar( DotPos(1)+1:DotPos(2)-1 );
 SamplingRateUnit   = SamplingRateChar(end-2:end);
 
%  DotPos             = findstr( FileNameChar, '.' );
%  SlashPos           = findstr( FileNameChar, '\' );
%  HzPos              = findstr( FileNameChar, 'Hz' );
%  SamplingRateUnit   = FileNameChar( HzPos-1 );
%  
%  SamplingRatePos    = find(DotPos > SlashPos(end));
%  SamplingRateChar   = FileNameChar( DotPos(SamplingRatePos)+1:(HzPos-2) );
%  SamplingRateNumber = str2num(SamplingRateChar);
 
 if SamplingRateUnit(1) == 'K' | SamplingRateUnit(1) == 'k'
     SamplingRateUnit   = 1;
 end%if SamplingRateUnit(1) == 'K' | SamplingRateUnit(1) == 'k'
 if SamplingRateUnit(1) == 'M'
     SamplingRateUnit   = 1000;
 end%if SamplingRateUnit(1) == 'M'
 
%  SamplingRateNumber  = str2num(SamplingRateChar(1:end-3));
%  SamplingRate        = SamplingRateNumber*SamplingRateUnit*2;

SamplingRate = 1000;

 
%======
% from TUF file
%======
%------
% file name
%------
%%
%% unix command
%%
 switch OSChar
     case { 'Linux' }
         CommandChar   = [ 'ls -1 ' DirectoryChar '*.tuf' ];
     case { 'Windows' }
         CommandChar   = [ 'dir /ON /B ' DirectoryChar '*.tuf' ];
 end%switch OSChar
 
 
%%
%% execute the command and return results
%%
 [ tmp, CommandResults ] = unix( CommandChar );
 
 
%%
%% file name
%%
 FileNameChar  = [ DirectoryChar, CommandResults(1:end-1) ];
 fid     = fopen( FileNameChar, 'r' );
 
%------
% read the header
%------
 HeaderChar   = fgetl( fid );
 
%------
% pick up parameters
%------
%  FitPos      = findstr(HeaderChar, '-us Sample Time')-2;
%  SampleTime  = str2num(HeaderChar(FitPos:FitPos+1)); %(micro seconds)
 
 fgetl( fid );
%  fgetl( fid );
%  fgetl( fid );

 

%%
%% IPP
%%
 CommandBit   = 0;
 while CommandBit ~= -1
     TmpChar      = fgetl( fid );
     CommandBit   = str2num(TmpChar(1:2));
     
     if CommandBit == -1
         FitSpace      = isspace(TmpChar);
         FitSpace      = find(FitSpace == 1);
         IPP           = str2num(TmpChar(FitSpace(2)+1:FitSpace(3)-1));
     else
         CommandBit = 0;
     end%if CommandBit == -1
 end%while CommandBit ~= -1
 
 
 
 
 
%%
%% start time of Tx
%%
 CommandBit   = 0;
 while CommandBit ~= -2
     TmpChar      = fgetl( fid );
     CommandBit   = str2num(TmpChar(1:2));
     
     if CommandBit == -2
         FitSpace      = isspace(TmpChar);
         FitSpace      = find(FitSpace == 1);
         StartTime4Tx  = str2num(TmpChar(FitSpace(1)+1:FitSpace(2)-1));
         
         TmpChar       = fgetl( fid );
         FitSpace      = isspace(TmpChar);
         FitSpace      = find(FitSpace == 1);
         StopTime4Tx   = str2num(TmpChar(FitSpace(1)+1:FitSpace(2)-1));
         
         PulseLength   = StopTime4Tx - StartTime4Tx;
     else
         CommandBit = 0;
     end%if CommandBit == -2
 end%while CommandBit ~= -2
 
 
 
%%
%% start time of sampling
%%
 CommandBit   = 0;
 while CommandBit ~= 7
     TmpChar      = fgetl( fid );
     CommandBit   = str2num(TmpChar(1:2));
     
     if CommandBit == 7
         FitSpace      = isspace(TmpChar);
         FitSpace      = find(FitSpace == 1);
         StartTime4Rx  = str2num(TmpChar(FitSpace(1)+1:FitSpace(2)-1));
     else
         CommandBit = 0;
     end%if CommandBit == 7
 end%while CommandBit ~= 7
 
 
%%% close the file
 fclose(fid);
 
 
 
%======
% beam number
%======
%------
% temporally prepare the beam direction file
%   thx: from 0 to 25 deg every 1 deg
%   thy: from 0 to 25 deg every 1 deg
%------
%%% prepare angle-array
%  thx = []; thy = [];
%  for ithx = 0:25
%      for ithy = 0:25
%          thx = [thx, ithx];
%          thy = [thy, ithy];
%      end%for ithy
%  end%for ithx
%  
%  
% %%% calculation
%  nbytes_per_direction_per_eeprom = 3;
%  icode = nbytes_per_direction_per_eeprom*(100*(thx+35) + (thy+35));
%     
%  
% %%% temporally prepare the file
%  tmpfid = fopen('tmp.bco','wt');
%  for i=1:length(icode)
%     fprintf(tmpfid,'0x%4X\n',icode(i)+32768);
%  end%for i
%  fclose(tmpfid);
% 
% 
% %%% read the file prepared above
%  tmpfid           = fopen('tmp.bco', 'r');
%  BeamDirecCodeArr = cell(1,26*26);
%  TmpChar          = fgetl(tmpfid);
%  Count4Beam       = 0;
%  while TmpChar ~= -1
%      Count4Beam                   = Count4Beam + 1;
%      BeamDirecCodeArr{Count4Beam} = TmpChar;
%      TmpChar                      = fgetl(tmpfid);
%  end%while TmpChar ~= -1
% 
%  
% %%% close
%  fclose(tmpfid);
%  
% 
% %------
% % file name
% %------
% %%% unix command
%  switch OSChar
%      case { 'Linux' }
%          CommandChar   = [ 'ls -1 ' DirectoryChar '*.bco' ];
%      case { 'Windows' }
%          CommandChar   = [ 'dir /ON /B ' DirectoryChar '*.bco' ];
%  end%switch OSChar
%  
%  
% %%% execute the command and return results
%  [ tmp, CommandResults ] = unix( CommandChar );
%  
%  
% %%% file name
%  FileNameChar  = [ DirectoryChar, CommandResults(1:end-1) ];
%  
%  
% %%% open the file
%  fid4bco   = fopen( FileNameChar, 'r' );
%  
%  
% %%% set parameters
%  Count4Beam   = 0;
%  
% 
% %%% get information
%  TmpChar    = fgetl(fid4bco);
%  BeamAngleX = [];
%  BeamAngleY = [];
%  while TmpChar ~= -1
%      %%%%%% check beam number
%      Count4Beam   = Count4Beam + 1;
%      
%      
%      %%%%%% search the beam direction
%      TmpAns     = 0;
%      TmpCount   = 1;
%      while TmpAns == 0
%          if TmpChar == BeamDirecCodeArr{TmpCount}
%              BeamAngleX  = [ BeamAngleX, thx(TmpCount) ];
%              BeamAngleY  = [ BeamAngleY, thy(TmpCount) ];
%              TmpAns      = 1;
%          end%if TmpChar == BeamDirecCodeArr(TmpCount)
%          TmpCount = TmpCount + 1;
%      end%while TmpAns == 0
%      
%      
%      %%%%%% read next data
%      TmpChar      = fgetl(fid4bco);
%  end%while TmpChar ~= -1
%  
% 
% %%% beam number
%  BeamNum    = Count4Beam;
%  
% %%% close the file
%  fclose(fid4bco);
%  
%  
% %%% delete tmp.bco
%  CommandChar = [ 'del tmp.bco' ];
%  unix(CommandChar);
 
 
 
%======
% Down Converter Knob
%======
%%% file name
 switch OSChar
     case { 'Linux' }
         CommandChar   = [ 'ls -1 ' DirectoryChar '*.exp' ];
     case { 'Windows' }
         CommandChar   = [ 'dir /ON /B ' DirectoryChar '*.exp' ];
 end%switch OSChar
 
 
%%% execute the command and return results
 [ tmp, CommandResults ] = unix( CommandChar );
 
 
%%% file name
 FileNameChar  = [ DirectoryChar, CommandResults(1:end-1) ];
 
 
%%% open the file
 fid    = fopen( FileNameChar, 'r' );
 
 
%%% get information & search the line including the value
%  TmpChar  = fgetl(fid);
%  FindLine = findstr( TmpChar, 'RxBandSwitch' );
%  while length(FindLine) == 0
%      TmpChar  = fgetl(fid);
%      FindLine = findstr( TmpChar, 'RxBandSwitch' );
%  end%while length(FindLine) == 0
%  
%  FitEqual     = findstr(TmpChar, '=');
%  DCKNum       = str2num(TmpChar(FitEqual+1:end))/1e6;
DCKNum = 450;