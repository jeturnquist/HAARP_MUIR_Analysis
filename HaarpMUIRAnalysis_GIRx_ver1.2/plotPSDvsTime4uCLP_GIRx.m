function  plotPSDvsTime4uCLP_GIRx(          ...
            genParam, radarParam, currentData, initParam, Iint) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       plotPSDvsTime4uCLP_GIRx.m
%          made by Jason Turnquist, GI UAF
%
%          ver.1.0: Aug-23-2007
%
%          # make image plot of PSD vs Time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c           = 2.99792458e8;% speed of light
fradar      = 446;       

% figure( 'Position', [ 100 100 600 800 ] )
figure( 'Visible', 'off' );
freqwd = 100;


LengthNum   = length(currentData.anaData.PSD);
SizeNum     = size(currentData.anaData.PSD{1});

%% Adjust SNR for background noise
%%

for ii = 1:1:3
    ll = 1;
    for kk = 1:genParam.intTime:length(currentData.anaData.noise4PSD{ii})
        noise4PSD{ii}(ll) = sum(...
            currentData.anaData.noise4PSD{ii}(kk:kk+genParam.intTime-1));
        ll = ll + 1; 
    end
end
Noise4PSDArr1    = repmat(noise4PSD{1},SizeNum(1),1);
Noise4PSDArr2    = repmat(noise4PSD{2},SizeNum(1),1);
Noise4PSDArr3    = repmat(noise4PSD{3},SizeNum(1),1);

PSD1 = currentData.anaData.PSD{1};
% PSD1 = PSD1./Noise4PSDArr1;
PSD2 = currentData.anaData.PSD{2};
% PSD2 = PSD2./Noise4PSDArr2;
PSD3 = currentData.anaData.PSD{3};
% PSD3 = PSD3./Noise4PSDArr3;

%% PSD in decibels
%%
idx = find(PSD1 > 0);
PSDvsTimeinDBArr1 = 10*log10(PSD1);
idx = find(PSD2 > 0);
PSDvsTimeinDBArr2 = 10*log10(PSD2);
idx = find(PSD3 > 0);
PSDvsTimeinDBArr3 = 10*log10(PSD3);


%% Time
%%

%%% Seconds
TmpSeconds1     = currentData.time.seconds{1}';
TmpNseconds1    = currentData.time.nseconds{1}';

TmpChar	= num2str(currentData.time.hours{1}(1));
HH    	= func_CheckCharLength(TmpChar , 2, '0');

TmpChar	= num2str(currentData.time.minutes{1}(1));
MM      = func_CheckCharLength(TmpChar, 2, '0');

TmpChar	= num2str(currentData.time.seconds{1}(1));
SS      = func_CheckCharLength(TmpChar , 2, '0');

TmpChar	= num2str(currentData.time.nseconds{1}(1));
NN      = func_CheckCharLength(TmpChar, 2, '0');


TimeChar	= [ HH, ':', MM, ':',SS ];
idx = find(isnan(TmpSeconds1));
if isempty(idx)
    idx  = length(TmpSeconds1)+1;
end



%% Plot
%%
DateChar        = num2str(initParam.expDate); 

IntegrationNum = (radarParam.IPP*1e-3) * genParam.intTime;
                 IntegrationChar = [ num2str(IntegrationNum) ' ms' ];

                 
tickArr     = 0:IntegrationNum:SizeNum(2)*IntegrationNum;
tickArr     = tickArr/1000;


caxis = [ 70 120 ];
% caxis = [ 50 95 ];
% caxis = [ 50 70 ];

l = length(PSDvsTimeinDBArr1);
Freqlength = length(currentData.freqArr{1});
FreqWidth = ceil(Freqlength/2)-freqwd:ceil(Freqlength/2) + freqwd;

%%% 
%%% Channel 1: Ion Line
%%% 
subplot(3,1,1)
Freq1 = currentData.freqArr{1}(FreqWidth) - fradar;
Freq1 = fliplr(Freq1);
imagen(tickArr, Freq1, PSDvsTimeinDBArr1(l/2-freqwd:l/2+freqwd,:),caxis);
title({[ '\bf HAARP MUIR GIRx Data on ' DateChar '\fontsize{10}\bf           PSD(db): \fontsize{10}\rm integration time ' IntegrationChar  ]; ...
       [ '\fontsize{10}\bf Channel 1: Ion Line' ] }, 'Interpreter', 'tex');  
ylabel([ '\fontsize{10}\bf Frequncey Offset (MHz)' ])
xlabel({[ '\fontsize{10}\bf Time \fontsize{10}\rm(seconds from ', ...
        TimeChar, ' )' ]})
colorbar

%%% 
%%% Channel 2: Upshifted Plasma Line
%%% 
subplot(3,1,2)
Freq2 = currentData.freqArr{2}(FreqWidth) - fradar;
Freq2 = fliplr(Freq2);
imagen(tickArr, Freq2, PSDvsTimeinDBArr2(l/2-freqwd:l/2+freqwd,:),caxis);
title([ '\fontsize{10}\bf Channel 2: Upshifted Plasma Line' ])
ylabel([ '\fontsize{10}\bfFrequncey Offset (MHz)' ])
xlabel({[ '\fontsize{10}\bfTime \fontsize{10}\rm(seconds from ', ...
        TimeChar, ' )' ]})
colorbar

%%%
%%% Channel 3: Downshifted Plasma Line
%%%
subplot(3,1,3)
Freq3 = currentData.freqArr{3}(FreqWidth) - fradar;
Freq3 = fliplr(Freq3);
imagen(tickArr, Freq3, PSDvsTimeinDBArr3(l/2-freqwd:l/2+freqwd,:),caxis);
title([ '\fontsize{10}\bf Channel 3: Downshifted Plasma Line' ])
ylabel([ '\fontsize{10}\bfFrequncey Offset (MHz)' ])
xlabel({[ '\fontsize{10}\bfTime \fontsize{10}\rm(seconds from ', ...
        TimeChar, ' )' ]})
colorbar



%% save as jpg
%%
idx = findstr(genParam.selFileNames, '.');
SelDataNum4GIR      = genParam.selFileNames(1:idx(1)-1);
SelDataExtNum4GIR   = genParam.selFileNums;
    
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
if initParam.figSaveExt 
     FolderName     = [ filesep, 'GIR_PSDvsTime', filesep, DateChar ];
     DirectoryChar  = [ initParam.figSaveDir, FolderName ]; 
     
     %%%
     %%% Check directory tree, if needed make directry tree 
     %%%

     CommandChar   = [ 'cd ' DirectoryChar ];

     [ status, CommandResults ] = unix( CommandChar );

     if status 
         [ status, CommandResults ] = mkdir( DirectoryChar ); 
     end

end %%if SelectedDirectory

FileNameChar   = ...
    [ 'GIR_PSDvsTime_' DateChar, '.', DataChar, '.', HH, MM, SS, '.', NN, ];

BeamNum = length(currentData.BeamDir);
if BeamNum == 1
    FileNameChar = [ FileNameChar, initParam.figSaveExt ];
else
    FileNameChar = [ FileNameChar, '-', num2str(Ibeam), initParam.figSaveExt ];
end%if BeamNum == 1

FileNameChar = [ DirectoryChar, filesep, FileNameChar ];

switch initParam.figSaveExt
    case {'jpg'}
        print('-djpeg', FileNameChar);
    case {'tif'}
        print('-dtiff', FileNameChar);
    case {'pdf'}
        print('-dpdf', FileNameChar);  
    case {'epd'}
        print('-deps', FileNameChar);
    case {'fig'}
        saveas(fh, FileNameChar);
end

close('all');