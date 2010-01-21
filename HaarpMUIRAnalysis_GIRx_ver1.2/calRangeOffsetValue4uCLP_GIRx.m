function [ range, RangeOffsetValue ] = calRangeOffsetValue4uCLP_GIRx(du, radarParam)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       calRangeOffsetValue4uCLP_GIRx.m
%          made by S. Oyama, GI UAF
%               arranged by Jason Turnquist
%
%          ver.1.0: Jul-06-2006: copy from
%                                 func_CalRangeOffsetValue_Decode4CLP
%
%       calculate the range offset value for uCLP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%------
% set parameters
%------
 c                        = 2.99792458e8;

 InitialOffsetDataNumber  = ceil((                                  ...
     radarParam.startTime4Tx-radarParam.startTime4Rx)*1e-6    ...
                                *(radarParam.samplingRate));
 SearchWidthDataNumber    = 2000;

%------
% calculate the power
%------
 dp   = du.*conj(du);

%------
% search the offset value
%------
 MeanNoiseLevel     = mean(10*log10(dp(1:InitialOffsetDataNumber-2)));
 ss                 = InitialOffsetDataNumber;
 ee                 = InitialOffsetDataNumber + SearchWidthDataNumber;
 DiffValue          = 10*log10(dp(ss:ee)) - MeanNoiseLevel;
 TmpThresh          = 44;
%  TmpThresh          = 50;
 FirstLargeValueNum = find( abs(DiffValue) > TmpThresh );

 ss                 = FirstLargeValueNum(1)+ss-1;
 
 
%------
% calculate range offset value
%------
 RangeOffsetValue  = ss-0.5;
 
  RangeOffsetValue  =                                            ...
     ( RangeOffsetValue)/(radarParam.samplingRate)*c/1e3/2;

%------
% check the result
%------
 FigureNumber = figure;
%   range = (1:length(dp))*c*BaudLength*1e-6/1e3/2;
 range = (1:length(dp))*c*1/(radarParam.samplingRate)/1e3/2;
 range = range - RangeOffsetValue;
  
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

