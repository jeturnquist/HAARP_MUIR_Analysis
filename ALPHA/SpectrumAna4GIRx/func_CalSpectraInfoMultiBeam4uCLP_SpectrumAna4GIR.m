%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_CalSpectraInfoMultiBeam4uCLP_SpectrumAna4GIR
%          made by S. Oyama, GI UAF
%                   arranged by Jason Turnquist, GI UAF
%        ( ver.1.0: Aug-16-2006: copy from 
%                 func_CalSpectraInfoMultiBeam_Decode4CLP_SpectrumAna4GIR )
%
%          # calculate PSD and Power
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ PowerArr, PSDArr, RangeArr ] =                   ...
           func_CalSpectraInfoMultiBeam4uCLP_SpectrumAna4GIR(  ...
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
 
 
%%%
%%% iteration over BeamNum
%%%
 for Ibeam = 1:BeamNum
     %------
     % calculate the parameters
     %------
     %%% set parameters
     if Ibeam == 1
         TmpSize                 = size(du);
         TimeNum                 = TmpSize(1);
         RangeNum                = TmpSize(2);
     end%if Ibeam == 1
     
     
     %%% range
     if Ibeam == 1
         range = (1:RangeNum)*c*(1/SamplingRate*1e3)*1e-6/1e3/2;
         range = range - RangeOffsetValue;
     end%if Ibeam == 1
     
     
     %%% range to be analyzed
     RangeShiftDueToMultiBeam = IPP/1e6 * c /1e3/2; 
     FitRange   = ...
         find( range >= LowerRange4Ana+RangeShiftDueToMultiBeam*(Ibeam-1) ...
             & range <= UpperRange4Ana+RangeShiftDueToMultiBeam*(Ibeam-1) );
         
             
     %%% set arrays
     %%%%%% temporal arrays
     TmpNum   = FitRange(end)-FitRange(1)+1;
     Power    = zeros(1,TmpNum);
     PSD      = zeros(size(du,1),TmpNum);
     
     
     %%% estimate the iteration number following the integration time
     TimeNum4Integration = fix( TimeNum/Factor4IntTime );
     
     
     %%% set arrays
     %%%%%% arrays to be returned
     if Ibeam == 1
         PowerArr   = zeros( BeamNum, TimeNum4Integration, TmpNum ) - 9999;
         PSDArr     = cell( BeamNum, TimeNum4Integration );
     end%if Ibeam == 1
     
     
     
     
     
     
     %%%
     %%% iteration over the integration time
     %%%
     for Iint = 1:TimeNum4Integration
         %%% start & end time-element number
         st    = 1 + Factor4IntTime*(Iint-1);
         et    = st + Factor4IntTime - 1;
         
         
         %%% arrange the binary-phase coding array
         SelBinaryPhaseCoding2D  = BinaryPhaseCoding2D(st:et,:);
         
         
         %%%%%% display
         TmpChar    = [ 'Beam:' num2str(Ibeam) ' Time:' num2str(Iint) '/'        ...
                      num2str(TimeNum4Integration) ];
         disp( TmpChar )

         sel_du                 = du(st:et,:)';
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
             
             
         %%%%%% save data
%        Power(Irange-FitRange(1)+1) = TmpPower;
%        PSD(:,Irange-FitRange(1)+1) = TmpPSD;  
         
         
         %%% arrange power data --> dB
%          RangeWidth4MaxPower  = [ 180 400 ] + ...
%                                 RangeShiftDueToMultiBeam*(Ibeam-1);
%          FitRange4PowerCal    = find( range >= RangeWidth4MaxPower(1)  ...
%                                     & range <= RangeWidth4MaxPower(2) );
%          Thresh4Power  = 0.0;
%          MaxPower      = max(Power(FitRange4PowerCal));
%          FitLowPower   = find(Power <= MaxPower*Thresh4Power);
%          FitHighPower  = find(Power > MaxPower*Thresh4Power);
%          if length(FitLowPower) ~= 0
%              Power(FitLowPower) = NaN;
%          end%if length(FitLowPower) ~= 0
%          Power(FitHighPower) = 10*log10(Power(FitHighPower));
     
     
     
         %%% product from the spectral analysis
         if Iint == 1 & Ibeam == 1
             RangeArr = range;
         end%if Iint == 1 & Ibeam == 1
         PowerArr( Ibeam, Iint, : )  = Power;
         PSDArr{ Ibeam, Iint }       = PSD;
     end%for Iint
 end%for Ibeam