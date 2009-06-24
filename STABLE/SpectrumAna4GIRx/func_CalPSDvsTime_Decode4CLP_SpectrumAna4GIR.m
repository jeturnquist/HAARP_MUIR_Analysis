%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_CalPSDvsTime_Decode4CLP_SpectrumAna4GIR
%          made by J. Turnquist, GI UAF
%
%        ( ver.1.0: Aug-6-2007: copy from 
%                             func_CalSpectraInfo_Decode4CLP_SpectrumAna4GIR.m )
%
%          # calculate PSD and Power vs Time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ MeanPSDArr ] = func_CalPSDvsTime_Decode4CLP_SpectrumAna4GIR( ...
                PSDArr, Noise4PSDArr)
     
%------
% set global parameters
%------
 global_SpectrumAna4GIR;
 
 
%------
% parameters
%------
 c           = 2.99792458e8;% speed of light
 RadarFreq   = 446;% MHz
 MeanPSD     = [];
 
 for idx = 1:1:length(PSDArr)
     idx
     scNoise4PSDArr = [];
     
     %% Get one time series
     TmpPSD = PSDArr{idx};
     
     TmpNum             = size(TmpPSD);
     scNoise4PSDArr     = repmat(Noise4PSDArr, TmpNum(2), 1)';
     
     %% scale PSD by the background noise
     scPSD              = (TmpPSD - scNoise4PSDArr) ./ scNoise4PSDArr;
     scPSD              = mean(scPSD, 2);
     
     fitZero            = find(scPSD > 0);
     scPSD(fitZero)     = 10*log10(scPSD(fitZero));
     
     MeanPSD = scPSD;
     
     if idx == 1 
     	MeanPSDArr = MeanPSD;
     else
        MeanPSDArr         = [ MeanPSDArr, MeanPSD ];
     end% if idx
     
 end% idx = 1:1:length(PSDArr)
 