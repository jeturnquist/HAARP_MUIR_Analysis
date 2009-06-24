%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_CalRangeOffsetValue_4uCLP_SpectrumAna4GIR
%          made by S. Oyama, GI UAF
%               arranged by Jason Turnquist
%
%          ver.1.0: Jul-06-2006: copy from
%                                 func_CalRangeOffsetValue_Decode4CLP
%
%       calculate the range offset value for uCLP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function func_CalRangeOffsetValue_4uCLP_SpectrumAna4GIR(du)
     
         
%------
% set global parameters
%------
 global_SpectrumAna4GIR;
 
 
%------
% set parameters
%------
 c                        = 2.99792458e8;
%  InitialOffsetDataNumber  = ceil((StartTime4Tx-StartTime4Rx)/BaudLength);
%  InitialOffsetDataNumber  = ceil(400/BaudLength);
%  SearchWidthDataNumber    = fix(200/BaudLength);

 InitialOffsetDataNumber  = ceil((StartTime4Tx-StartTime4Rx)*1e-6   ...
                                *(SamplingRate*1e3));
 SearchWidthDataNumber    = 2000;

%------
% calculate the power
%------
 dp   = du.*conj(du);
%  dp   = mean(dp);
 

%------
% search the offset value
%------

 MeanNoiseLevel     = mean(10*log10(dp(1:InitialOffsetDataNumber-2)));
 ss                 = InitialOffsetDataNumber;
 ee                 = InitialOffsetDataNumber + SearchWidthDataNumber;
 tmp_dp             = 10*log10(dp(ss:ee)) - MeanNoiseLevel;
 idx                = find(tmp_dp < 0);
 tmp_dp(idx)        = 0;
 DiffValue          = diff(tmp_dp);
 TmpThresh          = max(tmp_dp)*.6;
 FirstLargeValueNum = find( abs(DiffValue) > TmpThresh );

%  MeanNoiseLevel     = mean(10*log10(dp(1:InitialOffsetDataNumber-2)));
%  ss                 = InitialOffsetDataNumber;
%  ee                 = InitialOffsetDataNumber + SearchWidthDataNumber;
%  DiffValue          = 10*log10(dp(ss:ee)) - MeanNoiseLevel;
%  TmpThresh          = 30;
% %  TmpThresh          = 50;
%  FirstLargeValueNum = find( abs(DiffValue) > TmpThresh );
%  if DiffValue(end) > 0
%      FirstLargeValueNum = find( DiffValue > MeanNoiseLevel*TmpThresh );
%  else
%      TmpThresh          = 1/TmpThresh;
%      FirstLargeValueNum = find( dp(ss:ee) < MeanNoiseLevel*TmpThresh );
%  end%if DiffValue(end) > 0
%  
%  FirstLargeValueNum = FirstLargeValueNum(1)+ss-1;
 ss                 = FirstLargeValueNum(1)+ss-1;
  
%  TmpDiff            = 9999;
%  ss                 = FirstLargeValueNum;
%  ee                 = ss + 1;
%  while TmpDiff > 0
%      TmpDiff      = dp(ee)-dp(ss);
%      ss           = ee;
%      ee           = ss+1;
%  end%while TmpDiff > 0
 
 
%------
% calculate range offset value
%------
 RangeOffsetValue  = ss-0.5;
 PulseLength = 996;
%  RangeOffsetValue  = RangeOffsetValue*BaudLength * c/1e6/1e3/2;
  RangeOffsetValue  =                                            ...
     ( RangeOffsetValue+(PulseLength*1e-6*SamplingRate*1e3)/2 ) ...
     /(SamplingRate*1e3)* c/1e3/2;
 
%   RangeOffsetValue  =                                            ...
%      ( RangeOffsetValue)/(SamplingRate*1e3)*c/1e3/2;

%------
% check the result
%------
 FigureNumber = figure;
%   range = (1:length(dp))*c*BaudLength*1e-6/1e3/2;
 range = (1:length(dp))*c*1/(SamplingRate*1e3)/1e3/2;
 range = range - RangeOffsetValue;
 
 FitRange   = find( range >= LowerRange4Ana & range <= UpperRange4Ana );
 
 if ~mod(length(FitRange), 2)
     FitRange = [ FitRange, FitRange(end) + 1 ]; 
 end
 
 semilogx(dp,range)
 ylim([ -100 200 ])
 hold on
 plot(xlim,zeros(1,2),'r:');
 ylabel( 'Range (km)' )
 xlabel( 'Backscatter echo power (a.u.)')
 
 Answer  = input( 'Check the range calibration (y/n): ', 's' );
 if Answer == 'y'
     close(FigureNumber);
     return
 else
     pause
 end%if Answer == 'y'
 
close('all')