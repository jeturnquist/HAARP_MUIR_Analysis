%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      uCLP_SpectrumAna4GIR.m
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
% set global parameter
%------
 global_SpectrumAna4GIR;
 
 
%------
% set general parameters
%------
% AnaStyle             : 0:use all data files in the selected directory
%                        1:use a selected data by user
%                       -1:use a range of user selected data 
% Factor4IntTime       : >=1: factor of the pulse sequence (integer only)
%                           e.g. Sampling time = 10 ms &
%                                Factor4IntTime = 100
%                                 --> 1 sec integration time
% LowerRange4Ana       : spectrum analysis is done above this range (km)
% UpperRange4Ana       : spectrum analysis is done below this range (km)
% fHF                  : HF pump frequency in MHz
%------
%  AnaStyle              = 0;%0: use all data file in the selected directory
%                            %1: select a data by user
 MemorySaver           = 1;
 
 ShortPlot             = 0;
 
 PSDLinePlot           = 0;
    
%% Input General Parameters
 func_InputGeneralParam4CLP_SpectrumAna4GIR;
 
%  if AnaStyle == 1
%     CountData = length(SelDataExtNum4GIR);
%  elseif AnaStyle == 0
%     CountData = CountDataNum4GIR;  
%  end                          

%%------
%% Read experiment setup file
%%------
%%% global parameters
% PulseLength          : pulse length (micro-second)
% SamplingRate         : sampling rate (kHz)
% StartTime4Tx         : start time of Tx (micro-second)
% StartTime4Rx         : start time of Rx (micro-second)
% BeamNum              : beam number
% BeamAngleX(Y)        : beam-direction angle
% DCKNum               : Down Converter Knob value (MHz)
%------
 func_ReadExpSetupFile4uCLP_SpectrumAna4GIR2;

%------


%% Iterate through selected data files
CountData = length(SelDataExtNum4GIR);
for Iint = 1:1:CountData
    
    func_DataFileName4GIR_SpectrumAna4GIR(Iint);

  	DataExtChar = num2str(SelDataExtNum4GIR(Iint));
    DataChar = [ '  # Data extension: ', DataExtChar ];
    disp(DataChar);
    
    %% Check the GI receiver channel
    %  global: ChannelType
    %            I: ion line  
    %            D: down-shifted plasma line
    %            U: up-shifted plasma line
    %%------
     func_CheckChannel_SpectrumAna4GIR;


    %------
    %% Calibrate the range
    %------
    %%% looking for a receiver channel for the ion-line measurement
     FitChannel4IL	= findstr(ChannelType,'I');
     FitChannel4UPL	= findstr(ChannelType,'U');
     FitChannel4DPL	= findstr(ChannelType,'D');
%     FitChannel4IL   = 1; %%Ionline
%     FitChannel4UPL  = 3; %%Upshifted Plasma Line 
%     FitChannel4DPL  = 2; %%Downshifted Plasma Line

    if Iint == 1
        %% Estimate the offset value in the range
        [ hdr1,  du1,                 ...
        Tmpyears1, Tmpmonths1, Tmpdays1,                          ...
        Tmphours1, Tmpminutes1, Tmpseconds1, Tmpnseconds1, freq1 ] = ...
        sdrrad2(DataFileName4GIR,FitChannel4IL,2);
    end
 
    %------
    % read radar data
    %------
     disp( '   Reading data from the channel 1 ...' );
     disp( '   Reading data from the channel 2 ...' );
     disp( '   Reading data from the channel 3 ...' );
     [ hdr,  du,                 ...
     Tmpyears, Tmpmonths, Tmpdays,                          ...
     Tmphours, Tmpminutes, Tmpseconds, Tmpnseconds, freq ] = ...
     sdrrad2(DataFileName4GIR,0,1);
 
    for ii = 1:1:3
        idx = find(isnan(du{ii}(:,1)));
        if ~isempty(idx)
            lch{ii} =  size(du{ii},1) - length(idx); 
            idx = find(isnan(du{ii}));
            if ~isempty(idx)
                du{ii}(idx) = 0;
            end
        else
            idx = find(isnan(du{ii}));
            if ~isempty(idx)
                du{ii}(idx) = 0;
            end
            lch{ii} = size(du{ii},1);
        end
    end
    

    ICh = FitChannel4DPL;
	if Iint == 1 || MemorySaver
        years1       = [];
        months1      = [];
        days1        = [];
        hours1       = [];
        minutes1     = [];
        seconds1     = [];
        nseconds1    = [];
        
        years1       = Tmpyears{ICh}(1:lch{1});
        months1      = Tmpmonths{ICh}(1:lch{1});
        days1        = Tmpdays{ICh}(1:lch{1});
        hours1       = Tmphours{ICh}(1:lch{1});
        minutes1     = Tmpminutes{ICh}(1:lch{1});
        seconds1     = Tmpseconds{ICh}(1:lch{1});
        nseconds1    = Tmpnseconds{ICh}(1:lch{1}); 
        
    elseif Iint > 1 && ~MemorySaver
        years1       = [ years1;     Tmpyears{1} ];
        months1      = [ months1;    Tmpmonths{1} ] ;
        days1        = [ days1;      Tmpdays{1} ];
        hours1       = [ hours1;     Tmphours{1} ];
        minutes1     = [ minutes1;   Tmpminutes{1}];
        seconds1     = [ seconds1;   Tmpseconds{1} ];
        nseconds1    = [ nseconds1;  Tmpnseconds{1} ];
	end

    %------
    % calculate array of the frequency in the spectrum
    %------
    %%% for the channel 1: Ion Line
     [ FreqArr1 ] = func_CalFreqArr4uCLP_SpectrumAna4GIR(...
         freq{FitChannel4IL}, du{FitChannel4IL});

    %%% for the channel 2: Upshifted Plasma Line
     [ FreqArr2 ] = func_CalFreqArr4uCLP_SpectrumAna4GIR(...
         freq{FitChannel4UPL}, du{FitChannel4UPL});

    %%% for the channel 3: Downshifted Plasma Line
     [ FreqArr3 ] = func_CalFreqArr4uCLP_SpectrumAna4GIR(...
         freq{FitChannel4DPL}, du{FitChannel4DPL});



    %------
    % calculate the noise level
    %------
    %%% for the channel 1: Ion Line
     [ Noise4PSDArr1, Noise4Power1 ] = ...
         func_CalNoize4uCLP_SpectrumAna4GIR(du{FitChannel4IL});


    %%% for the channel 2: Upshifted Plasma Line
     [ Noise4PSDArr2, Noise4Power2 ] = ...
         func_CalNoize4uCLP_SpectrumAna4GIR(du{FitChannel4UPL});


    %%% for the channel 3: Downshifted Plasma Line
     [ Noise4PSDArr3, Noise4Power3 ] = ...
         func_CalNoize4uCLP_SpectrumAna4GIR(du{FitChannel4DPL});
     

%%
    %------
    % calculate PSD vs Time
    %  integrated from "LowerRange4Ana" 
    %               to "UpperRange4Ana"
    %------
    %%% for the channel 1: Ion Line
     disp( '   Calculating SNR, Power Spectra Density from the channel 1 ...' );
     ChannelNum  = FitChannel4IL;
     [ TmpSNRvsTimeArr1, TmpPSDvsTimeArr1, RangeArr1 ] =                ...
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
     [ TmpSNRvsTimeArr2, TmpPSDvsTimeArr2, RangeArr2 ] =                 ...
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