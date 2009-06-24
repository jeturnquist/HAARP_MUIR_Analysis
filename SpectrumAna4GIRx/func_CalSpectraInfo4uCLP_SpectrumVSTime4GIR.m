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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ SNRArr, PSDArr, RangeArr ] =                   ...
           func_CalSpectraInfo4uCLP_SpectrumVsTime4GIR(  ...
           du, FreqArr, noise, ChannelNum )
     
         
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
 range = (1:RangeNum)*c*1/(SamplingRate*1e3)/1e3/2;
 range = range - RangeOffsetValue;
%  range = range - 154;
%      
% 
% %%% range to be analyzed
FitRange   = find( range >= LowerRange4Ana & range <= UpperRange4Ana );

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
     
     %%%%%% Signal to Noise Ration (SNR)

     dp  = sel_du .* conj(sel_du);
     snr = (dp - noise)/noise;
     
               
     %%%%%% PSD
     psd    = fftshift(fft(sel_du));
     psd    = psd.*conj(psd);
     mean_psd    = mean(psd,2);

     %%% product from the spectral analysis
     if Iint == 1
         SNRArr   = snr;
         PSDArr     = mean_psd;
         RangeArr   = range;
     else
         SNRArr   = [ SNRArr, snr ];
         PSDArr     = [ PSDArr, mean_psd ];
     end%if Iint == 1

 end%for Iint