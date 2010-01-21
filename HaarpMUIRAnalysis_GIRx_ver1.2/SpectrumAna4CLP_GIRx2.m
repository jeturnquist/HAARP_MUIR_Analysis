function SpectrumAna4CLP_GIRx(initParam, genParam, radarParam, currentData)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      SpectrumAna4CLP_GIRx.m
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

 

%% Set general parameters
%%

 MemorySaver           = 1;
 
 ShortPlot             = 1;
 
 PSDLinePlot           = 1;
    
%% Input General Parameters
%%
[ results ] = inputAnaParam;  

genParam.gi.intTime = results{1};
genParam.gi.lowerAnaRange = results{2};
genParam.gi.upperAnaRange = results{3};



%% Iterate through selected data files
%%
CountData = length(genParam.gi.selFileNums);
for Iint = 1:1:CountData

    DataChar = [ '  # Data extension: ', num2str(genParam.gi.selFileNums(Iint)) ];
    disp(DataChar);
    
    
    
%% Check the GI receiver channel
%%
    %%% I: ion line  
    %%% D: down-shifted plasma line
    %%% U: up-shifted plasma line

    DataFileChar = ...
        fullfile(genParam.gi.selDir, genParam.gi.selFileNames(Iint,:));
    [ ChannelType ] = checkChannel_GIRx(DataFileChar, radarParam.sri.fRx);


    FitChannel(1)	= findstr(ChannelType,'I'); %% Ion line
    FitChannel(2)	= findstr(ChannelType,'U'); %% Upshifted plasma line
    FitChannel(3)	= findstr(ChannelType,'D'); %% Downshifted plasma line
%     FitChannel4IL   = 1; %%Ionline
%     FitChannel4UPL  = 2; %%Upshifted Plasma Line 
%     FitChannel4DPL  = 3; %%Downshifted Plasma Line



%% Estimate the offset value in the range
%%
    if Iint == 1

        [ results ] = sdrrad(...
            DataFileChar, radarParam.gi, FitChannel(1), radarParam.sri.fRx);
        radarParam.gi.range         = results{1}; 
        radarParam.gi.rangeOffset   = results{2};
    end
    
    
    
%% read radar data
%%
    
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
        currentData.gi.freq          = results{11};

        
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
    
%

%% Calculate frequency array and background noise
%%
    currentData.gi.freqArr = cell(3,1);
    for ii = 1:1:3
        %------
        % calculate array of the frequency in the spectrum
        %------
        [ currentData.gi.freqArr{ii} ] = calFreqArr4uCLP_GIRx( ... 
            radarParam.gi, genParam.gi, currentData.gi.freq{FitChannel(ii)});

        %------
        % calculate the noise level
        %------
        [ currentData.gi.anaData.noise4PSD{ii}      ...
        , currentData.gi.anaData.noise4Power{ii} ] =   ...
            calNoise4uCLP_GIRx(                     ...
                 currentData.gi.du{FitChannel(ii)}  ...
               , radarParam.gi.pulseLength          ...
               , radarParam.gi.samplingRate );

    end
    
    
    
%% Perform analysis routines
%%
    %------
    % calculate PSD vs Time
    %  integrated from "LowerRange4Ana" 
    %               to "UpperRange4Ana"
    %------

    for ii = 1:1:3

        %%% for the channel 1: Ion Line
         disp([ '   Calculating SNR, Power Spectra Density from the channel ', num2str(ii),' ...'] );

         [ SNRArr, PSDArr ] = calSpectra4uCLP_GIRx(...
             genParam.gi, radarParam.gi, currentData.gi, FitChannel(ii));

         if Iint == 1 || MemorySaver
            currentData.gi.anaData.SNR{ii} = SNRArr;
            currentData.gi.anaData.PSD{ii} = PSDArr;
         elseif Iint > 1 && ~MemorySaver
            currentData.gi.anaData.SNR{ii} = ...
                [ currentData.gi.anaData.SNR{ii}; {SNRArr} ];
            currentData.gi.anaData.PSD{ii} = ...
                [ currentData.gi.anaData.PSD{ii}, {PSDArr} ];
         end
     
    end

        

%% PLOT
%%       

%% PSD vs Time: color-coded frequency-time profile
%%    
         if MemorySaver
%             figure( 'Position', [ 100 100 600 800 ] )
            plotPSDvsTime4uCLP_GIRx(          ...
            genParam.gi, radarParam.gi, currentData.gi, initParam.gi, Iint)
%%            
            plotSNRvsTime4uCLP_GIRx(                ...
            genParam.gi, radarParam.gi, currentData.gi, initParam.gi, Iint)
            
%%           
            if PSDLinePlot
%                 figure( 'Position', [ 100 100 600 800 ] );
                plotPSDvsFreq4uCLP_GIRx(          ...
                    genParam.gi, radarParam.gi, currentData.gi, initParam.gi)
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