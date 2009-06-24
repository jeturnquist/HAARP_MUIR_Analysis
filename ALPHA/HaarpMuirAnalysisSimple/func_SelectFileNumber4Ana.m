function [ GenParam ] = func_SelectFileNumber4Ana(GenParam)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_SelectFileNumber4Ana.m
%          made by J. Tunrquist, GI UAF
%
%          ver.1.0: Jun-28-2008
%
%       Show file name and select data file for analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  while 1
      disp( 'Select data file number(s) ex. 1, 1:9, [1 2 6]' )
      disp( '=================' )
      TmpChar   = [ 'from '                                     ...
                num2str( GenParam.DataFileNumberArr(1) )        ... 
                ' to '                                          ...
                num2str( GenParam.DataFileNumberArr(end) ) ];
      disp( TmpChar );
      disp( '=================' )
      SelectedNumbers = input( 'Select #: ' );
      disp( '=================' )
      
      
      %------
      % search selected file number
      %------
      for ii = 1:1:length(SelectedNumbers)
         Fit(ii) = find( GenParam.DataFileNumberArr == SelectedNumbers(ii) );
      end
      
      if ~isempty(Fit)
          GenParam.SelectedFileNames   = GenParam.FileNameArr(Fit);
          GenParam.SelectedFileNumbers = GenParam.DataFileNumberArr(Fit);
          return
      else
          disp( 'No file. Select another.' )
          continue
      end%if ~isempty(Fit)
      
  end%while ( CheckFit == 0