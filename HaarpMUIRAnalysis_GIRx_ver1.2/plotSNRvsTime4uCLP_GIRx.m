function  plotSNRvsTime4uCLP_GIRx(          ...
            genParam, radarParam, currentData, initParam, Iint) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_PlotSNRvsTime4uCLP_SpectrumAna4GIR
%          made by Jason Turnquist, GI UAF
%
%          ver.1.0: Aug-23-2007
%
%          # make image plot of SNR vs Time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c           = 2.99792458e8;% speed of light
   

 figure( 'Position', [ 100 100 600 800 ] )
% figure( 'Visible', 'off' );


LengthNum   = length(currentData.anaData.SNR);
SizeNum     = size(currentData.anaData.SNR{1});

%% Adjust SNR for background noise
%%
% Noise4SNRArr1    = repmat(currentData.anaData.noise4Power,SizeNum(2),1)';
% Noise4SNRArr2    = repmat(currentData.anaData.noise4Power,SizeNum(2),1)';
% Noise4SNRArr3    = repmat(currentData.anaData.noise4Power,SizeNum(2),1)';

SNR1 = currentData.anaData.Power{1};
SNR1 = SNR1./min(min(SNR1));
SNR2 = currentData.anaData.Power{2};
SNR2 = SNR2./min(min(SNR2));
SNR3 = currentData.anaData.Power{3};
SNR3 = SNR3./min(min(SNR3));

%% PSD in decibels
%%
idx = find(SNR1 < 0);
SNR1(idx) = 0;
SNRvsTimeinDBArr1 = 10*log10(SNR1);
idx = find(SNR2 < 0);
SNR2(idx) = 0;
SNRvsTimeinDBArr2 = 10*log10(SNR2);
idx = find(SNR3 < 0);
SNR3(idx) = 0;
SNRvsTimeinDBArr3 = 10*log10(SNR3);


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

FitRange   = find( radarParam.range >= genParam.lowerAnaRange & ...
                    radarParam.range <= genParam.upperAnaRange );
 
range = radarParam.range(FitRange);

%% Plot
%%
DateChar        = num2str(initParam.expDate); 

IntegrationNum = (radarParam.IPP*1e-3) * genParam.intTime;
                 IntegrationChar = [ num2str(IntegrationNum) ' ms' ];

                 
tickArr     = 0:IntegrationNum:(SizeNum(2)-1)*IntegrationNum;
tickArr     = tickArr/1000;
% 
% caxis = [ -10 25 ];
% caxis = [ 50 70 ];

%%% Generate title
sd = [initParam.expDate, '/', genParam.selFileNames(Iint,:)];

%%% Channel 1: Ion Line
subplot(3,1,1)
imagen(tickArr, range, SNRvsTimeinDBArr1);
title({[ '\bf\fontsize{12}HAARP MUIR GIRx Data on ' sd '\fontsize{10}\bf']; ...
       ['SNR(db): \fontsize{10}\rm integration time ' IntegrationChar  ]; ...
       [ '\fontsize{10}\bf Channel 1: Ion Line' ]});
ylabel([ '\fontsize{10} Range(km)' ])
% xlabel({[ '\fontsize{10}\bfTime \fontsize{10}\rm(seconds from ', ...
%         TimeChar, ' )' ]; ['']})
colorbar
% set(gca, 'XMinorTick', 'on')
% set(gca, 'XTick', [tickArr])

%%% Channel 2: Upshifted Plasma Line
subplot(3,1,2)
imagen(tickArr, range, SNRvsTimeinDBArr2);
title([ '\fontsize{10}\bf Channel 2: Upshifted Plasma Line' ])
ylabel([ '\fontsize{10} Range(km)' ])
% xlabel({[ '\fontsize{10}\bfTime \fontsize{10}\rm(seconds from ', ...
%         TimeChar, ' )' ]; ['']})
colorbar


%%% Channel 3: Downshifted Plasma Line
subplot(3,1,3)
imagen(tickArr, range, SNRvsTimeinDBArr3);
title([ '\fontsize{10}\bf Channel 3: Downshifted Plasma Line' ])
ylabel([ '\fontsize{10} Range(km)' ])
xlabel({[ '\fontsize{10}\bfTime \fontsize{10}\rm(seconds from ', ...
        TimeChar, ' )' ]; ['']})
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
     FolderName     = fullfile('GIR_SNRvsTime', DateChar );
     DirectoryChar  = fullfile( initParam.figSaveDir, FolderName ); 
     
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
    [ 'GIR_SNRvsTime_' DateChar, '.', DataChar, '.', HH, MM, SS, '.', NN, ];

% BeamNum = length(radarParam.beamDir);
BeamNum = 1; %%% temporary 
if BeamNum == 1
    FileNameChar = [ FileNameChar, '.', initParam.figSaveExt ];
else
    FileNameChar = [ FileNameChar, '-', num2str(Ibeam)      ...
                   , '.', initParam.figSaveExt ];
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