function func_PlotSNRandPSDvsTime( CurrentData  ...
                                 , GenParam     ...
                                 , RadarParam   ...
                                 , InputParam   ...
                                 , Ifile )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_PlotSNRandPSDvsTime
%          made by J. Turnquist, GI UAF
%
%          ver.1.0: July-28-2008 
%          ver.1.1: Aug-7-2008, Added altitude scale to second y-axis
%                               Fixed time scale
%                               Added save function
%       Plot the SNR and PSD vs Time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------
% set global parameters
%------
global NODISPLAY
global FREQ_SCALE  %%scale the half frequency width by percentage 

for beam_idx = 1:1:size(CurrentData.BeamCodes,1) 
    
    %% Build time array
    l = size(CurrentData.TimeArrOfHour{1});

    HH = reshape(CurrentData.TimeArrOfHour{1},l(1)*l(2),1);
    MM = reshape(CurrentData.TimeArrOfMinute{1},l(1)*l(2),1);
    SS = reshape(CurrentData.TimeArrOfSecond{1},l(1)*l(2),1);
    
    TimeInSeconds = HH*3600 + MM*60 + SS;
    
%     TickSpacing = RadarParam.IPP(1)/1e4;
%     TickArr = (0:TickSpacing:length(CurrentData.du_sorted{1}))...
%         * size(CurrentData.BeamCodes,1)/1e2;
    
    time_idx = GenParam.TimeIdx;
    
    if time_idx 
        TickArr = TimeInSeconds(time_idx)-TimeInSeconds(1);
    else
        TickArr = TimeInSeconds - TimeInSeconds(1);
    end
    
%     TickSpacing = floor(length(TickArr)/20);
%     TickSpacing = 1;
%     TimeTick = TickArr(1:TickSpacing:end);
    
    StartTime = TimeInSeconds(1);
    StartTimeStruct = sec2struct(StartTime);
    StartTimeChar = StartTimeStruct.str;
    
    %% Build range array
    ssR = GenParam.LowerHeight;
    eeR = GenParam.UpperHeight;

    rng_idx = find(CurrentData.Range > GenParam.LowerHeight*1000 & ...
                        CurrentData.Range < GenParam.UpperHeight*1000);
    rng_spacing = floor(length(rng_idx)/10); 
%      rng_spcaing = 10;

     RangeTick = CurrentData.Range(rng_idx(1):rng_spacing:rng_idx(end));
    
    try
        AltCorr   = sind(RadarParam.BeamDir{beam_idx}(2));
    catch
        AltCorr = 1;
    end
    
     AltTick   = RangeTick .* AltCorr;
%     alt_idx = rng_idx .* AltCorr;
%     AltTick = rng_idx .* AltCorr;
    %% Build frequency array
    FreqArr     = CurrentData.FreqArr;
    len         = length(FreqArr);
    if FREQ_SCALE
        FreqWidth(1:2)   = ceil((len/2)*FREQ_SCALE); %% Half width of frequency, scale is a percent
        FreqArr     = FreqArr(FreqWidth:end-FreqWidth);
    else
        FreqWidth(1) = 1;
        FreqWidth(2) = 0;
    end
    FreqTick    = FreqArr(1:100:end);

    %% Plot SNR and PSD as subplots 
    f1 = figure(beam_idx);

    if NODISPLAY
        set(gcf, 'Visible', 'off');
    end
    
    %%%---------
    %%% SNR
    %%%---------
    subplot(2,1,1);
    imagen(TickArr, CurrentData.Range(rng_idx).* AltCorr, ...
            CurrentData.SNRinDBArr{beam_idx});

    %%% x-axis
%     set(gca, 'XTick', [0:100:length(CurrentData.du_sorted{beam_idx})]);
%     set(gca, 'XTickLabel', TimeTick);
    set(gca, 'YAxisLocation', 'right')
    
    FileChar   = fullfile( InputParam.Directory4MUIRData            ...
                      , GenParam.SelectedDirChar                    ...
                      , GenParam.SelectedFileNames{Ifile});

    tmpchar = FileChar(end-15:end);

    if ispc
        sd = [FileChar(end-27:end-16), '\',tmpchar];
    else
        sd = [FileChar(end-27:end-16), tmpchar];
    end
    
    title({['\bf\fontsize{12}Selected Data: ', sd];...
        ['\bf\fontsize{10}Signal to Noise Ratio (dB)']})
    xlabel(['Time (seconds from ',StartTimeChar,')']);

    %%% Firs y-axis: Range (km)
    set(gca, 'YTick', AltTick);
    set(gca, 'YTickLabel', ceil(AltTick/100)/10);
    ylabel({['Altitude (km)'];['']});
    colormap(jet);
    colorbar('location', 'eastoutside');    
    
    %%% Second y-axis; Altitude; range corrected for beam elevation (km)     
    ax(1) = gca(f1);
    ax1hv = get(ax(1),'HandleVisibility');
    ax(2) = axes('HandleVisibility',ax1hv,'Units',get(ax(1),'Units'), ...
        'Position',get(ax(1),'Position'),'Parent',get(ax(1),'Parent'));
    set(ax(2),'YAxisLocation','left','Color','none', ...
          'XGrid','off','YGrid','off','Box','off');
      
    set(ax(2), 'XTickLabel', 'off')
    set(ax(2), 'XTick', [])
    
    set(ax(2),'YLim',[RangeTick(1), RangeTick(end)]);
    set(ax(2), 'YTick', RangeTick);
    set(ax(2), 'YTickLabel', ceil(RangeTick/100)/10);
    ylabel(ax(2), ['Range (km)']);

 
    %%%---------
    %%% PSD
    %%%---------
    subplot(2,1,2);

    imagen(TickArr, FreqArr, ...
            CurrentData.PSDinDBArr{beam_idx}(FreqWidth(1):end-FreqWidth(2), :));

    %%% x-axis
%     set(gca, 'XTick', [0:100:length(CurrentData.du_sorted{beam_idx})]);
%     set(gca, 'XTickLabel', TimeTick);

    title(['\bfPower Spectral Density (dB)']);
    xlabel(['Time (seconds from ',StartTimeChar, ')']);
    ylabel(['Frequency Offset (MHz)']);
    %%% y-axis
%     set(gca, 'YTick', FreqTick);
%     set(gca, 'YTickLabel', FreqTick);

    colormap(jet);
    colorbar;
   
    %%%---------
    %%% Save figure
    %%%---------
    TimeNum(1) = TickArr(1);
    TimeNum(2) = TickArr(end);
    if ~TimeNum(1)
        TmpChar1.vec = '00000';
    else
        TmpChar1 = sec2struct(TimeNum(1));
    end
    TmpChar2 = sec2struct(TimeNum(2));
    TimeChar  = [TmpChar1.vec(5:end),'-',TmpChar2.vec(5:end)];
    
    func_SavePlot( gcf          ...
                 , CurrentData  ...
                 , GenParam     ...
                 , RadarParam   ...
                 , InputParam   ...
                 , TimeChar);
             
    close(gcf);
    
end %for beam_idx