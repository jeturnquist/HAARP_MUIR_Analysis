%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      func_SelDataExtNum4GIR_SpectrumAna4GIR
%         made by Shin-ichiro Oyama, GI UAF
%
%         ver.1.0: 05-Jul-2006
%
%         # select A data extention number from the GI receiver
%            e.g. "01" of "33.01"
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function func_SelDataExtNum4GIR_SpectrumAna4GIR
%------
% set global parameter
%------
 global_SpectrumAna4GIR;
 
 
 
%------
% get inforation on the data-file name
%------
%%% set the file name (DataTable_[YYYYMMDD].txt)
 SelDateChar     = num2str(SelDate);
 FileNameChar    = [ DataDirectory4GIR, SelDateChar, filesep, ...
                     'DataTable_', SelDateChar, '.txt' ];
                 
                     
%%% open the file
 fid    = fopen(FileNameChar, 'r' );
 
 
%%% prepare new arrays
 DataNumArr   = [];
 DataExtArr   = [];

 
%%% read the file
%%%%%% set parameter
 Count4Read   = 1;
 
 
%%%%%% read the first line
 TmpChar      = fgetl(fid);
 
 
%%%%%% while
 while TmpChar ~= -1
     if Count4Read == 1
         TmpChar    = fgetl(fid);
         Count4Read = Count4Read + 1;
         continue
     else
         %%%%%% search positions of the dot
         FitDotPos   = findstr(TmpChar, '.');
         
         
         %%%%%% pick-up data number & data-extention number
         DataNum     = str2num(TmpChar(1:FitDotPos(1)-1));
         ExtNum      = str2num(TmpChar(FitDotPos(1)+1:FitDotPos(2)-1));
         
         
         %%% keep them
         DataNumArr  = [ DataNumArr, DataNum ];
         DataExtArr  = [ DataExtArr, ExtNum ];
     end%if Count4Read == 1
     
     
     %%%%%% read the next line
     TmpChar     = fgetl(fid);
     
     
     %%%%%% increment Count4Read
     Count4Read  = Count4Read + 1;
 end%while TmpChar ~= -1
 
 
 
%------
% select An extention number
%------
%%% search the data number following with SelDataNum4GIR
 FitDataNum   = find( DataNumArr == SelDataNum4GIR );
 
 CountDataNum4GIR = length(FitDataNum);
 
%%% pick-up the first extension number
 FirstExtNum     = min(DataExtArr(FitDataNum));
 FirstExtNumChar = num2str(FirstExtNum);
 
%%% pick-up the last extention-number
 LastExtNum     = max(DataExtArr(FitDataNum));
 LastExtNumChar = num2str(LastExtNum);
 
 
%%% select an extention number
 TmpChar           = [ 'Select data-extention # (from ' FirstExtNumChar ...
                       ' to ' LastExtNumChar '): ' ];
 SelDataExtNum4GIR = input( TmpChar );
%  SelDataExtNum4GIR = b;
 
%------
% close the file
%------
 fclose(fid);