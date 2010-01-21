function [ SelDataNum4GIR ] = selectDataNum_GIRx(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      selectDataNum_GIRx.m
%         made by J. Turnquist, GI UAF
%
%         ver.1.0: 1-Jul-2009
%
%         # select A data number from the GI receiver
%            e.g. "33" of "33.01"
%
%       input: dataNum - array of experiment numbers (numeric)
%
%       output: SelectDatNum4GIR - user selected experiment number (numeric)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse input arguments.
%%
p = inputParser;

p.addRequired('dataNum', @isnumeric)


p.parse(varargin{:}); 

 

%% Display the data number
%%
%%% general parameter
 DataNum4GIRww   = length(p.Results.dataNum);
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
     TmpArray    = p.Results.dataNum(ss:ee);
     
     
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