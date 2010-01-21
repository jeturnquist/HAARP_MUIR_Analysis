function [ FreqArr ] = calFreqArr4CLP_GIRx(radarParam, genParam, freq)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      calFreqArr4CLP_SpectrumAna4GIR
%         made by J. Turnquist, GI UAF
%
%       1.0: 10-Jul-2009
%
%         # calculate array of the frequency in the spectrum
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 c                        = 2.99792458e8;

%% pre-shifted frequency array
%%

 FreqWidth  = radarParam.samplingRate*1e-3; %kHz
 
 DataNum     = radarParam.pulseLength/radarParam.baudLength*1e-6; %a.u.
 FreqRes     = FreqWidth/DataNum;      %kHz
 FreqArr     = FreqRes:FreqRes:FreqWidth;    %kHz
 
 
%%% center receiver-frequency
 RadarFreq   = 446;                       %MHz
 switch radarParam.DCKNum
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
 FreqArr     = FreqArr/1e3 + FreqShift/1e6 - FreqWidth/1e3/2;