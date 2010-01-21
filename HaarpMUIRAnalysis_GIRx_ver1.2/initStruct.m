function [ initParam, radarParam, genParam,  currentData] = ...
    initStruct(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       initStruct.m
%           made by J. Turnquist, GI UAF
%
%       ver.1.0: Jul-1-2009: Initialize structures 
%
%
% Initial Paramaters - Data directory
%                    - Experiment date
%                    - Experiment number
%                    - Figure save directory
%                    - Figure save extension
%                  
% Radar Paramters    - Sampling rate
%                    - Pulse length
%                    - Inter pulse period
%                    - Transmit start time
%                    - Recieve start time
%                    - Pulse sequence
%                    - Phase coding
%                    - Pulse type
%                 
% General Paramters  - Selected directory
%                    - File names in selected dir
%                    - File numbers in selected dir
%                    - Selected file names for analysis
%                    - Selected file numbers for analysis
%                    - Region of interest
%                    - Integration time
%                    - Upper range for analysis
%                    - Lower range for analysis
%                  
% Current Data       - Raw voltages (complex)
%                    - Power (voltages added in quadrature)
%                    - Matlab time
%                    - Beam coding (not to be confused 
%                        with pahse code)
%                    - Time structure
%                    - Analyzed data structure
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
if nargin < 4
    initParam   = []; 
    radarParam  = [];
    genParam    = [];
    currentData = []; 
elseif nargin < 5    
    initParam   = []; 
    radarParam  = [];
    genParam    = [];
    currentData = [];
    rn          = 'rn';
end

rn          = varargin{1};
initParam   = varargin{2}; 
radarParam  = varargin{3};
genParam    = varargin{4};
currentData = varargin{5};


s = substruct('.', rn);

%% Initilize empty Input Paramter Structure
%%
tmpStruct = struct( 'dataDir',[]                    ...
                   , 'expDate',[]                   ...
                   , 'expNum',[]                    ...
                   , 'figSaveDir',[]                ...
                   , 'figSaveExt',[] );

              
subsasgn(initParam, s, tmpStruct);

%% Initialize empty Radar Parameter Structrue
%%
tmpStruct = struct( 'samplingRate',[]               ...
                   , 'pulseLength',[]               ...
                   , 'baudLength',[]                ...
                   , 'IPP',[]                       ...
                   , 'startTime4Tx',[]              ...
                   , 'startTime4Rx',[]              ...
                   , 'fTx',[]                       ...
                   , 'fRx',[]                       ...
                   , 'pulseSequence',[]             ...
                   , 'phaseCoding',[]               ...
                   , 'pulseType', []                ...
                   , 'DCKNum',[]                    ...
                   , 'range',[]                     ...
                   , 'rangeOffset',[] );

               
subsasgn(radarParam, s, tmpStruct);               
                
%% Initialize empty General Parameter Structure
%%
tmpStruct = struct( 'selDir',[]                     ...
                 , 'fileNameArr',[]                 ...
                 , 'fileNumArr',[]                  ...
                 , 'selFileNames',[]                ...
                 , 'selFileNums',[]                 ...
                 , 'ROI',[]                         ...
                 , 'intTime',[]                     ...
                 , 'upperAnaRange',[]               ...
                 , 'lowerAnaRange',[] );

             
subsasgn(genParam, s, tmpStruct);             
             
%% Initialize empty Current Data Structure
%%             
tmpStruct = struct( 'du',[]                         ...
                    , 'dp',[]                       ...
                    , 'matlabTime',[]               ...
                    , 'range',[]                    ...
                    , 'beamCoding',[]               ...
                    , 'beamDir',[]                  ...
                    , 'time', []                    ...
                    , 'anaData', []                 ...
                    , 'record_size',[]              ...
                    , 'freqArr',[] );

               
subsasgn(currentData, s, tmpStruct);                
              

              