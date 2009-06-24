%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      func_MakeDataTable_MakeDataTable4GIR.m
%          made by Shin-ichiro Oyama, GI UAF
%
%          ver.1.0: Jun-27-06
%
%          # make data table
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function func_MakeDataTable_MakeDataTable4GIR(             ...
             DataFileListArr, OrderArr4FileName,           ...
             YearArr, MonthArr, DayArr,                    ...
             HourArr, MinuteArr, SecondArr )
%------
% set global parameters
%------
 global_MakeDataTable4GIR;
 
 
%------
% prepare the file of the data table
%------
%%% file name
 FileName4DataTable  = [ 'DataTable_', SelDateChar, '.txt' ];
 FileName4DataTable  = [ DataDirectory, '\', SelDateChar, '\', ...
                         FileName4DataTable ];
 
 
%%% open the file
 fid   = fopen( FileName4DataTable, 'w' );
 
 
%------
% print information in the file
%------
%%% header
 TmpChar1   = 'file name';
 TmpChar2   = 'date';
 TmpChar3   = 'HH';
 TmpChar4   = 'MM';
 TmpChar5   = 'SS (UT)';
 fprintf( fid, '%s\t%s\t\t%s\t%s\t%s\t\n',                      ...
          TmpChar1, TmpChar2, TmpChar3, TmpChar4, TmpChar5 );
      
          
%%% each data
 FileNum    = length(DataFileListArr);
 for Ifile = 1:FileNum
     %%% select element number
     SelEleNum     = OrderArr4FileName(Ifile);
     
     
     %%% select data
     SelFileName   = DataFileListArr{SelEleNum};
     SelYear       = YearArr(SelEleNum);
     SelMonth      = MonthArr(SelEleNum);
     SelDay        = DayArr(SelEleNum);
     SelHour       = HourArr(SelEleNum);
     SelMinute     = MinuteArr(SelEleNum);
     SelSecond     = SecondArr(SelEleNum);
     
     
     %%% skip if 9999
     if SelYear == 9999
         continue
     end%if SelYear == 9999
     
     
     %%% prepare character
     SelFileNameChar  = char(SelFileName);
     SelYearChar      = num2str(SelYear);
     SelMonthChar     = num2str(SelMonth);
     SelMonthChar     = func_CheckCharLength( SelMonthChar,2,'0' );
     SelDayChar       = num2str(SelDay);
     SelDayChar       = func_CheckCharLength( SelDayChar,2,'0' );
     SelDateChar      = [ SelYearChar, SelMonthChar, SelDayChar ];
     SelHourChar      = num2str(SelHour);
     SelMinuteChar    = num2str(SelMinute);
     SelSecondChar    = num2str(SelSecond);
     
     
     %%% print
     fprintf( fid, '%s\t%s\t%s\t%s\t%s\t\n',                 ...
              SelFileNameChar, SelDateChar,                  ...
              SelHourChar, SelMinuteChar, SelSecondChar );
 end%for Ifile
 
 
 
%------
% close file
%------
 fclose(fid);