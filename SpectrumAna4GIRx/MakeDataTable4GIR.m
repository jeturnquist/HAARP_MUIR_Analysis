%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      MakeDataTable4GIR.m
%          made by Shin-ichiro Oyama, GI UAF
%
%          ver.1.0: Jun-27-06
%
%          # make the data table that shows start-time (UT) of data
%            collecting for each data file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------
% set global parameters
%------
 global_MakeDataTable4GIR;
 
 
%------
% set general parameters
%------
%  DataDirectory  = 'J:\GIReceiver\';
%  DataDirectory  = 'C:\soyama\data\GIRtemp\';
% DataDirectory =  'I:\2008_Oct_HAARP_campaign\GIRx\oyama_20081101_0145UT\';
DataDirectory =  'C:\DOCUME~1\jet\MYDOCU~1\Data\GIRx\Oct2008\watkins_2_20081026_100-104_200-204_300-301_GIRx\';
%  DataDirectory  = 'I:\PARS2008\data\GIRx\';
 SelDateChar    = '200801026';
 
 
%------
% make data-file list
%------
 [ DataFileListArr, OrderArr4FileName ] = ...
             func_MakeDataFileList_MakeDataTable4GIR;
 FileNum     = length(DataFileListArr);
 
 
%------
% prepare new arrays to keep data
%------
 YearArr   = zeros(1,FileNum) - 9999;
 MonthArr  = zeros(1,FileNum) - 9999;
 DayArr    = zeros(1,FileNum) - 9999;
 HourArr   = zeros(1,FileNum) - 9999;
 MinuteArr = zeros(1,FileNum) - 9999;
 SecondArr = zeros(1,FileNum) - 9999;


%%%
%%% iteration over FileNum
%%%
 for Ifile = 1:FileNum
     %------
     % read header of data
     %------
     %%% prepare the file name
     SelFileName   = [ DataDirectory, SelDateChar, '\', ...
                       DataFileListArr{Ifile} ];
                   
                       
     %%% read the header
     [ Year, Month, Day, Hour, Minute, Second, Nsecond ] =    ...
         func_ReadHeaderGIR_MakeDataTable4GIR( SelFileName );
     
         
     %%% keep data
     YearArr(Ifile)   = Year;
     MonthArr(Ifile)  = Month;
     DayArr(Ifile)    = Day;
     HourArr(Ifile)   = Hour;
     MinuteArr(Ifile) = Minute;
     SecondArr(Ifile) = Second;
 end%for Ifile
 
 
%------
% make data table
%------
 func_MakeDataTable_MakeDataTable4GIR(             ...
     DataFileListArr, OrderArr4FileName,           ...
     YearArr, MonthArr, DayArr,                    ...
     HourArr, MinuteArr, SecondArr );