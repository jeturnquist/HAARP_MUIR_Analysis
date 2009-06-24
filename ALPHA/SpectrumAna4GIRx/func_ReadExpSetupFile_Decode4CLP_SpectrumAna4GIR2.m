%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_ReadExpSetupFile_Decode4CLP_SpectrumAna4GIR2
%          made by S. Oyama, GI UAF
%           re-arranged by Jason Turnquist, GI UAF
%
%        ( ver.1.0: Aug-26-2008: copy from func_ReadExpSetupFile_Decode4CLP_SpectrumAna4GIR )
%          ver.1.1: 01-Nov-2008 : No longer OS depenent 
%
%          read timing unit files that are not tab deliminated
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function func_ReadExpSetupFile_Decode4CLP_SpectrumAna4GIR2
     
         
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
                      filesep, 'Setup', filesep ];
 
%%
%% execute the command and return results
%%
 [ CommandResults ] = dir( [DirectoryChar, '*.fco'] );
 

%%
%% file name
%%
 FileNameChar  = [ DirectoryChar, CommandResults.name ];
 

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
 
 
%%
%% file name
%%
 FileNameChar  = [ DirectoryChar, CommandResults.name ];
 
 
 
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
 
 
 
%======
% beam number
%======

%------
% file name
%------
 
%%% execute the command and return results
 [ CommandResults ] = dir( [ DirectoryChar, '*.bco' ] );
 
 
%%% file name
 FileNameChar  = [ DirectoryChar, CommandResults.name ];
 
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
      if BeamDir == 0
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
 
 
%%% file name
 FileNameChar  = [ DirectoryChar, CommandResults.name ];
 
 
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