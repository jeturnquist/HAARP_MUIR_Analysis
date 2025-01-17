function plotPSDvsFreq4CLP_GIRx( genParam        ...
                               , radarParam      ...
                               , currentData     ...
                               , initParam       ...
                               , Ifile )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       plotPSDvsFreq4CLP_GIRx
%          made by J. Turnquist, GI UAF
%
%          ver.1.0: Aug-9-2009 
%
%       Plot the PSD vs Range for each integration period for coded long
%       pulse data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------
% set global parameters
%------
% global_HaarpMUIRAnalysis;
% global NODISPLAY
% global RUNFROMSCRIPT

for Iint = 1:1:length(currentData.anaData.PSD{1})
    
    scrsz = get(0,'ScreenSize');
    f(Iint) = figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)]);
    
%     if NODISPLAY
%         set(gcf, 'Visible', 'off');
%     end
    
    for beam_idx = 1:1:size(radarParam.beamDir,1) 
 
        %% Build time array
        l = size(currentData.time.hours{1});

        HH = reshape(currentData.time.hours{1},l(1)*l(2),1);
        MM = reshape(currentData.time.minutes{1},l(1)*l(2),1);
        SS = reshape(currentData.time.seconds{1},l(1)*l(2),1);
        UU = reshape(currentData.time.nseconds{1},l(1)*l(2),1);
        
        TimeInSeconds = HH*3600 + MM*60 + SS + UU/1e9;

    %     TickSpacing = RadarParam.IPP(1)/1e4;
    %     TickArr = (0:TickSpacing:length(CurrentData.du_sorted{1}))...
    %         * size(CurrentData.BeamCodes,1)/1e2;

        genParam.timeIdx = 0; %% temporary value
    
        time_idx = genParam.timeIdx;

        if time_idx 
            TickArr = TimeInSeconds(time_idx)-TimeInSeconds(1);
        else
            TickArr = TimeInSeconds - TimeInSeconds(1);
        end

    %     TickSpacing = floor(length(TickArr)/20);
    %     TickSpacing = 1;
    %     TimeTick = TickArr(1:TickSpacing:end);

        StartTime = TimeInSeconds(Iint);
        StartTimeStruct = sec2struct(StartTime);
        StartTimeChar = StartTimeStruct.str;

        %% Build range array
        ssR = genParam.lowerAnaRange;
        eeR = genParam.upperAnaRange;

        rng_idx = find(radarParam.range > genParam.lowerAnaRange & ...
                            radarParam.range < genParam.upperAnaRange);
        rng_spacing = floor(length(rng_idx)/20); 
        if ~rng_spacing, rng_spacing = 1; end 
    %     rng_spcaing = 10;

        RangeTick = radarParam.range(rng_idx(1):rng_spacing:rng_idx(end));
        
        try
            AltCorr   = sind(radarParam.beamDir{beam_idx}(2));
        catch
            AltCorr = 1;
        end

        AltTick   = RangeTick .* AltCorr;


        %%%---------
        %%% PSD vs Range vs Frequency
        %%%---------
%%% temporarly commented out, need multi beam support
%         imagen(FreqArr, radarParam.range(rng_idx).* AltCorr, ...
%                 currentData.anaData.PSD{beam_idx}{Iint}');

        
        %%% parse channels
        ion_idx = find(currentData.fitChannel == 1);
        up_idx  = find(currentData.fitChannel == 2);
        dn_idx  = find(currentData.fitChannel == 3);
        
        %%% Build frequency arrays
        ionFreqArr   = currentData.freqArr{ion_idx};
        ionFreqTick  = ionFreqArr(1:100:end);
        
        upFreqArr   = currentData.freqArr{up_idx};
        upFreqTick  = upFreqArr(1:100:end);
        
        dnFreqArr   = currentData.freqArr{dn_idx};
        dnFreqTick  = dnFreqArr(1:100:end);
        
        %%% Generate title
        sd = [initParam.expDate, '/', genParam.selFileNames(Ifile,:)];

        
       %%% 
       %%% Channel 1: Ion Line
       %%%
        subplot(3,1,1)
        imagen(ionFreqArr, radarParam.range(rng_idx).* AltCorr, ...
                currentData.anaData.PSD{ion_idx}{Iint}');

        %%% x-axis
    %     set(gca, 'XTick', [0:100:length(CurrentData.du_sorted{beam_idx})]);
    %     set(gca, 'XTickLabel', TimeTick);
        set(gca, 'YAxisLocation', 'right')
        
        title({['\bf\fontsize{12}TEST Selected Data: ', sd]; ...
               ['\bf\fontsize{10}Power Spectral Density (dB)    Time: ', ...
                 StartTimeChar,' UT']; ...
               ['Channel 1: Ion Line']})
        xlabel(['Frequency Offset (MHz)']);

        %%% Firs y-axis: Range (km)
        set(gca, 'Ylim', [AltTick(1) AltTick(end)])
%        set(gca, 'YTick', AltTick);
%        set(gca, 'YTickLabel', ceil(AltTick/100)/10);
        ylabel({['Altitude (km)'];['']});
        colormap(jet);
        colorbar('location', 'eastoutside');    
 %       caxis([30 50]);

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
 %       set(ax(2), 'YTick', RangeTick);
%        set(ax(2), 'YTickLabel', ceil(RangeTick/100)/10);
        ylabel(ax(2), ['Range (km)']);

        
        
       %%% 
       %%% Channel 2: Upshifted Plasma Line
       %%%
        subplot(3,1,2)
        imagen(upFreqArr, radarParam.range(rng_idx).* AltCorr, ...
                currentData.anaData.PSD{up_idx}{Iint}');
        set(gca, 'YAxisLocation', 'right')
        
        title(['Channel 2: Upshifted Plasma Line'])
        xlabel(['Frequency Offset (MHz)']);

        %%% Firs y-axis: Range (km)
        set(gca, 'Ylim', [AltTick(1) AltTick(end)])
%        set(gca, 'YTick', AltTick);
%        set(gca, 'YTickLabel', ceil(AltTick/100)/10);
        ylabel({['Altitude (km)'];['']});
        colormap(jet);
        colorbar('location', 'eastoutside');    
%         caxis([30 50]);

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
%         set(ax(2), 'YTick', RangeTick);
%         set(ax(2), 'YTickLabel', ceil(RangeTick/100)/10);
        ylabel(ax(2), ['Range (km)']);
        
        
        
        
       %%% 
       %%% Channel 3: Downshiftd Plamsa Line
       %%%
        subplot(3,1,3)
        imagen(dnFreqArr, radarParam.range(rng_idx).* AltCorr, ...
                currentData.anaData.PSD{dn_idx}{Iint}');
        set(gca, 'YAxisLocation', 'right')
        
        title(['Channel 3: Downshifted Plasma Line'])
        
        xlabel(['Frequency Offset (MHz)']);

        %%% Firs y-axis: Range (km)
        set(gca, 'Ylim', [AltTick(1) AltTick(end)])
%        set(gca, 'YTick', AltTick);
%        set(gca, 'YTickLabel', ceil(AltTick/100)/10);
        ylabel({['Altitude (km)'];['']});
        colormap(jet);
        colorbar('location', 'eastoutside');    
%         caxis([30 50]);

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
%         set(ax(2), 'YTick', RangeTick);
%         set(ax(2), 'YTickLabel', ceil(RangeTick/100)/10);
        ylabel(ax(2), ['Range (km)']);


        %%%---------
        %%% Save figure
        %%%---------

        savePlot( gcf                  ...
                     , currentData          ...
                     , genParam             ...
                     , radarParam           ...
                     , initParam           ...
                     , StartTimeStruct.vec );
                 
        close(gcf);

    end %for beam_idx
end %for Iint