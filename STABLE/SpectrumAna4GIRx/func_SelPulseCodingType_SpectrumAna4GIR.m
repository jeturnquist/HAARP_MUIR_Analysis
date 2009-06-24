%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      func_SelPulseCodingType_SpectrumAna4GIR
%         made by Shin-ichiro Oyama, GI UAF
%
%         ver.1.0: 05-Jul-2006
%
%         # find the pulse coding type
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function func_SelPulseCodingType_SpectrumAna4GIR(        ...
             DataNum4GIR, PulseCodingType )
%------
% set global parameter
%------
 global_SpectrumAna4GIR;
 
 
%------
% find the pulse coding type
%------
 FitPos              = find( DataNum4GIR == SelDataNum4GIR );
 SelPulseCodingType  = PulseCodingType(FitPos);