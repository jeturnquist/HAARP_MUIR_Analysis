%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_InputGeneralParam4CLP_SpectrumAna4GIR
%          made by S. Oyama, GI UAF
%
%          ver.1.0: Jul-27-2006
%
%          # manually input general parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function func_InputGeneralParam4CLP_SpectrumAna4GIR
     
         
%------
% set global parameters
%------
 global_SpectrumAna4GIR;

 
 
%------
% manually input general parameters
%------

%%% Factor4IntTIme
 TmpChar         = 'Integration-time factor #: ';
 Factor4IntTime  = input(TmpChar);
 
 
%%% LowerRange4Ana
 TmpChar         = 'Lower range (km) for calculation: ';
 LowerRange4Ana  = input(TmpChar);
 
 
%%% LowerRange4Ana
 TmpChar         = 'Upper range (km) for calculation: ';
 UpperRange4Ana  = input(TmpChar);
 
 
%%% HF frequency (MHz)
 TmpChar         = 'HF frequency (MHz):';
 fHF             = input(TmpChar);
 



