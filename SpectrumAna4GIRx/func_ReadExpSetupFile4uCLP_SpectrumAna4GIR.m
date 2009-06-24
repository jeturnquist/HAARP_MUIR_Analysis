%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_ReadExpSetupFile4uCLP_SpectrumAna4GIR2
%          made by S. Oyama, GI UAF
%           re-arranged by Jason Turnquist, GI UAF
%
%        ( ver.1.0: 26-Aug-2008: copy from func_ReadExpSetupFile_Decode4CLP_SpectrumAna4GIR )
%          ver.1.1: 01-Nov-2008 : No longer OS depenent 
%          ver.1.2: 02-Nov-2008 : fixed no okazelgrid.mat 
%
%
%          read timing unit files that are not tab deliminated
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function func_ReadExpSetupFile4uCLP_SpectrumAna4GIR2
     
         
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
 DirectoryChar    = [ DataDirectory4SRIR, char(SelDataNum4SRIR), filesep ];
 
 
%%
%% execute the command and return results
%%
 [ CommandResults ] = dir( [DirectoryChar, '*.h5'] );
 
 

%%
%% file name
%%
 FileNameChar  = [ DirectoryChar, CommandResults(1).name ];
 

%------
% get information
%------

%%% get the sample time
SampleTime = cast( hdf5read( FileNameChar,...
                                      '/Rx/SampleTime'), 'double');               

%%% get Pulse Length
% PulseLength           : pulse length (micro-second)
PulseLength = floor(cast( hdf5read(FileNameChar,...
                              '/Raw11/Data/Pulsewidth'), 'double')*1e6);

%%% get Center Frequency                          
CenterFreqFromRadarFreq = hdf5read( FileNameChar,...
                            '/Rx/TuningFrequency')';                          

%======
% from TUF file
%======
tufile = hdf5read(FileNameChar,'/Setup/Tufile');
tufstr = tufile.data;

%%% Generate character array from string
newlines = regexp(tufstr, '\n');
idx = 1;
tufCharArr = [];
for ii = 1:length(newlines)
    tmpLine = tufstr(idx+1:newlines(ii)-1);
    idx = newlines(ii);
    tufCharArr = strvcat(tufCharArr, tmpLine);
end


%% Pick up transmiter start time from timing unit file
BitChar = strmatch('-2', tufCharArr);   
tmpLineArr = tufCharArr(BitChar,:);
TxStartChar = [];
for ii = 1:length(BitChar)
    tmp = findstr(tmpLineArr(ii,:), 'Tx profile 1');
    if ~isempty(tmp)
        TxStartChar = [TxStartChar; tmpLineArr(ii,6:8)];
    end   
end

StartTime4Tx = str2num(TxStartChar);


%% Inter  Pulse Period (IPP)
BitChar = strmatch('-1', tufCharArr);
IPPChar = strvcat(tufCharArr(BitChar,11:16));
IPP = str2num(IPPChar);


%% start time of sampling
BitChar = strmatch(' 7', tufCharArr);
RxStartChar = strvcat(tufCharArr(BitChar,6:8));
StartTime4Rx  = str2num(RxStartChar);
 
 
 
%======
% beam number
%======

%------
% file name
%------
 BeamCodes = hdf5read( FileNameChar,...
                            '/Raw11/Data/Beamcodes');
 BeamDir = func_BeamCode2AzEl(BeamCodes);
 
 %%% beam number
 BeamNum    = length(BeamDir);
 

%======
% Down Converter Knob
%======
 expfile = hdf5read( FileNameChar,...
                            '/Setup/Experimentfile'); 
 
                        
expstr = expfile.data;

%%% Generate character array from string
newlines = regexp(expstr, '\n');
idx = 1;
expCharArr = [];
for ii = 1:length(newlines)
    tmpLine = expstr(idx+1:newlines(ii)-1);
    idx = newlines(ii);
    expCharArr = strvcat(expCharArr, tmpLine);
end

%%% get information & search the line including the value
 BitChar = strmatch('RxBand', expCharArr);
 DCKNum = str2num(expCharArr(BitChar, 8:end));