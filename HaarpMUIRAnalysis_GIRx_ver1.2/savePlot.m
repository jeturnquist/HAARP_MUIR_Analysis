function savePlot( fh           ...
                 , currentData  ...
                 , genParam     ...
                 , radarParam   ...
                 , initParam   ...
                 , TimeChar )
                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       savePlot
%          made by J. Turnquist, GI UAF
%
%          ver.1.0: Aug-7-2008
%          ver.1.1: Aug-13-2008: Added ablility to save in differant
%                                   data formats
%
%       Save plots to selected directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


DirectoryChar = fullfile( initParam.figSaveDir, initParam.expDate );

%%%
%%% Check directory tree, if needed make directry tree 
%%%

CommandChar   = [ 'cd ' DirectoryChar ];

[ status, CommandResults ] = unix( CommandChar );

if status 
    [ status, CommandResults ] = mkdir( DirectoryChar ); 
end


FileNameChar = [initParam.expDate,'T',TimeChar,'.',initParam.figSaveExt];

SaveDirectoryChar = fullfile(DirectoryChar, FileNameChar);


set(gcf,'PaperPositionMode','auto')

switch initParam.figSaveExt
    case {'jpg'}
        print('-djpeg', '-r200',  SaveDirectoryChar);
    case {'tif'}
        print('-dtiff', SaveDirectoryChar);
    case {'pdf'}
        print('-dpdf', SaveDirectoryChar);  
    case {'epd'}
        print('-deps', SaveDirectoryChar);
    case {'fig'}
        saveas(fh, SaveDirectoryChar);
end