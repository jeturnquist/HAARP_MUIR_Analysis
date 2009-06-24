%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      func_SelDataNum4GIR_SpectrumAna4GIR
%         made by Shin-ichiro Oyama, GI UAF
%
%         ver.1.0: 05-Jul-2006
%
%         # select A data number from the GI receiver
%            e.g. "33" of "33.01"
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function func_SelDataNum4GIR_SpectrumAna4GIR(DataNum4GIR)
%------
% set global parameter
%------
 global_SpectrumAna4GIR;
 
 
%------
% display the data number
%------
%%% general parameter
 DataNum4GIRww   = length(DataNum4GIR);
 Num4EachLine    = 5;
 LineNum         = ceil(DataNum4GIRww/Num4EachLine);
 
 
%%%
%%% iteration over LineNum
%%%
 for Iline = 1:LineNum
     %%% display the border
     if Iline == 1
         TmpChar   = '=======================================';
         disp(TmpChar);
         TmpChar   = '== Data number from the GI receiver  ==';
         disp(TmpChar);
         TmpChar   = '=======================================';
         disp(TmpChar);
     end%if Iline == 1
     
     
     %%% pick-up the number to be listed at a line
     ss     = 1 + Num4EachLine*(Iline-1);
     ee     = ss + Num4EachLine - 1;
     if ee > DataNum4GIRww
         ee   = DataNum4GIRww;
     end%if ee > DataNum4GIRww
     TmpArray    = DataNum4GIR(ss:ee);
     
     
     %%% display
     disp(TmpArray)
     
     
     %%% display the border
     if Iline == LineNum
         TmpChar   = '=======================================';
         disp(TmpChar);
     end%if Iline == LineNum
 end%for Iline
 
 
%------
% select the number
%------
 SelDataNum4GIR   = input( 'Select #: ' );