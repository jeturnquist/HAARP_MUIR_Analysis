%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      Decode4CLP_SpectrumAna4GIR.m
%         made by Shin-ichiro Oyama, GI UAF
%
%         ver.1.0: 05-Jul-2006
%         ver.1.1: 19-Jul-2006: remove TimeStampNumber
%         ver.1.2: 19-Jul-2006: calculate the noise
%         ver.1.3: 27-Jul-2006: manually input general parameters
%         ver.1.4: 28-Jul-2006: update for multi-beam data
%
%         # spectrum analysis using data taken with the GI receiver of MUIR
%           for CLP (Coded Long Pulse)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------
% set global parameter
%------
 global_SpectrumAna4GIR;
 

%------
% Rx Input Paramters: User defined 
%------

FitChannel4IL   = 2; %%Ionline
FitChannel4UPL  = 1; %%Upshifted Plasma Line 
FitChannel4DPL  = 3; %%Downshifted Plasma Line

CH_FREQ     = cell(3,1);
CH_FREQ{FitChannel4IL}  = 21000000; %(Hz) Ion line
CH_FREQ{FitChannel4UPL} = 26800000; %(Hz) Upshifted Plamsa Line
CH_FREQ{FitChannel4DPL} = 15200000; %(Hz) Downshifted Plamsa line 
 
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
 
 ShortPlot             = 1;
 
 PSDLinePlot           = 0;
 
%% Input General Parameters
 func_InputGeneralParam4CLP_SpectrumAna4GIR;
                           

%------
% read experiment setup file
%------
%%% global parameters
% BaudLength           : baud length (micro-second)
% PulseLength          : pulse length (micro-second)
% SamplingRate         : sampling rate (kHz)
% StartTime4Tx         : start time of Tx (micro-second)
% StartTime4Rx         : start time of Rx (micro-second)
% BeamNum              : beam number
% BeamAngleX(Y)        : beam-direction angle
% DCKNum               : Down Converter Knob value (MHz)
%------
 func_ReadExpSetupFile_Decode4CLP_SpectrumAna4GIR2;

% if AnaStyle
%     CountData = 1;
% else
%     CountData = CountDataNum4GIR;
% end

   
CountData = length(SelDataExtNum4GIR);

for Iint = 1:1:CountData
%     if Iint == 1
%         BaseDataExtNum4GIR = SelDataExtNum4GIR;
%     elseif Iint > 1
%         SelDataExtNum4GIR = DataExtArr(BaseDataExtNum4GIR + Iint);
%         func_DataFileName4GIR_SpectrumAna4GIR;
%     end
    
    func_DataFileName4GIR_SpectrumAna4GIR(Iint);
    
    DataExtChar = num2str(SelDataExtNum4GIR(Iint));
    DataChar = [ '  #Data extension: ', DataExtChar ];
    disp(DataChar);
        
    %------
    % check the GI receiver channel
    %  global: ChannelType
    %            I: ion line  
    %            D: down-shifted plasma line
    %            U: up-shifted plasma line
    %------
     func_CheckChannel_SpectrumAna4GIR;

    %------
    % calibrate the range
    %------
    %%% looking for a receiver channel for the ion-line measurement
     FitChannel4IL   = findstr(ChannelType,'I');
     FitChannel4UPL   = findstr(ChannelType,'U');
     FitChannel4DPL   = findstr(ChannelType,'D');
    % FitChannel4IL   = 1;%temporal to prepare progrums for multi-beam
    %  FitChannel4IL   = FitChannel4IL(1);


%%% estimate the offset value in the range
    if Iint == 1
        %% Estimate the offset value in the range
        [ hdr1,  du1,                 ...
        Tmpyears, Tmpmonths, Tmpdays,                          ...
        Tmphours, Tmpminutes, Tmpseconds, Tmpnseconds, freq1 ] = ...
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
  time_idx = cell(1,3);
  
   for ii = 1:1:3
        idx = find(isnan(du{ii}(:,1)));
        if ~isempty(idx)
            lch{ii} = idx(end)-1; 
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
    

	if Iint == 1
     	years       = {};
        months      = {};
        days        = {};
        hours       = {};
        minutes     = {};
        seconds     = {};
        nseconds    = {};

        years       = {Tmpyears};
        months      = {Tmpmonths};
        days        = {Tmpdays};
        hours       = {Tmphours};
        minutes     = {Tmpminutes};
        seconds     = {Tmpseconds};
        nseconds    = {Tmpnseconds};
    else
        years       = [ years,     {Tmpyears} ];
        months      = [ months,    {Tmpmonths}] ;
        days        = [ days,      {Tmpdays} ];
        hours       = [ hours,     {Tmphours} ];
        minutes     = [ minutes,   {Tmpminutes} ];
        seconds     = [ seconds,   {Tmpseconds} ];
        nseconds    = [ nseconds,  {Tmpnseconds} ];
    end

    %------
    % calculate array of the frequency in the spectrum
    %------
    %%% for the channel 1: Ion Line
     [ FreqArr1 ] = func_CalFreqArr4CLP_SpectrumAna4GIR(...
         CH_FREQ{FitChannel4IL});

    %%% for the channel 2: Upshifted Plasma Line
     [ FreqArr2 ] = func_CalFreqArr4CLP_SpectrumAna4GIR(...
         CH_FREQ{FitChannel4UPL});

    %%% for the channel 3: Downshifted Plasma Line
     [ FreqArr3 ] = func_CalFreqArr4CLP_SpectrumAna4GIR(...
         CH_FREQ{FitChannel4DPL});




    %------
    % calculate the noise level
    %------
    %%% for the channel 1: Ion Line
     [ TmpNoise4PSDArr1, TmpNoise4Power1 ] = ...
         func_CalNoize4CLP_SpectrumAna4GIR(du{FitChannel4IL});


    %%% for the channel 2: Upshifted Plasma Line
     [ TmpNoise4PSDArr2, TmpNoise4Power2 ] = ...
         func_CalNoize4CLP_SpectrumAna4GIR(du{FitChannel4UPL});


    %%% for the channel 3: Downshifted Plasma Line
     [ TmpNoise4PSDArr3, TmpNoise4Power3 ] = ...
         func_CalNoize4CLP_SpectrumAna4GIR(du{FitChannel4DPL});
     
     if Iint == 1
         Noise4PSDArr1 = {TmpNoise4PSDArr1};
         Noise4PSDArr2 = {TmpNoise4PSDArr2};
         Noise4PSDArr3 = {TmpNoise4PSDArr3};
         
         Noise4Power1  = {TmpNoise4Power1};
         Noise4Power2  = {TmpNoise4Power2};
         Noise4Power3  = {TmpNoise4Power3};
     else
         
         Noise4PSDArr1 = [ Noise4PSDArr1, {TmpNoise4PSDArr1} ];
         Noise4PSDArr2 = [ Noise4PSDArr2, {TmpNoise4PSDArr2} ];
         Noise4PSDArr3 = [ Noise4PSDArr3, {TmpNoise4PSDArr3} ];
         
         Noise4Power1  = [ Noise4Power1, {TmpNoise4Power1} ];
         Noise4Power2  = [ Noise4Power2, {TmpNoise4Power2} ];
         Noise4Power3  = [ Noise4Power3, {TmpNoise4Power3} ];
     end


    %------
    % calculate SNR, Power Spectra Density
    %  integrated from "LowerRange4Ana" 
    %               to "UpperRange4Ana"
    %------
    %%
    %% PSDvsRange : Calculate Power Spectral Desity for single time series at
    %%               multitpe ranges
    %%

    %%% for the channel 1
     disp( '   Calculating SNR, Power Spectra Density from the channel 1 ...' );
     
     if BeamNum == 1
         [ TmpPowerArr1, TmpPSDArr1, TmpRangeArr1, TmpMeanPSDArr1, TmpMeanPowerArr1 ] =                  ...
             func_CalSpectraInfo_Decode4CLP_SpectrumAna4GIR(  ...
             du{FitChannel4IL}, FreqArr1, FitChannel4IL );
     else
         [ TmpPowerArr1, TmpPSDArr1, TmpRangeArr1, TmpMeanPSDArr1, TmpMeanPowerArr1 ] =                  ...
             func_CalSpectraInfoMultiBeam_Decode4CLP_SpectrumAna4GIR(  ...
             du{FitChannel4IL}, FreqArr1, FitChannel4IL );
     end%if BeamNum == 1

     if Iint == 1
         PowerArr1      = {TmpPowerArr1};
         PSDArr1        = {TmpPSDArr1};
         RangeArr1      = {TmpRangeArr1};
         MeanPSDArr1    = {TmpMeanPSDArr1};
         MeanPowerArr1  = {TmpMeanPowerArr1};
     else
         PowerArr1     	= [ PowerArr1; {TmpPowerArr1} ];
         PSDArr1       	= [ PSDArr1, {TmpPSDArr1} ];
         RangeArr1      = [ RangeArr1, {TmpRangeArr1} ];
         MeanPSDArr1    = [ MeanPSDArr1, {TmpMeanPSDArr1} ];
         MeanPowerArr1  = [ MeanPSDArr1, {TmpMeanPowerArr1} ];
     end

    %%% for the channel 2
     disp( '   Calculating SNR, Power Spectra Density from the channel 2 ...' );
     
     if BeamNum == 1
         [ TmpPowerArr2, TmpPSDArr2, TmpRangeArr2, TmpMeanPSDArr2, TmpMeanPowerArr2  ] =                 ...
             func_CalSpectraInfo_Decode4CLP_SpectrumAna4GIR( ...
             du{FitChannel4UPL}, FreqArr2, FitChannel4UPL );
     else
         [ TmpPowerArr2, TmpPSDArr2, TmpRangeArr2, TmpMeanPSDArr2, TmpMeanPowerArr2  ] =                  ...
            func_CalSpectraInfoMultiBeam_Decode4CLP_SpectrumAna4GIR(  ...
             du{FitChannel4UPL}, FreqArr2, FitChannel4UPL );
     end%if BeamNum == 1

    if Iint == 1
        PowerArr2       = {TmpPowerArr2};
        PSDArr2         = {TmpPSDArr2};
        MeanPSDArr2     = { TmpMeanPSDArr2 };
        MeanPowerArr2   = { TmpMeanPowerArr2 };
    else
        PowerArr2     	= [ PowerArr2; {TmpPowerArr2} ];
        PSDArr2       	= [ PSDArr2, {TmpPSDArr2} ];
        MeanPSDArr2     = [ MeanPSDArr2, {TmpMeanPSDArr2} ];
        MeanPowerArr2   = [ MeanPSDArr2, {TmpMeanPowerArr2} ];
    end

    %%% for the channel 3
     disp( '   Calculating SNR, Power Spectra Density from the channel 3 ...' );
     
     if BeamNum == 1
         [ TmpPowerArr3, TmpPSDArr3, TmpRangeArr3, TmpMeanPSDArr3, TmpMeanPowerArr3  ] =               ...
             func_CalSpectraInfo_Decode4CLP_SpectrumAna4GIR( ...
             du{FitChannel4DPL}, FreqArr3, FitChannel4DPL );
     else
         [ TmpPowerArr3, TmpPSDArr3, TmpRangeArr3, TmpMeanPSDArr3, TmpMeanPowerArr3  ] =                  ...
             func_CalSpectraInfoMultiBeam_Decode4CLP_SpectrumAna4GIR(  ...
             du{FitChannel4DPL}, FreqArr3, FitChannel4DPL );
     end%if BeamNum == 1

    if Iint == 1
        PowerArr3       = {TmpPowerArr3};
        PSDArr3         = {TmpPSDArr3}; 
        MeanPSDArr3     = {TmpMeanPSDArr3};
        MeanPowerArr3   = {TmpMeanPowerArr3};
    else
        PowerArr3    	= [ PowerArr3; {TmpPowerArr3} ];
        PSDArr3         = [ PSDArr3, {TmpPSDArr3} ];
        MeanPSDArr3     = [ MeanPSDArr3,{TmpMeanPSDArr3} ];
        MeanPowerArr3   = [ MeanPSDArr3, {TmpMeanPowerArr3} ];
    end
 
end%for Iint = 1:1:CountData

%------
% PLOT
%------
%%
%% PSD: color-coded frequency-range profile at each time
%%
h1 =  figure( 'Position', [ 100 100 600 800 ] );
 func_PlotPSD4CLP_SpectrumAna4GIR(                                  ...
     years, months, days, hours, minutes, seconds, nseconds, ...
     PSDArr1, PSDArr2, PSDArr3, FreqArr1, FreqArr2, FreqArr3,       ...
     Noise4PSDArr1, Noise4PSDArr2, Noise4PSDArr3,                   ...
     RangeArr1, Iint );
 
     
%%
%% Power: color-coded time-range profile
%%
%  figure( 'Position', [ 100 100 600 800 ] )
%  func_PlotPower4CLP_SpectrumAna4GIR(                                ...
%      years, months, days, hours, minutes, seconds, nseconds, ...
%      PowerArr1, PowerArr2, PowerArr3,                               ...
%      Noise4Power1, Noise4Power2, Noise4Power3,                      ...
%      RangeArr1 );