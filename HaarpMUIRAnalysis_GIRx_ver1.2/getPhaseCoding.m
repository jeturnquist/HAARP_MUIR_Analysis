function [ PhaseCoding ] = getPhaseCoding( FileNameChar )
                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       getPhaseCoding.m
%          made by J. Tunrquist, GI UAF
%
%          ver.1.0: Aug-8-2008
%
%      Get phase coding for Coded Long Pulse. Read data phase coding from 
%       .exp file. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Read HDF5 file
expfile = hdf5read( FileNameChar,...
                            '/Setup/Experimentfile'); 
 
                        
expstr = expfile.data;

%%% Generate character array from string
newlines = regexp(expstr, '\n');
idx = 1;
expCharArr = [];
for ii = 1:length(newlines)
    tmpLine = expstr(idx+1:newlines(ii)-1);
    idx = newlines(ii);
    expCharArr = strvcat(expCharArr, tmpLine);
end
 
 %%% get the sample time
 idx = strmatch(';',expCharArr);
 fit = [];
 for ii = 1:1:length(idx)
    fit(ii) = findstr(expCharArr(idx(ii),:),'=');
 end
 
 TmpCharArr =  expCharArr(idx,fit+1:end);
 
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
     PhaseCoding(ii) = tmp; 
 end

 
