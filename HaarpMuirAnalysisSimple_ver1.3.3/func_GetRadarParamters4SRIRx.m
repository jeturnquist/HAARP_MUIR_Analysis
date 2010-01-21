function [RadarParam, GenParam ] = func_GetRadarParamters4SRIRx( RadarParam	...
                                                         , InputParam	...
                                                         , GenParam )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_GetRadarParamters4SRIRx.m
%          made by J. Tunrquist, GI UAF
%
%          ver.1.0: Aug-8-2008
%
%       Get the radar paramters from the .h5 file 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ifile = 1;

%%% Selected file directory 
FileChar   = fullfile( InputParam.Directory4MUIRData              ...
                          , GenParam.SelectedDirChar                    ...
                          , GenParam.SelectedFileNames{Ifile});

%%% Transmit tuning freq
RadarParam.TransmitFreq = hdf5read(FileChar , '/Tx/TuningFrequency');

GenParam.IntegratedTimeLength   = [];
RadarParam.PulseSequence        = [];

%%% Baud length
RadarParam.SampleTime = hdf5read( FileChar, '/Rx/SampleTime')';

%%% Selected time length for integration (ms)
RadarParam.IntegratedTimeLength = ...
         RadarParam.IPP*GenParam.Factor4IntTime/1e6;
%%% Reciever center freq (transmit freq - fHF)     
RadarParam.ReceivingCenterFrequency = hdf5read( FileChar,   ...
                            '/Rx/TuningFrequency')';
%%% Bandwidth of reciever                        
RadarParam.ReceivingBandWidth = hdf5read( FileChar,         ...
                            '/Rx/Bandwidth')';
                        
%%
%% Get Phase Coding for Coded Long Pulse
%%
if strcmp(InputParam.PulseType, 'CLP')
    [RadarParam] = func_GetPhaseCoding( GenParam       ...
                                      , RadarParam      ...
                                      , InputParam);
end%if PulseType
