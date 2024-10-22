function [ Noise4PSDArr, Noise4Power ] = ...
                  calNoise4uCLP_GIRx(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       calNoise4uCLP_GIRx
%          made by S. Oyama, GI UAF
%                   arranged by Jason Turnquist, GI UAF
%          ver.1.0: Aug-16-06
%                   copied from func_CalNoize4CLP_SpectrumAna4GIR.m
%
%          # calculate the noise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse input arguments.
%%
p = inputParser;

p.addRequired('du', @isnumeric)
p.addRequired('pulseLength', @isnumeric)
p.addRequired('samplingRate', @isnumeric)


p.parse(varargin{:});
 
 
%------
% set parameters
%------
 c = 2.99792458e8; % speed of light


%% range to be analyzed
 BitLength4PulseLength = ceil(p.Results.pulseLength*1e-6 ...
                                * p.Results.samplingRate);

 RangeNum       = length(p.Results.du(1,:));
 FitRange4Noise	= (RangeNum - BitLength4PulseLength + 1):RangeNum;
 
%  range      = (1:RangeNum)*c*1/(SamplingRate*1e3)/1e3/2;
%  range      = range - RangeOffsetValue;
%  FitRange   = find( range >= LowerRange4Ana & range <= UpperRange4Ana );
 
%% adjust the range selection
 sel_du         = p.Results.du(:,FitRange4Noise);
 Power          = sel_du.*conj(sel_du);
 MeanPower      = mean(Power);
 GrossMeanPower = mean(Power(:));
 %Threshold      = 10; 
 Threshold      = 10; 
 FitLarge       = find( MeanPower > GrossMeanPower*Threshold );
 DownShiftValue = FitLarge(1);
 FitRange4Noise	= FitRange4Noise - DownShiftValue;
%%
 

%------
% calculate the PSD
%------
%% select du data
 sel_du   = p.Results.du(:,FitRange4Noise)';
 sel_du  = conj(sel_du);
                    %new line on 07-18-06
                    %following with suggestion from R. Todd Parris
         
         
%% PSD
 TmpPSD        = fftshift(fft(sel_du));
 TmpPSD        = TmpPSD.*conj(TmpPSD);
 Noise4PSDArr  = mean(TmpPSD);
 
 
%% Power
  Noise4Power = sel_du.*conj(sel_du);
  Noise4Power = mean(Noise4Power);
  
%%