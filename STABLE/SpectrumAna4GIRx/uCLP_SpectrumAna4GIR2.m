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
 AnaStyle              = 1;%0: use all data file in the selected directory
                           %1: select a data by user
 MemorySaver           = 1;
                          
 func_InputGeneralParam4CLP_SpectrumAna4GIR;
 
 if AnaStyle == 1
    CountData = length(SelDataExtNum4GIR);
 elseif AnaStyle == 0
    CountData = CountDataNum4GIR;  
 end                          

%------
% read experiment setup file
%------
%%% global parameters
% PulseLength          : pulse length (micro-second)
% SamplingRate         : sampling rate (kHz)
% StartTime4Tx         : start time of Tx (micro-second)
% StartTime4Rx         : start time of Rx (micro-second)
% BeamNum              : beam number
% BeamAngleX(Y)        : beam-direction angle
% DCKNum               : Down Converter Knob value (MHz)
%------
 func_ReadExpSetupFile4uCLP_SpectrumAna4GIR;

%------
% check the GI receiver channel
%  global: ChannelType
%            I: ion line  D: down-shifted plasma line
%                         U: up-shifted plasma line
%------
 func_CheckChannel_SpectrumAna4GIR;
 
 
%------
% calibrate the range
%------
%%% looking for a receiver channel for the ion-line measurement
 FitChannel4IL   = findstr(ChannelType,'I');
% FitChannel4IL   = 1;%temporal to prepare progrums for multi-beam
 FitChannel4IL   = FitChannel4IL(1);
 
 
%%% estimate the offset value in the range
 [ hdr1, rhdr1, dp1, du1, cp1, np1,                 ...
   years1, months1, days1,                          ...
   hours1, minutes1, seconds1, nseconds1, freq1 ] = ...
   sdrrad(DataFileName4GIR,FitChannel4IL,2);
 

for Iint = 1:1:CountData

    func_DataFileName4GIR_SpectrumAna4GIR(Iint);

  	DataExtChar = num2str(SelDataExtNum4GIR(Iint));
    DataChar = [ '  # Data extension: ', DataExtChar ];
    disp(DataChar);
    
    %------
    % read radar data
    %------
    %%% for channel 1
     disp( '   Reading data from the channel 1 ...' );
     [ hdr1, rhdr1, dp1, du1, cp1, np1,                 ...
       Tmpyears1, Tmpmonths1, Tmpdays1,                          ...
       Tmphours1, Tmpminutes1, Tmpseconds1, Tmpnseconds1, freq1 ] = ...
       sdrrad(DataFileName4GIR,1,1);

	if Iint == 1 | MemorySaver
        years1       = {Tmpyears1};
        months1      = {Tmpmonths1};
        days1        = {Tmpdays1};
        hours1       = {Tmphours1};
        minutes1     = {Tmpminutes1};
        seconds1     = {Tmpseconds1};
        nseconds1    = {Tmpnseconds1};
    elseif Init > 1 & ~MemorySaver
        years1       = [ years1,     {Tmpyears1} ];
        months1      = [ months1,    {Tmpmonths1}] ;
        days1        = [ days1,      {Tmpdays1} ];
        hours1       = [ hours1,     {Tmphours1} ];
        minutes1     = [ minutes1,   {Tmpminutes1} ];
        seconds1     = [ seconds1,   {Tmpseconds1} ];
        nseconds1    = [ nseconds1,  {Tmpnseconds1} ];
	end
       
    %%% for channel 2
     disp( '   Reading data from the channel 2 ...' );
     [ hdr2, rhdr2, dp2, du2, cp2, np2,                 ...
       Tmpyears2, Tmpmonths2, Tmpdays2,                          ...
       Tmphours2, Tmpminutes2, Tmpseconds2, Tmpnseconds2, freq2 ] = ...
       sdrrad(DataFileName4GIR,2,1);

    %%% for channel 3
     disp( '   Reading data from the channel 3 ...' );
     [ hdr3, rhdr3, dp3, du3, cp3, np3,                 ...
       Tmpyears3, Tmpmonths3, Tmpdays3,                          ...
       Tmphours3, Tmpminutes3, Tmpseconds3, Tmpnseconds3, freq3 ] = ...
       sdrrad(DataFileName4GIR,3,1);

    %------
    % calculate array of the frequency in the spectrum
    %------
    %%% for the channel 1
     [ FreqArr1 ] = func_CalFreqArr4uCLP_SpectrumAna4GIR(freq1);

    %%% for the channel 2
     [ FreqArr2 ] = func_CalFreqArr4uCLP_SpectrumAna4GIR(freq2);

    %%% for the channel 3
     [ FreqArr3 ] = func_CalFreqArr4uCLP_SpectrumAna4GIR(freq3);



    %------
    % calculate the noise level
    %------
    %%% for the channel 1
     [ Noise4PSDArr1, Noise4Power1 ] = ...
         func_CalNoize4uCLP_SpectrumAna4GIR(du1);


    %%% for the channel 2
     [ Noise4PSDArr2, Noise4Power2 ] = ...
         func_CalNoize4uCLP_SpectrumAna4GIR(du2);


    %%% for the channel 3
     [ Noise4PSDArr3, Noise4Power3 ] = ...
         func_CalNoize4uCLP_SpectrumAna4GIR(du3);
     

%%
    if CalBit == 1 | CalBit == 3
        %------
        % calculate SNR, Power Spectra Density
        %  integrated from "LowerRange4Ana" 
        %               to "UpperRange4Ana"
        %------
        %%% for the channel 1
         disp( '   Calculating SNR, Power Spectra Density from the channel 1 ...' );
         ChannelNum  = 1;
         if BeamNum == 1
             [ PowerArr1, PSDArr1, RangeArr1 ] =                  ...
                 func_CalSpectraInfo4uCLP_SpectrumAna4GIR(  ...
                 du1, FreqArr1, ChannelNum );
         else
             [ PowerArr1, PSDArr1, RangeArr1 ] =                  ...
                 func_CalSpectraInfoMultiBeam4uCLP_SpectrumAna4GIR(  ...
                 du1, FreqArr1, ChannelNum );
         end%if BeamNum == 1
         
         
        %%% for the channel 2
         disp( '   Calculating SNR, Power Spectra Density from the channel 2 ...' );
         ChannelNum  = 2;
         if BeamNum == 1
             [ PowerArr2, PSDArr2, RangeArr2 ] =                 ...
                 func_CalSpectraInfo4uCLP_SpectrumAna4GIR( ...
                 du2, FreqArr2, ChannelNum );
         else
             [ PowerArr2, PSDArr2, RangeArr2 ] =                  ...
                 func_CalSpectraInfoMultiBeam4uCLP_SpectrumAna4GIR(  ...
                 du2, FreqArr2, ChannelNum );
         end%if BeamNum == 1
         
        
        %%% for the channel 3
         disp( '   Calculating SNR, Power Spectra Density from the channel 3 ...' );
         ChannelNum  = 3;
         if BeamNum == 1
             [ PowerArr3, PSDArr3, RangeArr3 ] =               ...
                 func_CalSpectraInfo4uCLP_SpectrumAna4GIR( ...
                 du3, FreqArr3, ChannelNum );
         else
             [ PowerArr3, PSDArr3, RangeArr3 ] =                  ...
                 func_CalSpectraInfoMultiBeam4uCLP_SpectrumAna4GIR(  ...
                 du3, FreqArr3, ChannelNum );
         end%if BeamNum == 1

        %%
%% PSD vs Range: color-coded frequency-range profile at each time
%%
     figure( 'Position', [ 100 100 600 800 ] )
     func_PlotPSD4CLP_SpectrumAna4GIR(                                  ...
         years1, months1, days1, hours1, minutes1, seconds1, nseconds1, ...
         PSDArr1, PSDArr2, PSDArr3, FreqArr1, FreqArr2, FreqArr3,       ...
         Noise4PSDArr1, Noise4PSDArr2, Noise4PSDArr3,                   ...
         RangeArr1 );
 
     
%%
%% Power: color-coded time-range profile
%%
     figure( 'Position', [ 100 100 600 800 ] )
     func_PlotPower4CLP_SpectrumAna4GIR(                                ...
         years1, months1, days1, hours1, minutes1, seconds1, nseconds1, ...
         PowerArr1, PowerArr2, PowerArr3,                               ...
         Noise4Power1, Noise4Power2, Noise4Power3,                      ...
         RangeArr1 );
     
     
    elseif CalBit == 2 | CalBit == 3
        
%%
        %------
        % calculate PSD vs Time
        %  integrated from "LowerRange4Ana" 
        %               to "UpperRange4Ana"
        %------
        %%% for the channel 1
         disp( '   Calculating SNR, Power Spectra Density from the channel 1 ...' );
         ChannelNum  = 1;
         [ TmpPowervsTimeArr1, TmpPSDvsTimeArr1, RangeArr1 ] =                   ...
               func_CalSpectraInfo4uCLP_SpectrumVsTime4GIR(  ...
               du1, FreqArr1, ChannelNum );
           
         if Iint == 1 | MemorySaver
            PowervsTimeArr1   	= {TmpPowervsTimeArr1};
            PSDvsTimeArr1      	= {TmpPSDvsTimeArr1};
         elseif Init > 1 & ~MemorySaver
            PowervsTimeArr1   	= [ PowervsTimeArr1; {TmpPowervsTimeArr1} ];
            PSDvsTimeArr1   	= [ PSDvsTimeArr1, {TmpPSDvsTimeArr1} ];
         end
         
        %%% for the channel 2
         disp( '   Calculating SNR, Power Spectra Density from the channel 2 ...' );
         ChannelNum  = 2;
         [ TmpPowervsTimeArr2, TmpPSDvsTimeArr2, RangeArr2 ] =                   ...
               func_CalSpectraInfo4uCLP_SpectrumVsTime4GIR(  ...
               du2, FreqArr2, ChannelNum );
           
         if Iint == 1 | MemorySaver
            PowervsTimeArr2     = {TmpPowervsTimeArr2};
            PSDvsTimeArr2       = {TmpPSDvsTimeArr2};
         elseif Init > 1 & ~MemorySaver
            PowervsTimeArr2     = [ PowervsTimeArr2; {TmpPowervsTimeArr2} ];
            PSDvsTimeArr2       = [ PSDvsTimeArr2, {TmpPSDvsTimeArr2} ];
         end

        %%% for the channel 3
         disp( '   Calculating SNR, Power Spectra Density from the channel 3 ...' );
         ChannelNum  = 3;
         [ TmpPowervsTimeArr3, TmpPSDvsTimeArr3, RangeArr3 ] = 	...
               func_CalSpectraInfo4uCLP_SpectrumVsTime4GIR(     ...
               du3, FreqArr3, ChannelNum );
           
         if Iint == 1 | MemorySaver
            PowervsTimeArr3     = {TmpPowervsTimeArr3};
            PSDvsTimeArr3       = {TmpPSDvsTimeArr3};
         elseif Init > 1 & ~MemorySaver
            PowervsTimeArr3 	= [ PowervsTimeArr3; {TmpPowervsTimeArr3} ];
            PSDvsTimeArr3      	= [ PSDvsTimeArr3, {TmpPSDvsTimeArr3} ];
         end
        
        
%%
%% PSD vs Time: color-coded frequency-time profile
%%    
        if MemorySaver
            figure( 'Position', [ 100 100 600 800 ] )
            func_PlotPSDvsTime4uCLP_SpectrumAna4GIR( ...
                PSDvsTimeArr1, PSDvsTimeArr2, PSDvsTimeArr3         ...
                , FreqArr1, FreqArr2, FreqArr3                      ...
                , hours1 , minutes1, seconds1, nseconds1)
         end
    end%if CalBit

end%for Iint = 1:1:CountData


% %------
% % PLOT
% %------
if ~MemorySaver
%%
%% PSD vs Time: color-coded frequency-time profile
%%    
    figure( 'Position', [ 100 100 600 800 ] )
    func_PlotPSDvsTime4uCLP_SpectrumAna4GIR( ...
        PSDvsTimeArr1, PSDvsTimeArr2, PSDvsTimeArr3 ...
      	, FreqArr1, FreqArr2, FreqArr3              ...
        , hours1 , minutes1, seconds1, nseconds1)
    
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
end