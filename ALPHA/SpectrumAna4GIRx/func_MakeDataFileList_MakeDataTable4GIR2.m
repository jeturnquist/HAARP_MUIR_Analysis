%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      func_MakeDataFileList_MakeDataTable4GIR2.m
%          made by Shin-ichiro Oyama, GI UAF
%
%          ver.1.0: Jun-27-06
%          ver.2.0: May-19-09: platform independent 
%
%          # make data-file list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ DataFileListArr, OrderArr4FileName ] = ...
               func_MakeDataFileList_MakeDataTable4GIR;
%------
% set global parameters
%------
 global_MakeDataTable4GIR;
 
 
%------
% search data file
%------

%%
%% directory
%%
 DirectoryChar    = [ DataDirectory, filesep, SelDateChar ...
                    , filesep ];
 
 
%%
%% execute the command and return results
%%
 [ CommandResults ] = dir( [DirectoryChar, '*.dat'] );
 

%%
%% file name
%% 

%  FileNameChar  = [ DirectoryChar, {CommandResults.name} ];

%------
% make the data-file list
%------
%%% search the space position
%  FitSpace   = isspace( FileNameChar );
%  FitSpace   = find( FitSpace == 1 );
%  FileNum    = length(FitSpace);
 
FileNum = length({CommandResults.name});

%%% prepare new arrays
 DataFileListArr  = cell(1, FileNum);
 HeadFileNumArr   = zeros(1, FileNum);
 SecondFileNumArr = zeros(1, FileNum);
 
 
%%% make string for the data file
 for Ifile = 1:FileNum
%      %%% start and end position to grab the file name
%      if Ifile == 1
%          ss   = 1;
%      else
%          ss   = FitSpace(Ifile-1) + 1;
%      end%if Ifile == 1
%      ee       = FitSpace(Ifile) - 1;
%      
%      
%      %%% grab the data-file name
%      TmpFileName  = CommandResult(ss:ee);
     
     TmpFileName = CommandResults(Ifile).name;
     
     %%% keep the file name
     DataFileListArr{Ifile} = TmpFileName;
     
     
     %%% keep the file number
     DotPos                  = findstr(TmpFileName,'.');
     HeadNum                 = str2num( TmpFileName(1:DotPos(1)) );
     SecondNum               = str2num( TmpFileName(DotPos(1)+1:DotPos(2)) );
     HeadFileNumArr(Ifile)   = HeadNum;
     SecondFileNumArr(Ifile) = SecondNum;
 end%for Ifile
 
 
%------
% sort data-file name
%------
%%% prepare new array
 OrderArr4FileName     = 1:FileNum;
 

%%% unique head file number
 UniqueHeadFileNumArr  = unique(HeadFileNumArr);
 UniqueHeadFileNumWW   = length(UniqueHeadFileNumArr);
 
%%%
%%% iteration over UniqueHeadFileNumWW
%%%
 for Iunique = 1:UniqueHeadFileNumWW
     %%% select the file
     FitHeadFileNum   = find( HeadFileNumArr ==                ...
                              UniqueHeadFileNumArr(Iunique) );
                          
                              
     %%% sort Second number
     [ tmp, FitSort4SecondFileNum ] = ...
         sort( SecondFileNumArr(FitHeadFileNum) );
     
         
     %%% arrange the order array
     OrderArr4FileName(FitHeadFileNum) = ...
         OrderArr4FileName(FitHeadFileNum(FitSort4SecondFileNum));
 end%for Iunique