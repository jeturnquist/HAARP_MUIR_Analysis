function [fileNumArr, fileNameArr] = getFileList(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       getFileList.m
%           made by J. Turnquist, GI UAF
%              
%       Parse contents of a folder and return a list of file names, 
%         experiment numbers and data file numbers for file type of given
%         extention.
%
%       ver.1.0: 30-Jul-2009
%
%   input:  dir - Directory  [string]
%           ext - File extention (ex '.txt' or '.dat') [string]
%           tok - String delimiter token (ex '.')  [string]
%
%   Output: results - Cell array containg parts of file name delimited by token
%                       'tok' not including file extention 'ext'.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Parse input arguments.
%%
p = inputParser;

p.addOptional('dir', pwd, @ischar)
p.addOptional('ext', '*.*', @ischar)
p.addOptional('tok', '.', @ischar)

p.parse(varargin{:});

%% Open directory
%%
fileChar = fullfile(p.Results.dir, p.Results.ext);

if isdir(p.Results.dir)
    cmdResults = dir(fileChar);
else
    error(['## Error: Could not find directory: ', p.Results.dir])
    return
end

%% Parse directory contents by given string token
%%
fileNum     = length( cmdResults );
fileNameArr = cell(fileNum,1);
fileNumArr = cell(fileNum,1);

for Ifile = 1:fileNum
    tmp = textscan(cmdResults(Ifile).name, '%s', 'Delimiter'    ...
                  , p.Results.tok);
    fileNumArr{Ifile}   = str2double( tmp{:}{2} );
    fileNameArr{Ifile} = cmdResults(Ifile).name;
end%for Ifile



%% End getFileList()