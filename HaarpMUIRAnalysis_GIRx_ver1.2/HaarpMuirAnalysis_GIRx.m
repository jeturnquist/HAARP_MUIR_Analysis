%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       HaarpMuirAnalysis_GIRx.m
%           made by J. Turnquist, GI UAF
%       
%       Analyze data from MUIR from either SRI reciever (SRIRx) or GI
%       reciever (GIRx)
%
%       ver.1.0: 30-Jul-2009
%
%   -------
%   Input : 
%
%   -------
%   Output:
%   -------
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% User defined paramters
%%

%%% ------------------------
%%% Directory path for data:      
%%% ------------------------
%
% NOTE:   The directory path for the MUIR data cannot contain spaces when  
%       running HaarpMuirAnalysis.m on a windows machince. MATLAB uses the
%       local command line (i.e DOS-prompt in windows). DOS-prompt does not
%       support spaces in directory names and it is not possible to escape
%       the spaces (if I am wrong please let me know). 
%         Thus, either place the data in a directory path containing no
%       spaces or use the windows short name convention.
%           'C:\Documents and Settings' --> 'C:\DOCUME~1' (short name)
%
%         On a *nix system it is possible to escape spaces using a
%       backslash (\).
%            '/PARS summer school 2007' --> '/PARS\ summer\ school\ 2007'

Directory4SRIRxData =  ...
        '/Users/jet/Work/Data/August2009/SRIRx/nrl-1/';
%     '/Volumes/MYBOOK/DATA_SRI-Rx_August2009campaign/NRL-2/'

% Directory4SRIRxData = ['test_data/'];

Directory4GIRxData  = ...
        '/Users/jet/Work/Data/August2009/GIRx/';
%     '/Volumes/MYBOOK/DATA_GI-Rx_August2009campaign/'

% Directory4GIRxData = ['test_data/']

FigureSaveDirectory       = ...
    '/Users/jet/Work/Data/August2009/GIRx/Analyzed/';

SelDate             = '20090812';

SaveFigExt         = 'jpg';         %% 0   : Do not save figure
                                    %% jpg : Save figure as JPG to selected 
                                    %%        directory
                                    %% fig  : Save figure as fig
                                    %% eps : Save figure as EPS 
                                    %% tif : Save figure as TIFF
                                    %% pdf  : Save figure as PDF
                                    %% See help print for other data 
                                    %%  formats
                                    

GIRX_SamplingRate = 1000000;        %% (Hz) Sampling rate of GI reciever 

%% Initialize structures
%%
initParam   = []; %% Initial Paramaters - Data directory
                  %%                    - Experiment date
                  %%                    - Experiment number
                  %%                    - Figure save directory
                  %%                    - Figure save extension
                  
radarParam  = []; %% Radar Paramters    - Sampling rate
                  %%                    - Pulse length
                  %%                    - Inter pulse period
                  %%                    - Transmit start time
                  %%                    - Recieve start time
                  %%                    - Pulse sequence
                  %%                    - Phase coding
                 
genParam    = []; %% General Paramters  - Selected directory
                  %%                    - File names in selected dir
                  %%                    - File numbers in selected dir
                  %%                    - Selected file names for analysis
                  %%                    - Selected file numbers for analysis
                  %%                    - Region of interest
                  %%                    - Integration time
                  %%                    - Upper range for analysis
                  %%                    - Lower range for analysis
                  
currentData = []; %% Current Data       - Raw voltages (complex)
                  %%                    - Power (voltages added in quadrature)
                  %%                    - Matlab time
                  %%                    - Beam coding (not to be confused 
                  %%                        with pahse code)
                  %%                    - Time structure
                  %%                    - Analyzed data structure

%%%
%%% initialize structures for GIRx 
%%%
[ initParam, radarParam, genParam, currentData ] = ...
    initStruct('gi', initParam, radarParam, genParam, currentData);

%%%
%%% initialize structures for SRIRx 
%%%
[ initParam, radarParam, genParam, currentData ] = ...
    initStruct('sri', initParam, radarParam, genParam, currentData);



%%% Set initial paramters
initParam.sri.dataDir  = Directory4SRIRxData;
initParam.gi.dataDir   = Directory4GIRxData;

initParam.gi.figSaveDir     = FigureSaveDirectory;
initParam.gi.expDate     = SelDate;
initParam.gi.figSaveExt  = SaveFigExt;


%%% Set General Analysis Parameters Structure


%% select data file
%%

genParam.gi.selDir     = fullfile(initParam.gi.dataDir, SelDate);

%%% pick-up - the data number from the GI receiver,
%%%         - the pulse-coding type, and
%%%         - data number from the SRI receiver
%%% input: directory of text file GISRIDataNum_yyyymmdd.txt [char]
%%%        experiment date (yyyymmdd) [char]
%%%
%%% output: data numbers for GIRx contained in .txt [numeric] (optional)
%%%         data numbers for SRIRx containted in .txt [cell] (optional)
%%%         pulse type (uCLP or CLP) (cell)
[initParam.gi.expNum, initParam.sri.expNum, radarParam.gi.pulseType ]= ...
    getExpNum_GIRx(genParam.gi.selDir, initParam.gi.expDate);



%%% select a data number from the GI receiver
%%%      e.g. "33" of "33.01"
%%% input: array of experiment numbers [numeric] (required)
%%%
%%% output: user selected experiment number [numeric]
[ tmpExpNum ] = selectDataNum_GIRx(initParam.gi.expNum);

selExpNum_idx = find(initParam.gi.expNum == tmpExpNum);
initParam.gi.expNum = initParam.gi.expNum(selExpNum_idx); 



%%% Parse contents of a folder and return file name parts 
%%% input:  directory  [string] (optional)
%%%         file extention (ex '.txt' or '.dat') [string] (optional)
%%%         string delimiter token (ex '.')  [string] (optional)
%%%
%%% Output: cell array containg parts of file name delimited by token
%%%                    'tok' not including file extention 'ext'.
[genParam.gi.fileNumArr, genParam.gi.fileNameArr ] = ...
    getFileList(genParam.gi.selDir, '*.dat');

tmpFileName = cell2mat(genParam.gi.fileNameArr);

expNum_idx  = find(tmpFileName(:,1) == num2str(initParam.gi.expNum)); 

tmpFileName = tmpFileName(expNum_idx,:);
tmpFileNum  = cell2mat(genParam.gi.fileNumArr(expNum_idx));

genParam.gi.fileNumArr  = genParam.gi.fileNumArr(expNum_idx);
genParam.gi.fileNameArr = genParam.gi.fileNameArr(expNum_idx);

%%% select A data-extention number from the GI receiver
%%%      e.g. "01" of "33.01"
%%% input: array of file numbers [numeric] (required)
%%%        array of file names [string] (required)
%%%
%%% output: user selected file numbers [numeric]
%%%         user selected file names [string
[ genParam.gi.selFileNums, genParam.gi.selFileNames ] = ...
    selectFileNum4Ana(tmpFileNum, tmpFileName);

%%% clear tmp variables
clear -regexp 'tmp';




genParam.sri.selDir = fullfile(initParam.sri.dataDir, initParam.sri.expNum{selExpNum_idx});

%%% Parse contents of a folder and return file name parts 
%%% input:  directory  [string] (optional)
%%%         file extention (ex '.txt' or '.dat') [string] (optional)
%%%         string delimiter token (ex '.')  [string] (optional)
%%%
%%% Output: cell array containg parts of file name delimited by token
%%%                    'tok' not including file extention 'ext'.
[genParam.sri.fileNumArr, genParam.sri.fileNameArr ] = ...
    getFileList(genParam.sri.selDir, '*.h5');



%% Read Experiment Setup File located in SRIRx .h5 data file
%%%
fileNameSRIRx = fullfile(genParam.sri.selDir, genParam.sri.fileNameArr{1});
[results] = getRadarParams(fileNameSRIRx , radarParam.gi.pulseType{1});

%%%
%%% unpack results
%%%
radarParam.gi.samplingRate  = results{2};
radarParam.gi.pulseLength   = results{3};
radarParam.gi.baudLength    = results{1};  
radarParam.sri.fRx          = results{4}(1);
radarParam.gi.startTime4Tx  = results{5};
radarParam.gi.startTime4Rx  = results{6};
radarParam.gi.DCKNum        = results{8};
radarParam.gi.phaseCoding   = results{9};
radarParam.gi.beamDir       = results{7};
currentData.gi.beamDir      = results{7};
radarParam.gi.IPP           = results{10};


clear results

%%% if the sampling rate of the GI reciever differs from that of th SRI
%%% reciever put the correct sampling rate below in hertz
if radarParam.sri.samplingRate ~= GIRX_SamplingRate
    radarParam.gi.samplingRate  = GIRX_SamplingRate; %%(Hz)
end


%% 
switch radarParam.gi.pulseType{selExpNum_idx}
    case {'uCLP'}
        %% Spectrum analysis for Uncoded Long Pulse Data
        SpectrumAna4uCLP_GIRx(initParam, genParam, radarParam, currentData);
    
    case {'CLP'}
        %% Spectrum analysis for Coded Long Pulse Data  
        SpectrumAna4CLP_GIRx(initParam, genParam, radarParam, currentData);
end
 