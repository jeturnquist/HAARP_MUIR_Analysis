%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_PlotSNRvsTime4uCLP_SpectrumAna4GIR
%          made by Jason Turnquist, GI UAF
%
%          ver.1.0: Aug-23-2007
%
%          # make image plot of PSD vs Time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  func_PlotSNRvsTime4uCLP_SpectrumAna4GIR(          ...
            SNRvsTimeArr1, SNRvsTimeArr2, SNRvsTimeArr3     ...
            , hours, minutes, seconds, nseconds, Iint, du) 
        
  
        

global_SpectrumAna4GIR

c           = 2.99792458e8;% speed of light
   

%  figure( 'Position', [ 100 100 600 800 ] )
figure( 'Visible', 'off' );
%% Convert cell arryas to matrices
%%
LengthNum   = length(SNRvsTimeArr1);
SizeNum     = size(SNRvsTimeArr1{1});

%%% PSD
SNRArr1 = cell2mat(SNRvsTimeArr1);
SNRArr2 = cell2mat(SNRvsTimeArr2);
SNRArr3 = cell2mat(SNRvsTimeArr3);

%%% Seconds
TmpSeconds1     = seconds';
TmpNseconds1    = nseconds';


%% PSD in decibels
%%

idx1 = find(SNRArr1<.1);
SNRArr1(idx1) = 0.1;
idx2 = find(SNRArr2<.1);
SNRArr2(idx2) = 0.1;
idx3 = find(SNRArr3<.1);
SNRArr3(idx3) = 0.1;

SNRvsTimeinDBArr1 = 10*log10(SNRArr1);
SNRvsTimeinDBArr2 = 10*log10(SNRArr2);
SNRvsTimeinDBArr3 = 10*log10(SNRArr3);


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

 range = (1:size(du,2))*c*1/(SamplingRate*1e3)/1e3/2;
 range = range - RangeOffsetValue;
%  range = range - 94;
 FitRange   = find( range >= LowerRange4Ana & range <= UpperRange4Ana );
 
 range = range(FitRange);
%% Plot
%%
DateChar        = num2str(SelDate); 

IntegrationChar = IPP * Factor4IntTime / 1000;
                 IntegrationChar = [ num2str(IntegrationChar) ' ms' ];
                 
% TitleChar = {[ 'HAARP MUIR GIR Data on ' DateChar ]; ...
%              ['']; ['']; ['']; [''] };
%                  
% suptitle(TitleChar);

caxis = [ -10 25 ];
% caxis = [ 50 70 ];

%%% Channel 1: Ion Line
subplot(3,1,1)
imagen(TimeRangeValue, range, SNRvsTimeinDBArr1, caxis);
title({[ '\fontsize{10}\bf SNR(db): \fontsize{8}\rm integration time ' IntegrationChar  ]; ...
       [ '\fontsize{10}\bf Channel 1: Ion Line' ]});
ylabel([ '\fontsize{10}\bf Range(km)' ])
xlabel({[ '\fontsize{10}\bfTime \fontsize{8}\rm(seconds from ', ...
        TimeChar, ' )' ]; ['']})
colorbar


%%% Channel 2: Upshifted Plasma Line
subplot(3,1,2)
imagen(TimeRangeValue, range, SNRvsTimeinDBArr2, caxis);
title([ '\fontsize{10}\bf Channel 2: Upshifted Plasma Line' ])
ylabel([ '\fontsize{10}\bfRange(km)' ])
xlabel({[ '\fontsize{10}\bfTime \fontsize{8}\rm(seconds from ', ...
        TimeChar, ' )' ]; ['']})
colorbar


%%% Channel 3: Downshifted Plasma Line
subplot(3,1,3)
imagen(TimeRangeValue, range, SNRvsTimeinDBArr3, caxis);
title([ '\fontsize{10}\bf Channel 3: Downshifted Plasma Line' ])
ylabel([ '\fontsize{10}\bfRange(km)' ])
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
     FolderName     = [ filesep 'GIR_SNRvsTime' filesep ];
     DirectoryChar  = [ JpgSaveDirectory, FolderName ];

    % ------
    % list-up data file
    % ------
    % 
    % unix command
    %
     if isunix
             CommandChar   = [ 'mkdir -p ' DirectoryChar ];
     elseif ispc
             CommandChar    = [ 'md ' DirectoryChar ];
     end

    %
    % execute the command and return results
    %
     [ tmp, CommandResults ] = unix( CommandChar );  

end %%if SelectedDirectory

FileNameChar   = ...
    [ 'GIR_SNRvsTime_' DateChar, '.', DataChar, '.', HH, MM, SS, '.', NN, ];
if BeamNum == 1
    FileNameChar = [ FileNameChar, '.jpg' ];
else
    FileNameChar = [ FileNameChar, '-', num2str(Ibeam), '.jpg' ];
end%if BeamNum == 1

FileNameChar = [ DirectoryChar, '\', FileNameChar ];
print( '-djpeg', FileNameChar );
% 
close('all');