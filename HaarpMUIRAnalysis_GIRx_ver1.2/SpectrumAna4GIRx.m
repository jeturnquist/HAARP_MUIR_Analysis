function SpectrumAna4GIRx(initParam, genParam, radarParam, currentData)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      SpectrumAna4GIRx.m
%         made by Shin-ichiro Oyama, GI UAF
%                   arranged by Jason Turnquist, GI UAF
%         ver.1.0: aug-16-2006
%                  copied from Decode4CLP_SpectrumAna4GIR.m
%
%         # spectrum analysis using data taken with the GI receiver of MUIR
%           for uCLP (unCoded Long Pulse)
%         # Does not work for multi beam data (yet)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
%------
% set general parameters
%------

 MemorySaver           = 1;
 
 ShortPlot             = 1;
 
 PSDLinePlot           = 0;
    
%% Input General Parameters
[ results ] = inputAnaParam;  

genParam.gi.intTime = results{1};
genParam.gi.lowerAnaRange = results{2};
genParam.gi.UpperAnaRange = results{2};


%% Iterate through selected data files
CountData = length(genParam.gi.selFileNums);
for Iint = 1:1:CountData

    DataChar = [ '  # Data extension: ', num2str(genParam.gi.selFileNums(Iint)) ];
    disp(DataChar);
    
    %% Check the GI receiver channel
    %            I: ion line  
    %            D: down-shifted plasma line
    %            U: up-shifted plasma line
    %%------
    DataFileChar = ...
        fullfile(genParam.gi.selDir, genParam.gi.selFileNames(Iint,:));
    [ ChannelType ] = checkChannel_GIRx(DataFileChar, radarParam.sri.fRx);


    FitChannel(1)	= findstr(ChannelType,'I'); %% Ion line
    FitChannel(2)	= findstr(ChannelType,'U'); %% Upshifted plasma line
    FitChannel(3)	= findstr(ChannelType,'D'); %% Downshifted plasma line
%     FitChannel4IL   = 1; %%Ionline
%     FitChannel4UPL  = 2; %%Upshifted Plasma Line 
%     FitChannel4DPL  = 3; %%Downshifted Plasma Line

    if Iint == 1
        %% Estimate the offset value in the range
        [ results ] = sdrrad(...
            DataFileChar, radarParam.gi, FitChannel{1}, radarParam.sri.fRx);
        radarParam.gi.range         = results{1}; 
        radarParam.gi.rangeOffset   = results{2};
    end
    
    %------
    % read radar data
    %------
    
    [ results ] = sdrrad(DataFileChar);
    currentData.gi.du            = results{2}; 
    radarParam.gi.fRx            = results{11};  
    currentData.gi.record_size   = results{3};
    
    if Iint == 1 || MemorySaver       
        %%% form time structure
        
        currentData.gi.time.years    = results{4};
        currentData.gi.time.months   = results{5};
        currentData.gi.time.days     = results{6};    
        currentData.gi.time.hours    = results{7};
        currentData.gi.time.minutes  = results{8};
        currentData.gi.time.seconds  = results{9};    
        currentData.gi.time.nseconds = results{10};

    elseif Iint > 1 && ~MemorySaver
        tmp = setdiff(currentData.gi.time.years, results{4});
        currentData.gi.time.years    = [ currentData.gi.time.years, tmp ];
        
        tmp = setdiff(currentData.gi.time.months, results{5});
        currentData.gi.time.months   = [ currentData.gi.time.months, tmp ];
        
        tmp = setdiff(currentData.gi.time.days, results{6});
        currentData.gi.time.days     = [ currentData.gi.time.days, tmp ];    

        currentData.gi.time.hours    = [ currentData.gi.time.hours,     ...
            results{7}];

        currentData.gi.time.minutes  = [ currentData.gi.time.minutes,   ...
            results{8} ];

        currentData.gi.time.seconds  = [ currentData.gi.time.seconds,   ...
            results{9}];    

        currentData.gi.time.nseconds = [ currentData.gi.time.nseconds,  ...
            results{10}];
        
        clear tmp;
    end
    
    
    for ii = 1:1:3
        %------
        % calculate array of the frequency in the spectrum
        %------
        [ currentData.gi.freqArr{1} ] = calFreqArr4uCLP_GIRx( ... 
            radarParam.gi, genParam.gi, currentData.gi.freq{FitChannel(ii)});

        %------
        % calculate the noise level
        %------
        [ Noise4PSDArr1, Noise4Power1 ] =          ...
            func_CalNoize4uCLP_SpectrumAna4GIR(    ...
               currentData.gi.du{FitChannel4IL});

    end
     

%%
    %------
    % calculate PSD vs Time
    %  integrated from "LowerRange4Ana" 
    %               to "UpperRange4Ana"
    %------
    %%% for the channel 1: Ion Line
     disp( '   Calculating SNR, Power Spectra Density from the channel 1 ...' );
     ChannelNum  = FitChannel4IL;
     [ TmpSNRvsTimeArr1, TmpPSDvsTimeArr1, RangeArr1 ] =                   ...
           func_CalSpectraInfo4uCLP_SpectrumVsTime4GIR(  ...
           du{FitChannel4IL}, FreqArr1, Noise4Power1, ChannelNum );

     if Iint == 1 || MemorySaver
        SNRvsTimeArr1   	= {TmpSNRvsTimeArr1};
        PSDvsTimeArr1      	= {TmpPSDvsTimeArr1};
     elseif Iint > 1 && ~MemorySaver
        SNRvsTimeArr1   	= [ SNRvsTimeArr1; {TmpSNRvsTimeArr1} ];
        PSDvsTimeArr1   	= [ PSDvsTimeArr1, {TmpPSDvsTimeArr1} ];
     end

    %%% for the channel 2: Upshifted Plasma Line
     disp( '   Calculating SNR, Power Spectra Density from the channel 2 ...' );
     ChannelNum  = FitChannel4UPL;
     [ TmpSNRvsTimeArr2, TmpPSDvsTimeArr2, RangeArr2 ] =                   ...
           func_CalSpectraInfo4uCLP_SpectrumVsTime4GIR(  ...
           du{FitChannel4UPL}, FreqArr2, Noise4Power2, ChannelNum );

     if Iint == 1 || MemorySaver
        SNRvsTimeArr2       = {TmpSNRvsTimeArr2};
        PSDvsTimeArr2       = {TmpPSDvsTimeArr2};
     elseif Iint > 1 && ~MemorySaver
        SNRvsTimeArr2       = [ SNRvsTimeArr2; {TmpSNRvsTimeArr2} ];
        PSDvsTimeArr2       = [ PSDvsTimeArr2, {TmpPSDvsTimeArr2} ];
     end

    %%% for the channel 3: Down Shifted Plasma Line
     disp( '   Calculating SNR, Power Spectra Density from the channel 3 ...' );
     ChannelNum  = FitChannel4DPL;
     [ TmpSNRvsTimeArr3, TmpPSDvsTimeArr3, RangeArr3 ] = 	...
           func_CalSpectraInfo4uCLP_SpectrumVsTime4GIR(     ...
           du{FitChannel4DPL}, FreqArr3, Noise4Power3, ChannelNum );

     if Iint == 1 || MemorySaver
        SNRvsTimeArr3       = {TmpSNRvsTimeArr3};
        PSDvsTimeArr3       = {TmpPSDvsTimeArr3};
     elseif Iint > 1 && ~MemorySaver
        SNRvsTimeArr3       = [ SNRvsTimeArr3; {TmpSNRvsTimeArr3} ];
        PSDvsTimeArr3      	= [ PSDvsTimeArr3, {TmpPSDvsTimeArr3} ];
     end
        
%------
% PLOT
%------        
%%
%% PSD vs Time: color-coded frequency-time profile
%%    
        if MemorySaver
%             figure( 'Position', [ 100 100 600 800 ] )
            func_PlotPSDvsTime4uCLP_SpectrumAna4GIR( ...
                PSDvsTimeArr1, PSDvsTimeArr2, PSDvsTimeArr3         ...
                , FreqArr1, FreqArr2, FreqArr3                      ...
                , hours1 , minutes1, seconds1, nseconds1, Iint)
%%            
            func_PlotSNRvsTime4uCLP_SpectrumAna4GIR(                ...
                SNRvsTimeArr1, SNRvsTimeArr2, SNRvsTimeArr3         ...
                , hours1, minutes1, seconds1, nseconds1, Iint, du{1})
            
%%           
            if PSDLinePlot
%                 figure( 'Position', [ 100 100 600 800 ] );
                func_PlotPSDvsFreq4uCLPShort_SpectrumAna4GIR( ...
                    PSDvsTimeArr1, PSDvsTimeArr2, PSDvsTimeArr3  	...
                    , FreqArr1, FreqArr2, FreqArr3               	...
                    , hours1, minutes1, seconds1, nseconds1)
            end%if PSDLinePlot
        end%if MemorySaver
        
end%for Iint = 1:1:CountData



if ~MemorySaver
%%
%% PSD vs Time: color-coded frequency-time profile
%%    
    figure( 'Position', [ 100 100 600 800 ] )
    func_PlotPSDvsTime4uCLP_SpectrumAna4GIR( ...
        PSDvsTimeArr1, PSDvsTimeArr2, PSDvsTimeArr3     ...
      	, FreqArr1, FreqArr2, FreqArr3                  ...
        , hours1 , minutes1, seconds1, nseconds1, 0)
    
    
%%         
%% PSD vs Time: color-coded frequency-time profile for single data file
%%    
    if  ShortPlot     
        figure( 'Position', [ 100 100 600 800 ] )
        func_PlotPSDvsTime4uCLPShort_SpectrumAna4GIR( ...
                PSDvsTimeArr1, PSDvsTimeArr2, PSDvsTimeArr3 ...
                , FreqArr1, FreqArr2, FreqArr3              ...
                , hours1, minutes1, seconds1, nseconds1)
    end%if ShortPlot
    
%%
%% PSD Line Plot: Line plot of frequncey vs power for each intergration
%% period
%%
     if PSDLinePlot
        func_PlotPSDvsFreq4uCLPShort_SpectrumAna4GIR(...
            PSDvsTimeArr1, PSDvsTimeArr2, PSDvsTimeArr3         ...
            , FreqArr1, FreqArr2, FreqArr3                      ...
            , hours1, minutes1, seconds1, nseconds1)
     end%if PSDLinePlot
     
end%if ~MemorySaver