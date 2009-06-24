function [GenParam] = func_SelectAnalysisParameters2(GenParam, RadarParam)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_SelectAnalysisParameters2.m
%          made by J. Tunrquist, GI UAF
%
%          ver.1.0: Jun-28-2008
%
%       Select paramters for analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
disp(['Select other integration time:']);

%% Integer multiple of base sample time (normally 10 ms)
%% Select region of interest (ROI) to analyze
disp('Integration time: (ex. 10 --> 100 ms)')
InputChar = input('Select: ', 's');
GenParam.Factor4IntTime = str2num(InputChar); 
disp(' ');
        
disp('Enter height range (in km)')
GenParam.LowerHeight = input('Lower Altitude (km): ');
GenParam.UpperHeight = input('Upper Altitude (km): ');
disp(' ');
        






        