%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_PlotPSDvsTime4uCLP_SpectrumAna4GIR
%          made by Jason Turnquist, GI UAF
%
%          ver.1.0: Aug-23-2007
%
%          # make image plot of PSD vs Time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  func_PlotPSDvsTime4uCLP_SpectrumAna4GIR(          ...
            PSDvsTimeArr1, PSDvsTimeArr2, PSDvsTimeArr3     ...
            , FreqArr1, FreqArr2, FreqArr3                  ...
            , hours, minutes, seconds, nseconds, Iint) 
        
  
        

global_SpectrumAna4GIR

c           = 2.99792458e8;% speed of light
fradar      = 446;       

% figure( 'Position', [ 100 100 600 800 ] )
figure( 'Visible', 'off' );
freqwd = 100;
%% Convert cell arryas to matrices
%%
LengthNum   = length(PSDvsTimeArr1);
SizeNum     = size(PSDvsTimeArr1{1});

%%% PSD
PSDArr1 = cell2mat(PSDvsTimeArr1);
PSDArr2 = cell2mat(PSDvsTimeArr2);
PSDArr3 = cell2mat(PSDvsTimeArr3);

%%% Seconds
TmpSeconds1     = seconds';
TmpNseconds1    = nseconds';


%% PSD in decibels
%%
PSDvsTimeinDBArr1 = 10*log10(PSDArr1);
PSDvsTimeinDBArr2 = 10*log10(PSDArr2);
PSDvsTimeinDBArr3 = 10*log10(PSDArr3);


%% Time
%%
TmpChar	= num2str(hours(1));
HH    	= func_CheckCharLength(TmpChar , 2, '0');

TmpChar	= num2str(minutes(1));
MM      = func_CheckCharLength(TmpChar, 2, '0');

TmpChar	= num2str(seconds(1));
SS      = func_CheckCharLength(TmpChar , 2, '0');

TmpChar	= num2str(nseconds(1));
NN      = func_CheckCharLength(TmpChar, 2, '0');


TimeChar	= [ HH, ':', MM, ':',SS ];
idx = find(isnan(TmpSeconds1));
if isempty(idx)
    idx  = length(TmpSeconds1)+1;
end

NewTimeArrInSecond     = TmpSeconds1(1:idx-1) + TmpNseconds1(1:idx-1)/1e9 ...
                        - TmpSeconds1(1);
 FitNegative            = find( NewTimeArrInSecond < 0 );
 if length( FitNegative ) ~= 0
     NewTimeArrInSecond( FitNegative ) = ...
         NewTimeArrInSecond( FitNegative ) + 60;
 end%if length( FitNegative ) ~= 0

TimeRangeValue  = [ NewTimeArrInSecond(1), NewTimeArrInSecond( end ) ];
 
%% Plot
%%
DateChar        = num2str(SelDate); 

IntegrationChar = IPP * Factor4IntTime / 1000;
                 IntegrationChar = [ num2str(IntegrationChar) ' ms' ];
                 
% TitleChar = {[ 'HAARP MUIR GIR Data on ' DateChar ]; ...
%              ['']; ['']; ['']; [''] };
%                  
% suptitle(TitleChar);

caxis = [ 70 120 ];
% caxis = [ 50 95 ];
% caxis = [ 50 70 ];

l = length(PSDvsTimeinDBArr1);
Freqlength = length(FreqArr1);
FreqWidth = ceil(Freqlength/2)-freqwd:ceil(Freqlength/2) + freqwd;
%%% Channel 1: Ion Line
subplot(3,1,1)
Freq1 = FreqArr1(FreqWidth) - fradar;
Freq1 = fliplr(Freq1);
imagen(TimeRangeValue, Freq1, PSDvsTimeinDBArr1(l/2-freqwd:l/2+freqwd,:),caxis);
title({[ '\bf HAARP MUIR GIRx Data on ' DateChar '\fontsize{10}\bf           PSD(db): \fontsize{8}\rm integration time ' IntegrationChar  ]; ...
       [ '\fontsize{10}\bf Channel 1: Ion Line' ]});
ylabel([ '\fontsize{10}\bfFrequncey Offset (MHz)' ])
xlabel({[ '\fontsize{10}\bfTime \fontsize{8}\rm(seconds from ', ...
        TimeChar, ' )' ]; ['']})
colorbar


%%% Channel 2: Upshifted Plasma Line
subplot(3,1,2)
Freq2 = FreqArr2(FreqWidth) - fradar;
Freq2 = fliplr(Freq2);
imagen(TimeRangeValue, Freq2, PSDvsTimeinDBArr2(l/2-freqwd:l/2+freqwd,:),caxis);
title([ '\fontsize{10}\bf Channel 2: Upshifted Plasma Line' ])
ylabel([ '\fontsize{10}\bfFrequncey Offset (MHz)' ])
xlabel({[ '\fontsize{10}\bfTime \fontsize{8}\rm(seconds from ', ...
        TimeChar, ' )' ]; ['']})
colorbar


%%% Channel 3: Downshifted Plasma Line
subplot(3,1,3)
Freq3 = FreqArr3(FreqWidth) - fradar;
Freq3 = fliplr(Freq3);
imagen(TimeRangeValue, Freq3, PSDvsTimeinDBArr3(l/2-freqwd:l/2+freqwd,:),caxis);
title([ '\fontsize{10}\bf Channel 3: Downshifted Plasma Line' ])
ylabel([ '\fontsize{10}\bfFrequncey Offset (MHz)' ])
xlabel({[ '\fontsize{10}\bfTime \fontsize{8}\rm(seconds from ', ...
        TimeChar, ' )' ]; ['']})
colorbar



%% save as jpg
%%

if ~Iint
    DataNumChar             = num2str(SelDataNum4GIR);
    DataExtNumCharBegin     = num2str(SelDataExtNum4GIR(1));
    DataExtNumCharEnd       = num2str(SelDataExtNum4GIR(end));

    DataChar        = [ DataNumChar, '.', DataExtNumCharBegin, '-', ...
                        DataExtNumCharEnd ];
else
    DataNumChar             = num2str(SelDataNum4GIR);
    DataExtNumChar          = num2str(SelDataExtNum4GIR(Iint));

    DataChar        = [ DataNumChar, '.', DataExtNumChar];
end

%%if another directory was chosen for jpeg file
if JpgSaveDirectory 
     FolderName     = [ filesep, 'GIR_PSDvsTime', filesep, DateChar ];
     DirectoryChar  = [ JpgSaveDirectory, FolderName ];

    % ------
    % list-up data file
    % ------
    % 
    % unix command
    %
    if isunix
        CommandChar   = [ 'ls -1 ' DirectoryChar '*.Dt0' ];
    elseif ispc
        CommandChar    = [ 'md ' DirectoryChar ];
    end

    %
    % execute the command and return results
    %
     [ tmp, CommandResults ] = unix( CommandChar );  

end %%if SelectedDirectory

FileNameChar   = ...
    [ 'GIR_PSDvsTime_' DateChar, '.', DataChar, '.', HH, MM, SS, '.', NN, ];
if BeamNum == 1
    FileNameChar = [ FileNameChar, '.jpg' ];
else
    FileNameChar = [ FileNameChar, '-', num2str(Ibeam), '.jpg' ];
end%if BeamNum == 1

FileNameChar = [ DirectoryChar, filesep, FileNameChar ];
print( '-djpeg', FileNameChar );

close('all');