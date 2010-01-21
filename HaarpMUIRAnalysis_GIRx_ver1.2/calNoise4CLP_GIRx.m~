function [ Noise4PSDArr, Noise4Power ] = ...
                  calNoise4CLP_GIRx(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       calNoise4CLP_GIRx
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

p.addRequired('psd', @isnumeric)
p.addRequired('power', @isnumeric)
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
 
 
%% adjust the range selection
 sel_psd        = p.Results.psd(:,FitRange4Noise)';
 
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
                 
%% PSD
 TmpPSD        = fftshift(fft(decoded_du));
 TmpPSD        = TmpPSD.*conj(TmpPSD);
 Noise4PSDArr  = mean(TmpPSD);
 
 
%% Power
  Noise4Power = sel_du.*conj(sel_du);
  Noise4Power = mean(Noise4Power);
  
%%