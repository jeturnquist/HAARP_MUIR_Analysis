function [ results ] = getRadarParams(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       getRadarParams.m
%          made by S. Oyama, GI UAF
%           re-arranged by Jason Turnquist, GI UAF
%
%        ( ver.1.0: 26-Aug-2008: copy from func_ReadExpSetupFile_Decode4CLP_SpectrumAna4GIR )
%          ver.1.1: 01-Nov-2008 : No longer OS depenent 
%          ver.1.2: 02-Nov-2008 : fixed no okazelgrid.mat 
%          ver.2.0: 6-Jul-2009 
%
%
%          Get radar paramters from HDF5 (*.h5) file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
%% Parse input arguments.
%%
p = inputParser;

p.addRequired('fileName', @ischar)
p.addOptional('pulseType', 'uCLP', @ischar)


p.parse(varargin{:});  


fileName = p.Results.fileName;
%%
%------
% get information
%------

%%% get the sample time
SampleTime  = cast( hdf5read( fileName,...
                                      '/Rx/SampleTime'), 'double');               
%%% get the sample time
SampleRate  = cast( hdf5read( fileName,...
                                      '/Rx/SampleRate'), 'double');  
%%% get Pulse Length
% PulseLength           : pulse length (micro-second)
PulseLength = floor(cast( hdf5read(fileName,...
                              '/Raw11/Data/Pulsewidth'), 'double')*1e6);

%%% get Center Frequency                          
CenterFreq  = hdf5read( fileName,...
                            '/Rx/TuningFrequency')';                          

%======
% from TUF file
%======
tufile = hdf5read(fileName,'/Setup/Tufile');
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

StartTime4Tx = str2double(TxStartChar);


%% Inter  Pulse Period (IPP)
BitChar = strmatch('-1', tufCharArr);
IPPChar = strvcat(tufCharArr(BitChar,11:16));
IPP = str2double(IPPChar);


%% start time of sampling
BitChar = strmatch(' 7', tufCharArr);
RxStartChar = strvcat(tufCharArr(BitChar,6:8));
StartTime4Rx  = str2double(RxStartChar);
 
 
 
%======
% beam number
%======

%------
% file name
%------
 BeamCodes = hdf5read( fileName,...
                            '/Raw11/Data/Beamcodes');
 BeamDir = func_BeamCode2AzEl(BeamCodes);
 

%======
% Down Converter Knob
%======
 expfile = hdf5read( fileName,...
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
 DCKNum = str2double(expCharArr(BitChar, 8:end));

 
 
%% Get Phase Coding for Coded Long Pulse
%%
if strcmp(p.Results.pulseType, 'CLP')
    [ PhaseCoding ] = getPhaseCoding( fileName);
else
    PhaseCoding = [];
end%if PulseType
 


%% Pakage results
 results = { SampleTime     ...
           , SampleRate     ...
           , PulseLength    ...
           , CenterFreq     ...
           , StartTime4Tx   ...
           , StartTime4Rx   ...
           , BeamDir        ...
           , DCKNum         ...
           , PhaseCoding    ...
           , IPP};