%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      func_DataFileName4GIR_SpectrumAna4GIR
%         made by Shin-ichiro Oyama, GI UAF
%
%         ver.1.0: 05-Jul-2006
%
%         # decide the data-file name (from the GI receiver)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function func_DataFileName4GIR_SpectrumAna4GIR(bit)
%------
% set global parameter
%------
 global_SpectrumAna4GIR;
 
 
%------
% file name
%------
 SelDateChar        = num2str(SelDate);
 SelDataNumChar     = num2str(SelDataNum4GIR);
 SelDataExtChar     = num2str(SelDataExtNum4GIR(bit));
 SelDataExtChar     = func_CheckCharLength( SelDataExtChar, 2, '0' );
 DataFileName4GIR   = [ DataDirectory4GIR, SelDateChar, filesep, ...
                        SelDataNumChar, '.', SelDataExtChar, '.dat' ];