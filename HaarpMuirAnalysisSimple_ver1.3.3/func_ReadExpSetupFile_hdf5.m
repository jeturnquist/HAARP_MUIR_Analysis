%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_ReadExpSetupFile_hdf5.m
%           made by J. Turnquist, GI UAF
%
%       ver.1.0: Jun-24-2008: Read experiment file for selected data
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ RadarParam status ] = func_ReadExpSetupFile_hdf5(...
                            InputParam, RadarParam, GenParam)
            
status = 1;
                        
DirChar = fullfile(InputParam.Directory4MUIRData, GenParam.SelectedDirChar);
FileNameChar = dir([DirChar filesep '*.h5']);

FileNameChar = fullfile(DirChar, FileNameChar(1).name);


%% Read timing unit info from selected *.hf file
%%
try
    tufile = hdf5read(FileNameChar,'/Setup/Tufile');
    tufstr = tufile.data;
catch
    disp('## Error: Could not read file: ##')
    disp('')
    disp('')
    disp(['     ', FileNameChar])
    disp('')
    disp('')
    disp('## Check path. ##');
    status = -1;
    return
end

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

RadarParam.StartTime4Tx = str2num(TxStartChar);


%% Inter  Pulse Period (IPP)
BitChar = strmatch('-1', tufCharArr);
IPPChar = strvcat(tufCharArr(BitChar,11:16));
RadarParam.IPP = str2num(IPPChar);


%% start time of sampling
BitChar = strmatch(' 7', tufCharArr);
RxStartChar = strvcat(tufCharArr(BitChar,6:8));
RadarParam.StartTime4Rx  = str2num(RxStartChar);

 
%% get the sample time
RadarParam.SampleTime = cast( hdf5read( FileNameChar,...
                                      '/Rx/SampleTime'), 'double');
                                  
%% get sampling rate
 RadarParam.SamplingRate  = cast( hdf5read( FileNameChar,...
                                '/Rx/SampleRate'), 'double')/1000;
                     

%% get Pulse Length
% PulseLength           : pulse length (micro-second)
 RadarParam.PulseLength = floor(cast( hdf5read(FileNameChar,...
                              '/Raw11/Data/Pulsewidth'), 'double')*1e6);
                          
 