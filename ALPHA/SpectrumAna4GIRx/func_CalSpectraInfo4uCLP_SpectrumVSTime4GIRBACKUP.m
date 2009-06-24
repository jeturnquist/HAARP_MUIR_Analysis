%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_CalSpectraInfo4uCLP_SpectrumVsTime4GIR
%          made by S. Oyama, GI UAF
%                   arranged by Jason Turnquist, GI UAF
%        ( ver.1.0: Aug-16-2006: copy from 
%                        func_CalSpectraInfo_uCLP_SpectrumAna4GIR.m )
%        
%
%         # calculate PSD and Power from uncoded long pulse HAARP MUIR data
%
%       BACKUP of function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ PowerArr, PSDArr, RangeArr ] =                   ...
           func_CalSpectraInfo4uCLP_SpectrumVsTime4GIRBACKUP(  ...
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
%  range = (1:RangeNum)*c*((1/SamplingRate)*1e-6)/2;
  range = (1:RangeNum)*c*1/(SamplingRate*1e3)/1e3/2;
 range = range - RangeOffsetValue;
%      
% 
% %%% range to be analyzed
%  FitRange   = find( range >= LowerRange4Ana & range <= UpperRange4Ana );

%%% set arrays
% BitLength4PulseLength = ceil(PulseLength*1e-6*SamplingRate*1e3);
% 
%  selRange = FitRange(end) - FitRange(1);
%  Power    = zeros(1, RangeNum);
%  PSD      = zeros(BitLength4PulseLength, selRange + 1);
     

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

     sel_du  = du(st:et,FitRange)';
     power  = sel_du .* conj(sel_du);
     TmpPower = mean(power,2);
               %new line on 07-18-06
               %following with suggestion from R. Todd Parris


%      if Iint == 1
%      %%%%%% Filter using Hamming window
%          M = size(sel_du);
%          for i = 1:1:M
%             window(i) = 0.54 - 0.46*cos(2*pi*i/M(1));
%          end
%          window = repmat(window,M(2),1)';
%      end
%      
%      sel_du    = sel_du.*conj(sel_du);
%      sel_du    = sel_du.*window;   
               
     %%%%%% PSD
    % [ TmpRangeNum TmpTimeNum  ]= size(sel_du)
     sel_du = mean(sel_du,2);
     TmpPSD    = fftshift(fft(sel_du));
     TmpPSD    = TmpPSD.*conj(TmpPSD);
%      if Factor4IntTime ~= 1
%          TmpPSD    = mean(TmpPSD')';
%      end%if Factor4IntTime ~= 1


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
%      FreqRes   = FreqArr(2) - FreqArr(1);
%      TmpPower  = sum(TmpPSD(FitFreq));
%      TmpPower  = TmpPower * FreqRes * 1e6;
%         TmpPower = 0;
     
     %%% arrange power data --> dB
%      RangeWidth4MaxPower  = [ 180 400 ];
%      FitRange4PowerCal    = find( range >= RangeWidth4MaxPower(1)  ...
%                           & range <= RangeWidth4MaxPower(2) );
%      MaxPower      = max(Power(FitRange4PowerCal));
     
%      MaxPower      = max(Power); 
%      Thresh4Power  = 0.0;
%      FitLowPower   = find(Power <= MaxPower*Thresh4Power);
%      FitHighPower  = find(Power > MaxPower*Thresh4Power);
%      if length(FitLowPower) ~= 0
%          Power(FitLowPower) = NaN;
%      end%if length(FitLowPower) ~= 0
%      Power(FitHighPower) = 10*log10(Power(FitHighPower));
    


     %%% product from the spectral analysis
     if Iint == 1
         PowerArr   = TmpPower;
         PSDArr     = TmpPSD;
         RangeArr   = range;
     else
         PowerArr   = [ PowerArr, TmpPower ];
         PSDArr     = [ PSDArr, TmpPSD ];
     end%if Iint == 1

 end%for Iint