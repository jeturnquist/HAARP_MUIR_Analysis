%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_CalNoize4CLP_SpectrumAna4GIR
%          made by S. Oyama, GI UAF
%
%          ver.1.0: Jul-19-06
%          ver.1.1: Jul-21-06: revise the calculation of noise for power
%
%          # calculate the noise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ Noise4PSDArr, Noise4Power ] = ...
                  func_CalNoize4CLP_SpectrumAna4GIR(du)
     
         
%------
% set global parameters
%------
 global_SpectrumAna4GIR;
 
 
%------
% set parameters
%------
%%% code
 BinaryPhaseCoding  = zeros(1,length(PhaseCoding));
 FitPlus            = findstr(PhaseCoding,'+');
 FitMinus           = findstr(PhaseCoding,'-');
 BinaryPhaseCoding(FitPlus)  = 1;
 BinaryPhaseCoding(FitMinus) = -1;
 
 BinaryPhaseCoding2D  = BinaryPhaseCoding;
 BinaryPhaseCoding2D  = repmat( BinaryPhaseCoding2D,length(du(:,1)),1);
 
 
%%% range selection
 RangeNum               = length(du(1,:));
 BitLength4PulseLength  = PulseLength/BaudLength;
 FitRange               = RangeNum-BitLength4PulseLength+1:RangeNum;

 
%%% adjust the range selection
 sel_du         = du(:,FitRange);
 Power          = sel_du.*conj(sel_du);
 MeanPower      = mean(Power);
 GrossMeanPower = mean(Power(:));
 Threshold      = 10;
 FitLarge       = find( MeanPower > GrossMeanPower*Threshold );
 DownShiftValue = FitLarge(1);
 FitRange       = FitRange - DownShiftValue;
 
 
%------
% calculate the PSD
%------
%%% select du data
 sel_du   = du(:,FitRange)';
 

%%% decoding
 decoded_du  = sel_du.*BinaryPhaseCoding2D';
 decoded_du  = conj(decoded_du);
                    %new line on 07-18-06
                    %following with suggestion from R. Todd Parris
         
         
%%% PSD
 TmpPSD        = fftshift(fft(decoded_du));
 TmpPSD        = TmpPSD.*conj(TmpPSD);
 Noise4PSDArr  = mean(TmpPSD');
 
 
 %%% Power
  Noise4Power = sel_du.*conj(sel_du);
  Noise4Power = mean(Noise4Power(:));