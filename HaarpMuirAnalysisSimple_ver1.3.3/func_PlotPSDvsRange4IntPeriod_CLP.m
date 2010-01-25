function func_PlotPSDvsRange4IntPeriod_CLP( CurrentData     ...
                                          , GenParam        ...
                                          , RadarParam      ...
                                          , InputParam      ...
                                          , Ifile )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_PlotPSDvsRange4IntPeriod_CLP
%          made by J. Turnquist, GI UAF
%
%          ver.1.0: Aug-9-2008 
%
%       Plot the PSD vs Range for each integration period for coded long
%       pulse data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global NODISPLAY
global RUNFROMSCRIPT
global FREQ_SCALE  %%scale the half frequency width by percentage 


for Iint = 1:1:length(CurrentData.PSDArr{1})
    f(Iint) = figure(Iint);
    
    if NODISPLAY
        set(gcf, 'Visible', 'off');
    end
    
    for beam_idx = 1:1:size(CurrentData.BeamCodes,1) 

        %% Build time array
        l = size(CurrentData.TimeArrOfHour{1});

        HH = reshape(CurrentData.TimeArrOfHour{1},l(1)*l(2),1);
        MM = reshape(CurrentData.TimeArrOfMinute{1},l(1)*l(2),1);
        SS = reshape(CurrentData.TimeArrOfSecond{1},l(1)*l(2),1);

        TimeInSeconds = HH*3600 + MM*60 + SS;

        time_idx = GenParam.TimeIdx;

        if time_idx 
            StartTime = TimeInSeconds(time_idx);
            StartTime = StartTime((Iint-1)*GenParam.Factor4IntTime+1);
        else
            StartTime = TimeInSeconds((Iint-1)*GenParam.Factor4IntTime+1);
        end

        StartTimeStruct = sec2struct(StartTime);
        StartTimeChar = StartTimeStruct.str;

        %% Build range array
        ssR = GenParam.LowerHeight;
        eeR = GenParam.UpperHeight;

        rng_idx = find(CurrentData.Range > GenParam.LowerHeight*1000 & ...
                            CurrentData.Range < GenParam.UpperHeight*1000);
        rng_spacing = floor(length(rng_idx)/20); 
        if ~rng_spacing, rng_spacing = 1; end 
    %     rng_spcaing = 10;

        RangeTick = CurrentData.Range(rng_idx(1):rng_spacing:rng_idx(end));
        
        try
            AltCorr   = sind(RadarParam.BeamDir{beam_idx}(2));
        catch
            AltCorr = 1;
        end

        AltTick   = RangeTick .* AltCorr;

        %% Build frequency array
        FreqArr   = CurrentData.FreqArr;
        len         = length(FreqArr);
        if FREQ_SCALE
            FreqWidth(1:2)   = ceil((len/2)*FREQ_SCALE); %% Half width of frequency, scale is a percent
            FreqArr     = FreqArr(FreqWidth:end-FreqWidth);
        else
            FreqWidth(1) = 1;
            FreqWidth(2) = 0;
        end
        FreqTick    = FreqArr(1:100:end);


        %%%---------
        %%% PSD vs Range
        %%%---------

        imagen(FreqArr, CurrentData.Range(rng_idx).* AltCorr, ...
                CurrentData.PSDinDBArr{beam_idx}{Iint}(FreqWidth(1):end-FreqWidth(2), :)');

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
        
        IntegartionTimeChar = num2str(GenParam.Factor4IntTime* ...
            RadarParam.IPP*1e-3);
        
        title({['\bf\fontsize{12}Selected Data: ', sd]; ...
               ['\bf\fontsize{10}Power Spectral Density (dB)    Time: ', ...
                 StartTimeChar,' UT', '   Integration: ' ...
                 , IntegartionTimeChar, ' (ms)']})
        xlabel(['Frequency Offset (MHz)']);

        %%% Firs y-axis: Range (km)
        set(gca, 'YTick', AltTick);
        set(gca, 'YTickLabel', ceil(AltTick/100)/10);
        ylabel({['Altitude (km)'];['']});
        colormap(jet);
        colorbar('location', 'eastoutside');    
        caxis([40 50]);

        %%% Second y-axis; Altitude; range corrected for beam elevation (km)     
        ax(1) = gca(f(Iint));
        ax1hv = get(ax(1),'HandleVisibility');
        ax(2) = axes('HandleVisibility',ax1hv,'Units',get(ax(1),'Units'),...
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
        %%% Save figure
        %%%---------

        func_SavePlot( gcf                  ...
                     , CurrentData          ...
                     , GenParam             ...
                     , RadarParam           ...
                     , InputParam           ...
                     , StartTimeStruct.vec );
                 
        close(gcf);

    end %for beam_idx
end %for Iint