function func_SavePlot( fh           ...
                      , CurrentData  ...
                      , GenParam     ...
                      , RadarParam   ...
                      , InputParam   ...
                      , TimeChar )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_SavePlot
%          made by J. Turnquist, GI UAF
%
%          ver.1.0: Aug-7-2008
%          ver.1.1: Aug-13-2008: Added ablility to save in differant
%                                   data formats
%
%       Save plots to selected directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


DirectoryChar = fullfile( InputParam.SaveDirectory ...
                        , GenParam.SelectedDirChar);

%%%
%%% Check directory tree, if needed make directry tree 
%%%

CommandChar   = [ 'cd ' DirectoryChar ];

[ status, CommandResults ] = unix( CommandChar );

if status 
    [ status, CommandResults ] = mkdir( DirectoryChar ); 
end

TmpChar = datestr(CurrentData.MatlabTime(1,1),30);
FileNameChar = [TmpChar,'.',TimeChar,'.',InputParam.SaveFigExt];

SaveDirectoryChar = fullfile(DirectoryChar, FileNameChar);

switch InputParam.SaveFigExt
    case {'jpg'}
        print('-djpeg', SaveDirectoryChar);
    case {'tif'}
        print('-dtiff', SaveDirectoryChar);
    case {'pdf'}
        print('-dpdf', SaveDirectoryChar);  
    case {'epd'}
        print('-deps', SaveDirectoryChar);
    case {'fig'}
        saveas(fh, SaveDirectoryChar);
end