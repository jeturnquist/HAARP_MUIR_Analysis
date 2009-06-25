%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_ReadExpSetupFile_Decode4CLP_SpectrumAna4GIR2
%          made by S. Oyama, GI UAF
%           re-arranged by Jason Turnquist, GI UAF
%
%        ( ver.1.0: Aug-26-2008: copy from func_ReadExpSetupFile_Decode4CLP_SpectrumAna4GIR )
%          ver.1.1: 01-Nov-2008 : No longer OS depenent 
%          ver.2.0: 24-jun-2009: Now uses SRIRx HDF5 file format 
%
%          read timing unit files that are not tab deliminated
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function func_ReadExpSetupFile_Decode4CLP_SpectrumAna4GIR2
     
         
%------
% set global parameters
%------
 global_SpectrumAna4GIR;
 
% %======
% % sampling rate
% %======
% %------
% % file name
% %------
% %%
% %% directory
% %%
%  DirectoryChar    = [ DataDirectory4SRIR, filesep, char(SelDataNum4SRIR), filesep ];
%  
%  
% %%
% %% execute the command and return results
% %%
%  [ CommandResults ] = dir( [DirectoryChar, '*.h5'] );
%
%   %%% check first result to see if its a Linux hidden file
%  if strcmp(CommandResults(1).name(1), '.')
%      ii = 2;
%  else
%      ii = 1;
%  end
%  
% 
% %%
% %% file name
% %%
%  FileNameChar  = [ DirectoryChar, CommandResults(ii).name ];
%  
% 
% %------
% % get information
% %------
% 
% %%% get the sample time
% SampleTime = cast( hdf5read( FileNameChar,...
%                                       '/Rx/SampleTime'), 'double');               
% 
% %%% get Pulse Length
% % PulseLength           : pulse length (micro-second)
% PulseLength = floor(cast( hdf5read(FileNameChar,...
%                               '/Raw11/Data/Pulsewidth'), 'double')*1e6);
% 
% %%% get Center Frequency                          
% CenterFreqFromRadarFreq = hdf5read( FileNameChar,...
%                             '/Rx/TuningFrequency')';                          
% 
% %======
% % from TUF file
% %======
% tufile = hdf5read(FileNameChar,'/Setup/Tufile');
% tufstr = tufile.data;
% 
% %%% Generate character array from string
% newlines = regexp(tufstr, '\n');
% idx = 1;
% tufCharArr = [];
% for ii = 1:length(newlines)
%     tmpLine = tufstr(idx+1:newlines(ii)-1);
%     idx = newlines(ii);
%     tufCharArr = strvcat(tufCharArr, tmpLine);
% end
% 
% 
% %% Pick up transmiter start time from timing unit file
% BitChar = strmatch('-2', tufCharArr);   
% tmpLineArr = tufCharArr(BitChar,:);
% TxStartChar = [];
% for ii = 1:length(BitChar)
%     tmp = findstr(tmpLineArr(ii,:), 'Tx profile 1');
%     if ~isempty(tmp)
%         TxStartChar = [TxStartChar; tmpLineArr(ii,6:8)];
%     end   
% end
% 
% StartTime4Tx = str2num(TxStartChar);
% 
% 
% %% Inter  Pulse Period (IPP)
% BitChar = strmatch('-1', tufCharArr);
% IPPChar = strvcat(tufCharArr(BitChar,11:16));
% IPP = str2num(IPPChar);
% 
% 
% %% start time of sampling
% BitChar = strmatch(' 7', tufCharArr);
% RxStartChar = strvcat(tufCharArr(BitChar,6:8));
% StartTime4Rx  = str2num(RxStartChar);
%  
% %% Read random phase coding 
% PhaseCoding ] = func_GetPhaseCodingGIRx( DirectoryChar )
% 
% %======
% % beam number
% %======
% 
% %------
% % file name
% %------
%  BeamCodes = hdf5read( FileNameChar,...
%                             '/Raw11/Data/Beamcodes');
%  BeamDir = func_BeamCode2AzEl(BeamCodes);
%  
%  %%% beam number
%  BeamNum    = length(BeamDir);
%  
% 
% %======
% % Down Converter Knob
% %======
%  expfile = hdf5read( FileNameChar,...
%                             '/Setup/Experimentfile'); 
%  
%                         
% expstr = expfile.data;
% 
% %%% Generate character array from string
% newlines = regexp(expstr, '\n');
% idx = 1;
% expCharArr = [];
% for ii = 1:length(newlines)
%     tmpLine = expstr(idx+1:newlines(ii)-1);
%     idx = newlines(ii);
%     expCharArr = strvcat(expCharArr, tmpLine);
% end
% 
% %%% get information & search the line including the value
%  BitChar = strmatch('RxBand', expCharArr);
%  DCKNum = str2num(expCharArr(BitChar, 8:end));
 
%% Old routine

%======
% sampling rate
%======
%------
% file name
%------
%%
%% directory
%%
 DirectoryChar    = [ DataDirectory4SRIR, filesep, char(SelDataNum4SRIR), ...
                      filesep, 'Setup', filesep ];
 
%%
%% execute the command and return results
%%
 [ CommandResults ] = dir( [DirectoryChar, '*.fco'] );
 %%% check first result to see if its a Linux hidden file
 if strcmp(CommandResults(1).name(1), '.')
     ii = 2;
 else
     ii = 1;
 end

%%
%% file name
%%
 FileNameChar  = [ DirectoryChar, CommandResults(ii).name ];
 

%------
% get information
%------

 DotPos             = findstr( FileNameChar, '.' );
 DotPos             = DotPos(end-2:end);
%  SamplingRateChar   = FileNameChar( DotPos(1)+1:DotPos(2)-1 ); 
%  SamplingRateChar   = FileNameChar( DotPos(1)+1:DotPos(end)-1 );
 SamplingRateChar   = FileNameChar( DotPos(end-2)+1:DotPos(end)-1 ); 
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
 
 SamplingRateNumber  = str2num(SamplingRateChar(1:end-3));
 SamplingRate        = SamplingRateNumber*SamplingRateUnit*2;


%======
% from TUF file
%======
 
%%
%% execute the command and return results
%%
 [ CommandResults ] = dir( [DirectoryChar,'*.tuf'] );
  %%% check first result to see if its a Linux hidden file
 if strcmp(CommandResults(1).name(1), '.')
     ii = 2;
 else
     ii = 1;
 end
 
%%
%% file name
%%
 FileNameChar  = [ DirectoryChar, CommandResults(ii).name ];
 
 
 
%------
% read the header
%------
 fid     = fopen( FileNameChar, 'r' );
 
 TmpLine = [];
 while 1
    TmpChar = fgets(fid);
    TmpLine = strvcat(TmpLine, TmpChar);
    if ~ischar(TmpChar), break, end
 end
 
%------
% pick up parameters
%------
% BaudLength           : baud length (micro-second)
% PulseLength          : pulse length (micro-second)
 FitPos      = findstr(TmpLine(1,:), '-us baud')-2;
 BaudLength  = str2num(TmpLine(1,FitPos:FitPos+1));
 
 e_FitPos    = findstr(TmpLine(1,:), '-us pulse')-1;
 s_FitPos    = findstr(TmpLine(1,:), 'length and')+11;
 PulseLength = str2num(TmpLine(1,s_FitPos:e_FitPos));
 

%%
%% read random-code information
%%
idx = strmatch('* phase code', TmpLine);
FitPos = findstr(':', TmpLine(idx,:));
PhaseCoding  = TmpLine(idx , FitPos+2:end);
fit = find(isspace(PhaseCoding));
PhaseCoding = PhaseCoding(1:fit-1);
%%
%% IPP
%%

idx = strmatch('-1', TmpLine);
FitPos = find(~isspace(TmpLine(idx,:)));
FitSpace = find(isspace(TmpLine(idx,FitPos(4):FitPos(end))));

IPP = str2num(TmpLine(idx,FitPos(4):FitPos(4)+FitSpace(1)));

%%
%% start time of Tx
%%

idx = strmatch('-2', TmpLine);
bit  = [];
ii = 1;
while isempty(bit)
  bit = findstr('Tx', TmpLine(idx(ii),:));
  if bit > 0
      idx = idx(ii);
  end
  ii = ii + 1;
end
FitPos = find(~isspace(TmpLine(idx,:)));
FitSpace = find(isspace(TmpLine(idx,FitPos(3):FitPos(end))));

StartTime4Tx = str2num(TmpLine(idx,FitPos(3):FitPos(3)+FitSpace(1)));


%%
%% start time of sampling
%%

idx = strmatch('7', TmpLine);
if isempty(idx)
    idx = strmatch(' 7', TmpLine);
end
FitPos = find(~isspace(TmpLine(idx,:)));
FitSpace = find(isspace(TmpLine(idx,FitPos(2):FitPos(end))));

StartTime4Rx = str2num(TmpLine(idx,FitPos(2):FitPos(2)+FitSpace(1)));
 
%%% close the file
 fclose(fid);
 
 
 
% ======
% beam number
% ======

% ------
% file name
% ------
 
%%% execute the command and return results
 [ CommandResults ] = dir( [ DirectoryChar, '*.bco' ] );
  %%% check first result to see if its a Linux hidden file
 if strcmp(CommandResults(1).name(1), '.')
     ii = 2;
 else
     ii = 1;
 end
 
%%% file name
 FileNameChar  = [ DirectoryChar, CommandResults(ii).name ];
 
 %%% open the file
 fid4bco    = fopen( FileNameChar, 'r' );

 BeamCode	= fgetl(fid4bco);
 BeamCodeDec = hex2dec(BeamCode(3:end));
 Count4Beam	= 0;
 BeamAngleX	= [];
 BeamAngleY	= [];
 
 while BeamCode ~= -1
      Count4Beam    = Count4Beam + 1;
      BeamDir       = func_BeamCode2AzEl(BeamCodeDec);
      if BeamDir{:} == 0
          BeamAngleX	= 0;
          BeamAngleY	= 0;
          break
      end
      tmpX    = BeamDir{Count4Beam}(1);
      tmpY    = BeamDir{Count4Beam}(2);
      
      BeamAngleX      = [ BeamAngleX, tmpX ];
      BeamAngleY      = [ BeamAngleY, tmpY ];
      
      BeamCode	= fgetl(fid4bco);
 end
 
 %%% beam number
 BeamNum    = Count4Beam;
 
%%% close the file
 fclose(fid4bco);
 

%======
% Down Converter Knob
%======

%%% execute the command and return results
 [ CommandResults ] = dir( [ DirectoryChar, '*.exp' ] );
  %%% check first result to see if its a Linux hidden file
 if strcmp(CommandResults(1).name(1), '.')
     ii = 2;
 else
     ii = 1;
 end
 
%%% file name
 FileNameChar  = [ DirectoryChar, CommandResults(ii).name ];
 
 
%%% open the file
 fid    = fopen( FileNameChar, 'r' );
 
 
%%% get information & search the line including the value
 TmpChar  = fgetl(fid);
 FindLine = findstr( TmpChar, 'RxBandSwitch' );
 while length(FindLine) == 0
     TmpChar  = fgetl(fid);
     FindLine = findstr( TmpChar, 'RxBandSwitch' );
 end%while length(FindLine) == 0
 
 FitEqual     = findstr(TmpChar, '=');
 DCKNum       = str2num(TmpChar(FitEqual+1:end))/1e6;