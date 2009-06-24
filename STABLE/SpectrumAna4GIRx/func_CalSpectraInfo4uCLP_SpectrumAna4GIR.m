%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_CalSpectraInfo4uCLP_SpectrumAna4GIR
%          made by S. Oyama, GI UAF
%                   arranged by Jason Turnquist, GI UAF
%        ( ver.1.0: Aug-16-2006: copy from 
%                        func_CalSpectraInfo_Decode4CLP_SpectrumAna4GIR.m )
%        
%
%         # calculate PSD and Power from uncoded long pulse HAARP MUIR data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ PowerArr, PSDArr, RangeArr ] =                   ...
           func_CalSpectraInfo4uCLP_SpectrumAna4GIR(  ...
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
 range = (1:RangeNum)*c*(1/SamplingRate*1e3)*1e-6/1e3/2;
 range = range - RangeOffsetValue;
     

%%% range to be analyzed
 FitRange   = find( range >= LowerRange4Ana & range <= UpperRange4Ana );

%%% set arrays
 BitLength4PulseLength = ceil(PulseLength*1e-6*SamplingRate*1e3);

 selRange = FitRange(end) - FitRange(1);
 Power    = zeros(1, RangeNum);
 PSD      = zeros(BitLength4PulseLength, selRange + 1);
     

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
     
     
     %%%
     %%% Iteration over the range selection
     %%%
     for Irange = FitRange(1):FitRange(end)
         %%%%%% select du
         sr      = Irange;
         er      = sr + BitLength4PulseLength - 1; 
         
         if er > RangeNum
             continue
         end%if er > RangeNum
         
         
         sel_du  = du(st:et,sr:er)';
         sel_du  = conj(sel_du);
                   %new line on 07-18-06
                   %following with suggestion from R. Todd Parris
            

         %%%%%% PSD
%          [ TmpRangeNum TmpTimeNum  ]= size(sel_du)
         
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


         %%%%%% save data
         Power(Irange-FitRange(1)+1)    = TmpPower;
         PSD(:,Irange-FitRange(1)+1)	= TmpPSD'; 
         PSD(:,Irange-FitRange(1)+1)	= TmpPSD; 
     end %%for Irange
     
     
     %%% arrange power data --> dB
%      RangeWidth4MaxPower  = [ 180 400 ];
%      FitRange4PowerCal    = find( range >= RangeWidth4MaxPower(1)  ...
%                           & range <= RangeWidth4MaxPower(2) );
%      MaxPower      = max(Power(FitRange4PowerCal));
     
     MaxPower      = max(Power); 
     Thresh4Power  = 0.0;
     FitLowPower   = find(Power <= MaxPower*Thresh4Power);
     FitHighPower  = find(Power > MaxPower*Thresh4Power);
     if length(FitLowPower) ~= 0
         Power(FitLowPower) = NaN;
     end%if length(FitLowPower) ~= 0
%      Power(FitHighPower) = 10*log10(Power(FitHighPower));
     

     
     
     %%% product from the spectral analysis
     if Iint == 1
         PowerArr   = Power;
         PSDArr     = {PSD};
         RangeArr   = range;
     else
         PowerArr   = [ PowerArr; Power ];
         PSDArr     = [ PSDArr, {PSD} ];
     end%if Iint == 1
 end%for Iint