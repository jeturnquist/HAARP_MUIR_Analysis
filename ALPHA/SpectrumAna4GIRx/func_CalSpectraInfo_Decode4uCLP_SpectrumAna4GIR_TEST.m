%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_CalSpectraInfo4uCLP_SpectrumAna4GIR_TEST
%          made by S. Oyama, GI UAF
%                   arranged by Jason Turnquist, GI UAF
%        ( ver.1.0: Aug-16-2006: copy from 
%                        func_CalSpectraInfo_Decode4CLP_SpectrumAna4GIR.m )
%        
%
%         # calculate PSD and Power from uncoded long pulse HAARP MUIR data
%           TEST function. Uses entire range selection for FFT instead of
%           PulseLength / SampleTime.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ PowerArr, PSDArr, RangeArr ] =                   ...
           func_CalSpectraInfo_Decode4uCLP_SpectrumAna4GIR_TEST(  ...
           du, FreqArr, ChannelNum )
     
         
%------
% set global parameters
%------
global_SpectrumAna4GIR;
 
 
%------
% parameters
%------
 c           = 2.99792458e8;% speed of light
 RadarFreq   = 446;% MHz
 
 
 
%------
% calculate the parameters
%------
%%% set parameters
 TmpSize                 = size(du);
 TimeNum                 = TmpSize(1);
 RangeNum                = TmpSize(2);
 	
     
%%% range
%%% note: SamplingRate (kHz)
%  range = (1:RangeNum)*c*(1/SamplingRate*1e3)*1e-6/1e3/2;
 range = (1:RangeNum)*c*((1/SamplingRate)*1e-6)/2;
 range = range - RangeOffsetValue;
     

%%% range to be analyzed
 FitRange   = find( range >= LowerRange4Ana & range <= UpperRange4Ana );

%%% set arrays
TmpPower = [];
TmpPSD   = [];

PowerArr = [];
PSDArr   = [];

%%% estimate the iteration number following the integration time
 TimeNum4Integration = fix( TimeNum/Factor4IntTime );

%%%
%%% iteration over the integration time
%%%
 for Iint = 1:TimeNum4Integration
     %%% start & end time-element number
     st    = 1 + Factor4IntTime*(Iint-1);
     et    = st + Factor4IntTime - 1;
     
     %%%%%% display
     TmpChar    = [ 'Time:' num2str(Iint) '/'        ...
                    num2str(TimeNum4Integration) ];
     disp( TmpChar )

         %%%%%% select du
         sr      = FitRange(1);
         er      = FitRange(end); 

         sel_du  = du(st:et,sr:er)';
         sel_du  = conj(sel_du);
                   %new line on 07-18-06
                   %following with suggestion from R. Todd Parris


         %%%%%% PSD
         TmpPSD    = fftshift(fft(sel_du));
         TmpPSD    = TmpPSD.*conj(TmpPSD);
         if Factor4IntTime ~= 1
             TmpPSD    = mean(TmpPSD');
         end%if Factor4IntTime ~= 1


         %%%%%% power
         %%%%%%%%% frequency range for integration
         if ChannelType(ChannelNum) == 'I'
             FreqWidth4Integration = 0.005;%MHz
             CenterFreq            = RadarFreq;
         else
             FreqWidth4Integration = 0.010;%MHz
             CenterFreq = RadarFreq + sign(min(FreqArr)-RadarFreq)*fHF;
         end%if mean(FreqArr)-RadarFreq < 1e-3
         
         ss_freq   = CenterFreq - FreqWidth4Integration;
         ee_freq   = CenterFreq + FreqWidth4Integration;
         FitFreq   = find( FreqArr >= ss_freq & FreqArr <= ee_freq );


         %%%%%%%%% calculate power
         FreqRes   = FreqArr(2) - FreqArr(1);
         TmpPower  = sum(TmpPSD(FitFreq));
         TmpPower  = TmpPower * FreqRes * 1e6;

     
     %%% arrange power data --> dB
%      RangeWidth4MaxPower  = [ 180 400 ];
%      FitRange4PowerCal    = find( range >= RangeWidth4MaxPower(1)  ...
%                           & range <= RangeWidth4MaxPower(2) );
%      Thresh4Power  = 0.0;
%      MaxPower      = max(TmpPower(FitRange4PowerCal));
%      FitLowPower   = find(TmpPower <= MaxPower*Thresh4Power);
%      FitHighPower  = find(TmpPower > MaxPower*Thresh4Power);
%      if length(FitLowPower) ~= 0
%          TmpPower(FitLowPower) = NaN;
%      end%if length(FitLowPower) ~= 0
% %      Power(FitHighPower) = 10*log10(Power(FitHighPower));
     

     
     
     %%% product from the spectral analysis
     if Iint == 1
         RangeArr   = range;
     else
         PowerArr   = [ PowerArr; TmpPower ];
         PSDArr     = [ PSDArr, TmpPSD ];
     end%if Iint == 1
 end%for Iint