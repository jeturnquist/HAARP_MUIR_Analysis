%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_CalSpectraInfo_Decode4CLP_SpectrumAna4GIR
%          made by S. Oyama, GI UAF
%
%        ( ver.1.0: Mar-14-2006: copy from 
%                             func_CalSpectraInfo_PlotSNRofHaarpAmisr.m )
%        ( ver.1.0: Mar-21-2006: copy from func_CalSpectraInfo_Decode4BCP )
%          ver.1.0: Jul-06-06: copy from func_CalSpectraInfo_Decode4CLP.m
%          ver.1.1: Jul-18-06: change the element order
%          ver.1.2: Jul-19-06: remove TimeStampNumber
%          ver.1.3: Jul-21-06: arrange for Factor4IntTime = 1
%          ver.2.0: Jul-27-06: update to analyze multi-beam data
%                               (memo: old/***-3.m is the version for
%                               single beam data)
%
%          # calculate PSD and Power
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ PowerArr, PSDArr, RangeArr, MeanPSDArr, MeanPowerArr ] =                   ...
           func_CalSpectraInfo_Decode4CLP_SpectrumAna4GIR(  ...
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
 
 

%%
%% set parameters
%%

 
%%
%% code
%%
 BinaryPhaseCoding  = zeros(1,length(PhaseCoding));
 FitPlus            = findstr(PhaseCoding,'+');
 FitMinus           = findstr(PhaseCoding,'-');
 BinaryPhaseCoding(FitPlus)  = 1;
 BinaryPhaseCoding(FitMinus) = -1;
 
 BinaryPhaseCoding2D  = BinaryPhaseCoding;
 BinaryPhaseCoding2D  = repmat( BinaryPhaseCoding2D,length(du(:,1)),1);
 
 
 
%------
% calculate the parameters
%------
%%% set parameters
 TmpSize                 = size(du);
 TimeNum                 = TmpSize(1);
 RangeNum                = TmpSize(2);
 	
     
%%% range
%  range = (1:RangeNum)*c*(1/SamplingRate*1e3)*1e-6/1e3/2;
 range = (1:RangeNum)*c*BaudLength*1e-6/1e3/2;
 range = range - RangeOffsetValue;
     
 
%%% range to be analyzed
 FitRange   = find( range >= LowerRange4Ana & range <= UpperRange4Ana );

%%% estimate the iteration number following the integration time
 TimeNum4Integration = fix( TimeNum/Factor4IntTime );
     
%%% set arrays
%  Power    = zeros(length(FitRange),Factor4IntTime);
 Power    = zeros(1,RangeNum);
 PSD      = zeros(length(PhaseCoding),FitRange(end)-FitRange(1)+1);
     

   

 
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
     TmpChar    = [ 'Time:' num2str(Iint) '/'        ...
                    num2str(TimeNum4Integration) ];
     disp( TmpChar )
     
     
     %%%
     %%% iteration over the range
     %%%
     for Irange = FitRange(1):FitRange(end)
         %%%%%% select du
         BitLength4PulseLength  = PulseLength/BaudLength;
         sr                     = Irange;
         er                     = sr+BitLength4PulseLength-1;
         if er > RangeNum
             continue
         end%if er > RangeNum
         sel_du                 = du(st:et,sr:er)';
         
         
         %%%%%% decoding
         decoded_du  = sel_du.*SelBinaryPhaseCoding2D';
         decoded_du  = conj(decoded_du);
                   %new line on 07-18-06
                   %following with suggestion from R. Todd Parris
         
         
         %%%%%% PSD
         TmpPSD    = fftshift(fft(decoded_du));
         TmpPSD    = TmpPSD.*conj(TmpPSD);

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
%          TmpPower  = sum(TmpPSD(FitFreq, :));
         TmpPower  = sum(TmpPSD(:, :));
         TmpPower  = TmpPower * FreqRes * 1e6;
         
         if Factor4IntTime ~= 1
             TmpPSD    = mean(TmpPSD');
         end%if Factor4IntTime ~= 1
         
         %%%%%% save data
         Power(Irange) = sum(TmpPower);
         PSD(:,Irange-FitRange(1)+1) = TmpPSD;    
     end%for Irange
     
     
     
     %%% arrange power data --> dB
%      RangeWidth4MaxPower  = [ 180 400 ];
%      FitRange4PowerCal    = find( range >= RangeWidth4MaxPower(1)  ...
%                           & range <= RangeWidth4MaxPower(2) );
%      Thresh4Power  = 0.01;
%      MaxPower      = max(Power(FitRange4PowerCal));
%      FitLowPower   = find(Power <= MaxPower*Thresh4Power);
%      FitHighPower  = find(Power > MaxPower*Thresh4Power);
%      if length(FitLowPower) ~= 0
%          Power(FitLowPower) = NaN;
%      end%if length(FitLowPower) ~= 0
%      Power(FitHighPower,Iint) = 10*log10(Power(FitHighPower,Iint));
     
    FitPlus = find(Power > 0);
    Power(FitPlus) = 10*log10(Power(FitPlus));

     %%% product from the spectral analysis
     if Iint == 1
         PowerArr   = Power;
         PSDArr     = {PSD};
         RangeArr   = range;
         MeanPSDArr = mean(PSD,2);
         MeanPowerArr = mean(Power,2);
     else
         PowerArr   = [ PowerArr; Power ];
         PSDArr     = [ PSDArr, {PSD} ];
         MeanPSDArr = [ MeanPSDArr, mean(PSD,2) ];
         MeanPowerArr = [ MeanPowerArr, mean(Power,2) ];
     end%if Iint == 1
      
 end%for Iint