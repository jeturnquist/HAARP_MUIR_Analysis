%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      func_CalFreqArrCLP_SpectrumAna4GIR
%         made by Shin-ichiro Oyama, GI UAF
%
%         ver.1.0: 06-Jul-2006
%         ver.1.1: 31-Jul-2006: revise the OrigValue
%
%         # calculate array of the frequency in the spectrum
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ FreqArr ] = func_CalFreqArr4CLP_SpectrumAna4GIR(freq)
%------
% set global parameter
%------
 global_SpectrumAna4GIR;
 
 
 
%------
% calculation
%------
%%% pre-shifted frequency array
 FreqWidth   = SamplingRate;           %kHz
 DataNum     = PulseLength/BaudLength; %a.u.
 FreqRes     = FreqWidth/DataNum;      %kHz
 FreqArr     = FreqRes:FreqRes:FreqWidth;    %kHz
 
 
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