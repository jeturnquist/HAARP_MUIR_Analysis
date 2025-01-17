%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_InputGeneralAnalysisParameters.m
%           made by J. Turnquist, GI UAF
%
%       ver.1.0: Jun-24-2008: Input general parameters from .txt
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ InputParam, status ] = func_InputGeneralAnalysisParameters(	...
                                    Directory4GeneralParamsAsciiFile    ...
                                  , InputParam)


FileNameChar = fullfile(Directory4GeneralParamsAsciiFile,               ...
                            'GeneralParameters.txt');  


                   
%% Read in general paramter values from user created ascii file   
%%
[ params, status ] = func_ReadInputGeneralAnalysisParametersFromAscii(...
     FileNameChar);
 
if status < 0; return; end 




%% Set General Paramter Structure
%%
 InputParam = struct( 'DataFormat',str2num(params{1})       ...
                    , 'Directory4MUIRData',params{2}        ...
                    , 'SelectedDateChar', params{3}         ...
                    , 'ExpNumberChar', params{4}            ...
                    , 'DataFileNumbers', str2num(params{5}) ...
                    , 'SaveFigExt', params{6}             	...
                    , 'SaveDirectory',params{7}             ...
                    , 'PulseType', params{8}                ...
                    , 'Factor4IntTime', str2num(params{9})  ...
                    , 'LowerRange', str2num(params{10})     ...
                    , 'UpperRange', str2num(params{11}) );
                   
                   