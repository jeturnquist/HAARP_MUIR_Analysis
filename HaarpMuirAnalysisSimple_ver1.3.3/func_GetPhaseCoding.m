function [ RadarParam ] = func_GetPhaseCoding( GenParam         ...
                                             , RadarParam       ...
                                             , InputParam )
                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_GetPhaseCoding.m
%          made by J. Tunrquist, GI UAF
%
%          ver.1.0: Aug-8-2008
%
%      Get phase coding for Coded Long Pulse. Read data phase coding from 
%       .exp file. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%% open experimental setup file *.exp
%% 

DirectoryChar   = fullfile( InputParam.Directory4MUIRData               ...
                          , GenParam.SelectedDirChar , 'Setup');

CommandResults = dir([ DirectoryChar filesep '*.exp' ]);


FileNameChar = fullfile( DirectoryChar, CommandResults(1).name );

%------
% read the experimental setup file
%------
 fid     = fopen( FileNameChar, 'r' );
 TmpLine = [];
 while 1
    TmpChar = fgets(fid);
    if ~ischar(TmpChar), break, end
    TmpLine = strvcat(TmpLine, TmpChar);
 end
 fclose(fid);
 
 
 %%% get the sample time
 idx = strmatch(';',TmpLine);
 fit = [];
 for ii = 1:1:length(idx)
    fit(ii) = findstr(TmpLine(idx(ii),:),'=');
 end
 
 TmpCharArr =  TmpLine(idx,fit+1:end);
 
 u = strmatch('1', TmpCharArr);
 v = strmatch('0', TmpCharArr);
 
 u = union(u,v);
 tmpChar = strcat(TmpCharArr(u,:));
 TmpPhaseCoding = [];
 for ii  = 1:1:size(u,1)
    TmpPhaseCoding = [TmpPhaseCoding, tmpChar(ii,:)];
 end
 
 idx = find(~isspace(TmpPhaseCoding));
 TmpPhaseCoding = TmpPhaseCoding(idx);
 
 for ii = 1:1:length(idx)
     tmp = str2double(TmpPhaseCoding(ii));
     if tmp == 0, tmp = -1; end
     RadarParam.PhaseCoding(ii) = tmp; 
 end

 
