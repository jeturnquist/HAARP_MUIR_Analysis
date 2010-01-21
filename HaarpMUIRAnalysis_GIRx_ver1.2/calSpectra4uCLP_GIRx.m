function [ SNRArr, PSDArr, RangeArr ] = ...
    calSpectra4uCLP_GIRx(genParam, radarParam, currentData, ch)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       calSpectra4uCLP_GIRx.m
%          made by S. Oyama, GI UAF
%                   arranged by Jason Turnquist, GI UAF
%        ( ver.1.0: Aug-16-2006: copy from 
%                        func_CalSpectraInfo_uCLP_SpectrumAna4GIR.m )
%        
%
%         # calculate PSD and Power from uncoded long pulse HAARP MUIR data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
       
%% Parse input arguments.
%%
% p = inputParser;
% 
% p.addRequired('du', @isnumeric)
% p.addRequired('pulseLength', @isnumeric)
% p.addRequired('samplingRate', @isnumeric)
% 
% 
% p.parse(varargin{:});       

%% parameters
%%
 c           = 2.99792458e8;% speed of light
 RadarFreq   = 446;% MHz
 
 

%% calculate the parameters
%%

%%% set parameters
 TmpSize                 = size(currentData.du{ch});
 TimeNum                 = TmpSize(1);
 RangeNum                = TmpSize(2);
 	
     


% %%% range to be analyzed
FitRange   = find( radarParam.range >= genParam.lowerAnaRange ...
    & radarParam.range <= genParam.upperAnaRange );

%%% estimate the iteration number following the integration time
TimeNum4Integration = fix( TimeNum/genParam.intTime );
   

%%%
%%% iteration over the integration time
%%%
 for Iint = 1:TimeNum4Integration
     %%% start & end time-element number
     st    = 1 + genParam.intTime*(Iint-1);
     et    = st + genParam.intTime - 1;
     
     %%%%%% display
     TmpChar    = [ 'Time:' num2str(Iint) '/'        ...
                    num2str(TimeNum4Integration) ];
     disp( TmpChar )

     sel_du  = currentData.du{ch}(st:et,FitRange)';
     
     %%%%%% Signal to Noise Ration (SNR)

     dp  = sel_du .* conj(sel_du);
     noise = currentData.anaData.noise4Power{ch};
     snr = (dp - noise)/noise;
     
               
     %%%%%% PSD
     psd    = fftshift(fft(sel_du));
     psd    = psd.*conj(psd);
     mean_psd    = mean(psd,2);

     %%% product from the spectral analysis
     if Iint == 1
         SNRArr   = snr;
         PSDArr     = mean_psd;
     else
         SNRArr   = [ SNRArr, snr ];
         PSDArr     = [ PSDArr, mean_psd ];
     end%if Iint == 1

 end%for Iint