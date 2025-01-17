function [ selFileNumbers selFileNames ] = selectFileNum4Ana(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       selectFileNum4Ana.m
%          made by J. Tunrquist, GI UAF
%
%          ver.1.0: Jun-28-2008
%          ver.2.0: 1-Jul-2009
%
%       Show file name and select data file for analysis
%
%   input: array of file numbers (numeric)
%          array of file names (string)
%
%   output: user selected file numbers (numeric)
%           user selected file names (string)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse input arguments.
%%
p = inputParser;

p.addRequired('fileNum', @isnumeric)
p.addRequired('fileName', @ischar )

p.parse(varargin{:}); 


%%

global RUNALL

RUNALL = 0; %% temporay assignment
  while 1
      if RUNALL
          SelectedNumbers =  p.Results.fileNum(:);
      else
          disp( 'Select data file number(s) ex. 1, 1:9, [1 2 6]' )
          disp( '=================' )
          TmpChar   = [ 'from '                                     ...
                    num2str( p.Results.fileNum(1) )        ... 
                    ' to '                                          ...
                    num2str( p.Results.fileNum(end) ) ];
          disp( TmpChar );
          disp( '=================' )
          SelectedNumbers = input( 'Select #: ' );
          disp( '=================' )
      end
      
      %------
      % search selected file number
      %------
      kk = 1;
      for ii = 1:1:length(SelectedNumbers)
         idx = find( p.Results.fileNum(:) == SelectedNumbers(ii) );
         if idx
             Fit(kk) = idx;
             kk = kk + 1;
         end
      end
      
      if ~isempty(Fit)
          selFileNames   = p.Results.fileName(Fit,:);
          selFileNumbers = p.Results.fileNum(Fit);
          return
      else
          disp( 'No file. Select another.' )
          continue
      end%if ~isempty(Fit)
      
  end%while ( CheckFit == 0