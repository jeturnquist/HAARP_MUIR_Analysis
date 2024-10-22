function [ GenParam, status ] = func_MakeFileNameArr(InputParam, GenParam)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_MakeFileNameArr.m
%          made by J. Turnquist, GI UAF
%
%          ver.1.0: Jun-27-2008: Copied from 
%               func_MakeFileName_TestReadHaarpAmisr.m
%
%       List-up the file name to be read
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


status = 1;

DirectoryChar   = fullfile( InputParam.Directory4MUIRData              ...
                          , GenParam.SelectedDirChar);
                      
CommandResults   =  dir([DirectoryChar filesep '*.h5']);

if ~length(CommandResults)
    disp('-----------------------------------------------------------------------')
    disp('## Error: Could not find directory: ##')
    disp('-----------------------------------------------------------------------')
    disp(['     ', DirectoryChar])
    disp(' ')
    disp('## Please check the directory path, selected date and experiment number ##');
    disp('-----------------------------------------------------------------------')
    disp(['NOTE:  The directory path for the MUIR data cannot contain spaces when']);
    disp(['     running HaarpMuirAnalysis.m on a windows machince. MATLAB uses the']);
    disp(['     local command line (i.e DOS-prompt in windows). DOS-prompt does not']);
    disp(['     support spaces in directory names and it is not possible to escape']);
    disp(['     the spaces (if I am wrong please let me know).']);
    disp(['       Thus, either place the data in a directory path containing no']);
    disp(['     spaces or use the windows short name convention.']);
    disp(['     ''C:\Documents and Settings'' --> ''C:\DOCUME~1'' (short name) ']);
    disp([' ']);
    disp(['       On a *nix system it is possible to escape spaces using a']);
    disp(['     backslash (\).']);
    disp(['     ''/PARS summer school 2007'' --> ''/PARS\ summer\ school\ 2007'' ']  );
    status = -1; 
    return; 
end
%
% count the number of files
%
 GenParam.FileNameNum      = size( CommandResults );
 
%
% pick-up file name
%
GenParam.FileNameArr        = zeros(GenParam.FileNameNum(1),1);
GenParam.DataFileNumberArr  = zeros(GenParam.FileNameNum(1),1);
 
for Ifile = 1:GenParam.FileNameNum
    SelectedPartChar    = CommandResults(Ifile).name;
    
    fitdot = find(SelectedPartChar == '.');
    ii = 1;
    
    DataFileNumber   = SelectedPartChar( fitdot(end-ii)-5:fitdot(end-ii)-1 );
    DataFileNumber   = str2num( DataFileNumber );

    if Ifile == 1
        GenParam.FileNameArr        = {SelectedPartChar};
        GenParam.DataFileNumberArr  = DataFileNumber;
    else
        GenParam.FileNameArr        = [ GenParam.FileNameArr            ...
                                      , { SelectedPartChar } ];
        GenParam.DataFileNumberArr  = [ GenParam.DataFileNumberArr      ...
                                      ; DataFileNumber];
    end
end%for Ifile

