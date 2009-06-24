%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_PlotPSDvsTime4uCLPShort_SpectrumAna4GIR
%          made by Jason Turnquist, GI UAF
%
%          ver.1.0: Aug-23-2007
%
%          # make image plot of PSD vs Time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  func_PlotPSDvsTime4uCLPShort_SpectrumAna4GIR( ...
            PSDvsTimeArr1, PSDvsTimeArr2, PSDvsTimeArr3 ...
            , FreqArr1, FreqArr2, FreqArr3              ...
            , hours, minutes, seconds, nseconds) 
        
  
        

global_SpectrumAna4GIR

c           = 2.99792458e8;% speed of light
fradar      = 446;       

LengthNum   = length(PSDvsTimeArr1)

for Iext = 1:1:LengthNum

    %% Convert cell arryas to matrices
    %%

    %%% PSD
    PSDArr1 = PSDvsTimeArr1{Iext};
    PSDArr2 = PSDvsTimeArr2{Iext};
    PSDArr3 = PSDvsTimeArr3{Iext};

    %%% Seconds
    TmpSeconds1 = seconds{Iext}';
    TmpNseconds1 = nseconds{Iext}';

    %% PSD in decibels
    %%
    PSDvsTimeinDBArr1 = 10*log10(PSDArr1);
    PSDvsTimeinDBArr2 = 10*log10(PSDArr2);
    PSDvsTimeinDBArr3 = 10*log10(PSDArr3);


    %% Time
    %%
    TmpChar	= num2str(hours{1}(1));
    HH    	= func_CheckCharLength(TmpChar , 2, '0');

    TmpChar	= num2str(minutes{1}(1));
    MM      = func_CheckCharLength(TmpChar, 2, '0');

    TmpChar	= num2str(seconds{1}(1));
    SS      = func_CheckCharLength(TmpChar , 2, '0');

    TmpChar	= num2str(nseconds{1}(1));
    NN      = func_CheckCharLength(TmpChar, 2, '0');

    TimeChar        = [ HH, ':', MM, ':', SS ];


     NewTimeArrInSecond     = TmpSeconds1 + TmpNseconds1/1e9 ...
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

%     TitleChar = {[ 'HAARP MUIR GIR Data on ' DateChar ]; ...
%                  ['']; ['']; ['']; [''] };
% 
%     suptitle(TitleChar);

    %%% Channel 1: Ion Line
    subplot(3,1,1)
    imagesc(TimeRangeValue, FreqArr1 - fradar, PSDvsTimeinDBArr1, [50 80]);
    title({[ '\fontsize{10}\bf PSD(db): \fontsize{8}\rm integration time ' IntegrationChar  ]; ...
           [ '\fontsize{10}\bf Channel 1: Ion Line' ]});
    ylabel([ '\fontsize{10}\bfFrequncey Offset (MHz)' ])
    xlabel({[ '\fontsize{10}\bfTime \fontsize{8}\rm(seconds from ', ...
            TimeChar, ' )' ]; ['']})
    colorbar


    %%% Channel 2: Upshifted Plasma Line
    subplot(3,1,2)
    imagesc(TimeRangeValue, FreqArr2 - fradar, PSDvsTimeinDBArr2, [50 80]);
    title([ '\fontsize{10}\bf Channel 2: Upshifted Plasma Line' ])
    ylabel([ '\fontsize{10}\bfFrequncey Offset (MHz)' ])
    xlabel({[ '\fontsize{10}\bfTime \fontsize{8}\rm(seconds from ', ...
            TimeChar, ' )' ]; ['']})
    colorbar


    %%% Channel 3: Downshifted Plasma Line
    subplot(3,1,3)
    imagesc(TimeRangeValue, FreqArr3 - fradar, PSDvsTimeinDBArr3, [50 80]);
    title([ '\fontsize{10}\bf Channel 3: Downshifted Plasma Line' ])
    ylabel([ '\fontsize{10}\bfFrequncey Offset (MHz)' ])
    xlabel({[ '\fontsize{10}\bfTime \fontsize{8}\rm(seconds from ', ...
            TimeChar, ' )' ]; ['']})
    colorbar

    
    %------
    % save as jpg
    %------
    
    DataNumChar     = num2str(SelDataNum4GIR);
    DataExtNumChar  = num2str(SelDataExtNum4GIR(Iext));

    DataChar        = [ DataNumChar, '.', DataExtNumChar  ];
    
    FileNameChar   = ...
        [ 'GIR_PSDvsTime_' DateChar, '.', DataChar, '.', HH, MM, SS, '.', NN, ];
    if BeamNum == 1
        FileNameChar = [ FileNameChar, '.jpg' ];
    else
        FileNameChar = [ FileNameChar, '-', num2str(Ibeam), '.jpg' ];
    end%if BeamNum == 1
    print( '-djpeg', FileNameChar );
end%for Iext
