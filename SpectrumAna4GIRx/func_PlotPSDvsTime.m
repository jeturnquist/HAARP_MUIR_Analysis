function  func_PlotPSDvsTime( ...
            PSDvsTimeArr1, PSDvsTimeArr2, PSDvsTimeArr3 
            , FreqArr1, FreqArr2, FreqArr3, hours, minutes, seconds) 
        
  
        

global_SpectrumAna4GIR

c           = 2.99792458e8;% speed of light
fradar      = 446;       
        
%% Convert cell arryas to matrices
%%
LengthNum   = length(PSDvsTimeArr1);
SizeNum     = size(PSDvsTimeArr1{1});

%%% PSD
PSDArr1 = cell2mat(PSDvsTimeArr1);
PSDArr2 = cell2mat(PSDvsTimeArr2);
PSDArr3 = cell2mat(PSDvsTimeArr3);

%%% Seconds
TmpSeconds1 = cell2mat(seconds');


%% PSD in decibels
%%
PSDvsTimeinDBArr1 = 10*log10(PSDArr1);
PSDvsTimeinDBArr2 = 10*log10(PSDArr2);
PSDvsTimeinDBArr3 = 10*log10(PSDArr3);


%% Time
%%
TmpChar         = func_CheckCharLength(hours{1}(1), 2, 0);
TmpChar         = num2str(TmpChar);
fitspace        = find(~isspace(TmpChar));
HoursChar       = [ TmpChar(fitspace) ];

TmpChar         = func_CheckCharLength(minutes{1}(1), 2, 0);
TmpChar         = num2str(TmpChar);
fitspace        = find(~isspace(TmpChar));
MinutesChar     = [ TmpChar(fitspace) ];

TimeChar        = [ HoursChar, ':', MinutesChar ];

 
%% Plot
%%
DateChar        = num2str(SelDate); 

IntegrationChar = IPP * Factor4IntTime / 1000;
                 IntegrationChar = [ num2str(IntegrationChar) ' ms' ];
                 
TitleChar = {[ 'HAARP MUIR GIR Data on ' DateChar ]; ...
             ['']; ['']; ['']; [''] };
                 
suptitle(TitleChar);

%%% Channel 1: Ion Line
subplot(3,1,1)
imagesc(TmpSeconds1, FreqArr1 - fradar, PSDvsTimeinDBArr1, [50 80]);
title({[ '\fontsize{10}\bf PSD(db): \fontsize{8}\rm integration time ' IntegrationChar  ]; ...
       [ '\fontsize{10}\bf Channel 1: Ion Line' ]});
ylabel([ '\fontsize{10}\bfFrequncey Offset (MHz)' ])
xlabel({[ '\fontsize{10}\bfTime \fontsize{8}\rm(seconds from ', ...
        TimeChar, ' )' ]; ['']})
colorbar


%%% Channel 2: Upshifted Plasma Line
subplot(3,1,2)
imagesc(TmpSeconds1, FreqArr2 - fradar, PSDvsTimeinDBArr2, [50 80]);
title([ '\fontsize{10}\bf Channel 2: Upshifted Plasma Line' ])
ylabel([ '\fontsize{10}\bfFrequncey Offset (MHz)' ])
xlabel({[ '\fontsize{10}\bfTime \fontsize{8}\rm(seconds from ', ...
        TimeChar, ' )' ]; ['']})
colorbar


%%% Channel 3: Downshifted Plasma Line
subplot(3,1,3)
imagesc(TmpSeconds1, FreqArr3 - fradar, PSDvsTimeinDBArr3, [50 80]);
title([ '\fontsize{10}\bf Channel 3: Downshifted Plasma Line' ])
ylabel([ '\fontsize{10}\bfFrequncey Offset (MHz)' ])
xlabel({[ '\fontsize{10}\bfTime \fontsize{8}\rm(seconds from ', ...
        TimeChar, ' )' ]; ['']})
colorbar
