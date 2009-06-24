%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      func_SelDataNum4SISR_SpectrumAna4GIR
%         made by Shin-ichiro Oyama, GI UAF
%
%         ver.1.0: 05-Jul-2006
%
%         # find the SRI data-file corresponding GI-receiver data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function func_SelDataNum4SISR_SpectrumAna4GIR(DataNum4GIR, DataNum4SRIR)
%------
% set global parameter
%------
 global_SpectrumAna4GIR;
 
 
 
%------
% find the pulse coding type
%------
 FitPos              = find( DataNum4GIR == SelDataNum4GIR );
 SelDataNum4SRIR     = DataNum4SRIR(FitPos);