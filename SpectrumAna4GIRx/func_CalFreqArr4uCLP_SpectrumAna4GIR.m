%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      func_CalFreqArr4uCLP_SpectrumAna4GIR
%         made by Shin-ichiro Oyama, GI UAF
%
%         ver.1.0: 06-Jul-2006
%         ver.1.1: 31-Jul-2006: revise the OrigValue
%
%         # calculate array of the frequency in the spectrum
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ FreqArr ] = func_CalFreqArr4uCLP_SpectrumAna4GIR(freq, du)
%------
% set global parameter
%------
 global_SpectrumAna4GIR;
 
 c                        = 2.99792458e8;
%------
% calculation
%------
%%% pre-shifted frequency array
 FreqWidth   = SamplingRate;           %kHz
%  DataNum     = ceil(PulseLength*1e-6*SamplingRate*1e3); %a.u.

 range = (1:size(du,2))*c*1/(SamplingRate*1e3)/1e3/2;
 range = range - RangeOffsetValue;
 FitRange   = find( range >= LowerRange4Ana & range <= UpperRange4Ana );

 DataNum     = length(FitRange); %a.u.
 FreqRes     = FreqWidth/DataNum;      %kHz
 FreqRes     = round(FreqRes*100)/100;
 FreqArr     = 0:FreqRes:FreqWidth;    %kHz
 
 
%%% center receiver-frequency
 RadarFreq   = 446;                       %MHz
 switch DCKNum
     case 440
         OrigValue   = 26e6;              %Hz
     case 445
         OrigValue   = 21e6;              %Hz
     case 450
         OrigValue   = 16e6;              %Hz
 end%switch DCKNum
 FreqShift   = freq - OrigValue;          %Hz
 CenterFreq  = RadarFreq + FreqShift/1e6; %MHz
 
 
%%% shift the frequency array
 FreqArr     = FreqArr/1e3 + CenterFreq - FreqWidth/1e3/2;