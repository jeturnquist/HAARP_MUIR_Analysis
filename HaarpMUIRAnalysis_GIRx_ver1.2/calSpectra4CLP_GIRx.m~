function [ PowerArr, SNRArr, PSDArr ] = ...
    calSpectra4CLP_GIRx(genParam, radarParam, currentData, chIdx)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       calSpectra4CLP_GIRx.m    
%          made by S. Oyama, GI UAF
%                   arranged by Jason Turnquist, GI UAF
%        ( ver.1.0: Aug-16-2006: copy from 
%                        func_CalSpectraInfo_uCLP_SpectrumAna4GIR.m )
%        
%
%         # calculate PSD and Power from coded long pulse HAARP MUIR data
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

%% Unpack parameters
%%


 c           = 2.99792458e8;% speed of light
 RadarFreq   = 446;% MHz
 
 

%%
%% set parameters
%%

 
%%
%% code
%%

 BinaryPhaseCoding2D  = ...
     repmat( radarParam.phaseCoding,length(currentData.du{chIdx}(:,1)),1);
 
 
 
%------
% calculate the parameters
%------
%%% set parameters
 TmpSize                 = size(currentData.du{chIdx});
 TimeNum                 = TmpSize(1);
 RangeNum                = TmpSize(2);
 	
 
%%% range to be analyzed
 FitRange   = find( radarParam.range >= genParam.lowerAnaRange ...
     & radarParam.range <= genParam.upperAnaRange );

%%% estimate the iteration number following the integration time
 TimeNum4Integration = fix( TimeNum/genParam.intTime );
     
%%% set arrays
 Power    = zeros(length(FitRange),1);
 SNR    = zeros(length(FitRange),1);
 PSD      = zeros(length(radarParam.phaseCoding),FitRange(end)-FitRange(1)+1);
     

   

 
%%%
%%% iteration over the integration time
%%%
 for Iint = 1:TimeNum4Integration
     %%% start & end time-element number
     st    = 1 + genParam.intTime*(Iint-1);
     et    = st + genParam.intTime - 1;
     
     
     %%% arrange the binary-phase coding array
     SelBinaryPhaseCoding2D  = BinaryPhaseCoding2D(st:et,:);
     
     
     %%%%%% display
     TmpChar    = [ 'Time:' num2str(Iint) '/'        ...
                    num2str(TimeNum4Integration) ];
     disp( TmpChar )
     
     
     %%%
     %%% iteration over the range
     %%%
     for Irange = FitRange(1):FitRange(end)
         %%%%%% select du
         BitLength4PulseLength  = radarParam.pulseLength/...
             radarParam.baudLength*1e-6;
         sr                     = Irange;
         er                     = sr+BitLength4PulseLength-1;
         if er > RangeNum
             continue
         end%if er > RangeNum
         sel_du                 = currentData.du{chIdx}(st:et,sr:er)';
         
         
         %%%%%% decoding
         decoded_du  = sel_du.*SelBinaryPhaseCoding2D';
         decoded_du  = conj(decoded_du);
                   %new line on 07-18-06
                   %following with suggestion from R. Todd Parris
         
         
         %%%%%% PSD
         TmpPSD    = fftshift(fft(decoded_du));
         TmpPSD    = TmpPSD.*conj(TmpPSD);
%          TmpPSD    = TmpPSD./sum(TmpPSD);
         
         %%%%%% power
         %%%%%%%%% frequency range for integration
         if currentData.channelType(chIdx) == 'I'
             FreqWidth4Integration = 0.005;%MHz
         else
             FreqWidth4Integration = 0.010;%MHz
         end%if mean(FreqArr)-RadarFreq < 1e-3
         
         switch radarParam.DCKNum
             case 440
                 OrigValue   = 26e6;              %Hz
             case 445
                 OrigValue   = 21e6;              %Hz
             case 450
                 OrigValue   = 16e6;              %Hz
         end%switch DCKNum
         FreqShift   = currentData.freq{chIdx} - OrigValue;          %Hz
         CenterFreq  =  FreqShift/1e6;
         
         ss_freq   = CenterFreq - FreqWidth4Integration;
         ee_freq   = CenterFreq + FreqWidth4Integration;

         FitFreq   = find( currentData.freqArr{chIdx} >= ss_freq & ...
                           currentData.freqArr{chIdx} <= ee_freq );
         
         
         %%% calculate power
         FreqRes   = currentData.freqArr{chIdx}(2) - ...
                        currentData.freqArr{chIdx}(1);
                    
         TmpPower  = sum(mean(TmpPSD(FitFreq, :)));

         %%% SNR
         TmpNoise  = sum(mean(TmpPSD));
         TmpSNR    = (TmpPower - TmpNoise)/TmpNoise;  

         if genParam.intTime ~= 1
             TmpPSD    = mean(TmpPSD,2);
         end%if Factor4IntTime ~= 1
         
         
         
         %%%%%% save data
         Power(Irange-FitRange(1)+1) = TmpPower;
         SNR(Irange-FitRange(1)+1)   = TmpSNR; 
         PSD(:,Irange-FitRange(1)+1) = TmpPSD;          
     end%for Irange
     
     
     
     %%% product from the spectral analysis
     if Iint == 1
         PowerArr   = Power;
         SNRArr     = SNR;
         PSDArr     = {PSD};
     else
         PowerArr   = [ PowerArr, Power ];
         SNRArr     = [ SNRArr, SNR ];
         PSDArr     = [ PSDArr, {PSD} ];
     end%if Iint == 1
      
 end%for Iint