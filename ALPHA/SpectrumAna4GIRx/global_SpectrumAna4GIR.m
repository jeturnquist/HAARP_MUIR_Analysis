%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      global_SpectrumAna4GIR.m
%         made by Shin-ichiro Oyama, GI UAF
%
%         ver.1.0: 05-Jul-2006
%
%         # global parameter for Spectrum using data from the GI receiver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OS
 global OSChar
 
 
%%% data directory
 global DataDirectory4GIR
 global DataDirectory4SRIR
 global SelDate
 global JpgSaveDirectory 
 
%%% data file
 global SelDataNum4GIR
 global SelDataExtNum4GIR
 global DataFileName4GIR
 global SelDataNum4SRIR
 global CountDataNum4GIR
 global DataNumArr
 global DataExtArr
 
%%% pulse coding type
 global SelPulseCodingType
 
 
%%% GI receiver channel type
 global ChannelType
 
 
%%% parameters spectrum analysis
 global AnaStyle
 
 switch char(SelPulseCodingType)
     case {'CLP'}%for coded long pulse
         global AnaStyle
         global TimeStampNumber
         global Factor4IntTime
         global UpperRange4Ana
         global LowerRange4Ana
         global fHF
         
         global BaudLength
         global PulseLength
         global SamplingRate
         global PhaseCoding
         global StartTime4Tx
         global StartTime4Rx
         global IPP
         
         global RangeOffsetValue
         global BeamNum
         global BeamAngleX BeamAngleY
         global DCKNum
         
     case {'uCLP'}%for uncoded long pulse
         global AnaStyle
         global TimeStampNumber
         global Factor4IntTime
         global UpperRange4Ana
         global LowerRange4Ana
         global fHF
         
         global BaudLength
         global PulseLength
         global SamplingRate
         global StartTime4Tx
         global StartTime4Rx
         global IPP
         global SampleTime
         global BitLength4PulseLength
         global FitRange
         
         global RangeOffsetValue
         global BeamNum
         global BeamAngleX BeamAngleY
         global DCKNum
 end%switch char(SelPulseCodingType)
 