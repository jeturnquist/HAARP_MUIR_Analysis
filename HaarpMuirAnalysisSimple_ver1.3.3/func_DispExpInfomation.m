function [ RadarParam, GenParam ] = ...
         func_DispExpInfomation( RadarParam, GenParam )

     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_DispExpInfomation.m
%          made by J. Turnquist, GI UAF
%
%          ver.1.0: Jun-29-2008: Copied from
%             func_DispExpInfomation_PlotSNRofHaarpAmisr.m
%
%       display the major experimental information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%------
% display
%------
%
% make characters
%
 TransmitFrequencyChar          = num2str( RadarParam.TransmitFreq(1) );
 PulseLengthChar                = num2str( RadarParam.PulseLength );
 PulseSequenceChar              = num2str( RadarParam.PulseSequence );
 IntegratedTimeLengthChar       = num2str( RadarParam.IntegratedTimeLength(1) );
 ReceivingCenterFrequencyChar   = num2str( RadarParam.ReceivingCenterFrequency(1)/1e6 );
 ReceivingBandWidthChar         = num2str( ceil(RadarParam.ReceivingBandWidth(1)/1e3)/1e3 );
 SamplingRateChar               = num2str( RadarParam.SamplingRate(1) );
 
 
 
%
% display
%
 disp( '%%%%%%%%%%%% Radar Parameters %%%%%%%%%%' )
 disp( ' ### Transmitter ###' )
 disp( [ '  transmit frequency [MHz]    : ', TransmitFrequencyChar ] )
 disp( [ '  pulse length [micro-sec]    : ', PulseLengthChar ] ) 
 disp( [ '  integration time [sec]      : ', IntegratedTimeLengthChar ] )
 disp( [ '  pulse sequence [micro-sec]  : ', PulseSequenceChar ] )
 disp( ' ### Receiver ###' )
 disp( [ '  sampling rate [kHz]         : ', SamplingRateChar ] )
 disp( [ '  center frequency [MHz]      : ', ReceivingCenterFrequencyChar ] )
 disp( [ '  band width [kHz]            : ', ReceivingBandWidthChar ] )
 disp( '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' )
 
 