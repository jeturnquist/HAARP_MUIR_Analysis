function [ range, RangeOffsetValue ] = calRangeOffsetValue4CLP_GIRx(du, radarParam)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       calRangeOffsetValue4CLP_GIRx.m
%          made by S. Oyama, GI UAF
%
%        ( ver.1.0: Apr-04-2006 )
%        ( ver.1.1: Apr-20-2006: about TmpThresh )
%          ver.1.0: Jul-06-2006: copy from
%                                 func_CalRangeOffsetValue_Decode4CLP
%
%       calculate the range offset value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
%------
% set parameters
%------
 c                        = 2.99792458e8;
 InitialOffsetDataNumber  = ceil((...
     radarParam.startTime4Tx-radarParam.startTime4Rx)/radarParam.baudLength*1e-6);
 SearchWidthDataNumber    = 1000;% fix(200/BaudLength);


%------
% calculate the power
%------
 dp   = du.*conj(du);
%  dp   = mean(dp);
 

%------
% search the offset value
%------
 MeanNoiseLevel     = mean(10*log10(dp(1:InitialOffsetDataNumber-2)));
 tmp_dp             = 10*log10(dp) - MeanNoiseLevel;
 idx                = find(tmp_dp < 0);
 tmp_dp(idx)        = 0;
 ss                 = InitialOffsetDataNumber;
 ee                 = InitialOffsetDataNumber + SearchWidthDataNumber;
 DiffValue          = diff(tmp_dp(ss:ee));
 TmpThresh          = 15;
 FirstLargeValueNum = find( abs(DiffValue) > TmpThresh );

 ss                 = FirstLargeValueNum(1)+ss-1;
 
 
%------
% calculate range offset value
%------
 RangeOffsetValue  = ss-0.5;
 RangeOffsetValue  = RangeOffsetValue*radarParam.baudLength * c/1e3/2;

 
%------
% check the result
%------
 FigureNumber = figure;
 range = (1:length(dp))*c*radarParam.baudLength/1e3/2;
 range = range - RangeOffsetValue;
 semilogx(dp,range)
 ylim([ -100 600 ])
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
 