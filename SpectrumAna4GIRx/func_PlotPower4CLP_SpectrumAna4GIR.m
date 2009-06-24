%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_PlotPower4CLP_SpectrumAna4GIR
%          made by S. Oyama, GI UAF
%
%          ver.1.0: Jul-21-2006
%          ver.2.0: Aug-02-2006: update for multi-beam
%                                 (previous version:***-0.m)
%          ver.2.1: May-23-2008: added iteration over data extentions
%                                   J.Turnquist
%
%          # make image plot of Power at each channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function func_PlotPower4CLP_SpectrumAna4GIR(                     ...
         Tmpyears, Tmpmonths, Tmpdays, Tmphours, Tmpminutes, ...
         Tmpseconds, Tmpnseconds, ...
         TmpPowerArr1, TmpPowerArr2, TmpPowerArr3,                        ...
         TmpNoise4Power1, TmpNoise4Power2, TmpNoise4Power3,               ...
         TmpRangeArr )
     
         
%------
% set global parameters
%------
 global_SpectrumAna4GIR;

 
NumDataExt  = length(TmpPowerArr1); 
 
%------
% iteration over data extention
%------
for Iext = 1:NumDataExt 
     %------
     % Convert time cell arrays to matrices
     %------

     years           = Tmpyears{1}{Iext};
     months          = Tmpmonths{1}{Iext};
     days            = Tmpdays{1}{Iext};
     hours           = Tmphours{1}{Iext};
     minutes         = Tmpminutes{1}{Iext};
     seconds         = Tmpseconds{1}{Iext};
     nseconds        = Tmpnseconds{1}{Iext}; 


     PowerArr1      = TmpPowerArr1{Iext};
     PowerArr2      = TmpPowerArr2{Iext};
     PowerArr3      = TmpPowerArr3{Iext};


     Noise4Power1 	= TmpNoise4Power1{Iext};
     Noise4Power2 	= TmpNoise4Power2{Iext};
     Noise4Power3 	= TmpNoise4Power3{Iext};

     RangeArr       = TmpRangeArr{Iext};

    % years           = Tmpyears{1};
    % months          = Tmpmonths{1};
    % days            = Tmpdays{1};
    % hours           = Tmphours{1};
    % minutes         = Tmpminutes{1};
    % seconds         = Tmpseconds{1};
    % nseconds        = Tmpnseconds{1};

    %------
    % set parameters
    %------
     OrgTimeNum  = length(years);
     TimeNum     = length(PowerArr1(:,1));
     RangeNum    = length(RangeArr);
     ChannelNum  = 3;


    %------
    % prepare the time array
    %------
    %%% set start time
     HH     = num2str(hours(1));
     MM     = num2str(minutes(1));
     SS     = num2str(seconds(1));

     HH     = func_CheckCharLength(HH,2,'0');
     MM     = func_CheckCharLength(MM,2,'0');
     SS     = func_CheckCharLength(SS,2,'0');
     StartTimeChar   = [ HH, MM, SS ];


    %%% time array
     TimeArr   = seconds - seconds(1) + nseconds/1e9;
     FitTime   = 1:Factor4IntTime:OrgTimeNum;
     TimeArr   = TimeArr(FitTime);
     FitNegative = find( TimeArr < 0 );
     if length(FitNegative) ~= 0
         TimeArr(FitNegative) = TimeArr(FitNegative) + 60;
     end%if length(FitNegative) ~= 0

    %------
    % iteration over BeamNum
    %------
     for Ibeam = 1:BeamNum
         %------
         % iteration over channel
         %------
         for Ichannel = 1:ChannelNum
             %------
             % select Power
             %------
             SelPowerArr     = [];
             SelNoise        = [];
             switch Ichannel
                 case 1
                     if BeamNum == 1
                         SelPowerArr = PowerArr1;
                     else
                         SelPowerArr(:,:) = PowerArr1(Ibeam,:,:);
                     end%if BeamNum == 1
                     SelNoise     = mean(Noise4Power1);
                 case 2
                     if BeamNum == 1
                         SelPowerArr = PowerArr2;
                     else
                         SelPowerArr(:,:) = PowerArr2(Ibeam,:,:);
                     end%if BeamNum == 1
                     SelNoise     = mean(Noise4Power2);
                 case 3
                     if BeamNum == 1
                         SelPowerArr = PowerArr3;
                     else
                         SelPowerArr(:,:) = PowerArr3(Ibeam,:,:);
                     end%if BeamNum == 1
                     SelNoise     = mean(Noise4Power3);
             end%switch Ichannel


             %------
             % arrange range array
             %------
    %          if Ichannel == 1
                 FitRange   = find( RangeArr >= LowerRange4Ana & ...
                                    RangeArr <= UpperRange4Ana );
                 RangeArr   = RangeArr(FitRange);
    %          end%if Ichannel == 1


             %%% y-tick mark for the range
             MaxTickNum       = 5;
             IntegerRangeArr  = unique(fix(RangeArr));
             TmpNum           = length( IntegerRangeArr );
             ytickvarr        = IntegerRangeArr;
             ytickcrarr       = [];
             if TmpNum > MaxTickNum
                 TmpSkip     = ceil(TmpNum/MaxTickNum);
                 ytickvarr   = ytickvarr(1:TmpSkip:end);
                 TmpNum      = length(ytickvarr);
             end%if TmpNum > MaxTickNum
             for Iy = 1:TmpNum
                 TmpChar     = num2str(ytickvarr(Iy));
                 ytickcrarr  = [ ytickcrarr, {TmpChar} ];
             end%for Iy
             ytickcrarr_s    = ytickcrarr;
             ytickvarr4Range = ytickvarr;
             ytickcrarr4Range   = ytickcrarr;




             %------
             % prepare altitude array
             %------
             AltArr    = RangeArr * cos(abs(BeamAngleX(Ibeam))/180*pi) ...
                                  * cos(abs(BeamAngleY(Ibeam))/180*pi);


             %%% y-axis range for the altitude
             mvaluey4Alt   = [ min(AltArr), max(AltArr) ];
    %          mvaluey4Alt   = [ 194 199 ];


             %%% y-tick mark for the altitude
             IntegerRangeArr  = ceil(mvaluey4Alt(1)):fix(mvaluey4Alt(end));
             TmpNum           = length( IntegerRangeArr );
             ytickvarr        = IntegerRangeArr;
             ytickcrarr       = [];
             if TmpNum > MaxTickNum
                 TmpSkip   = ceil(TmpNum/MaxTickNum);
                 ytickvarr = ytickvarr(1:TmpSkip:end);
                 TmpNum    = length(ytickvarr);
             end%if TmpNum > MaxTickNum
             for Iy = 1:TmpNum
                 TmpChar     = num2str(ytickvarr(Iy));
                 ytickcrarr  = [ ytickcrarr, {TmpChar} ];
             end%for Iy
             ytickcrarr_s    = ytickcrarr;
             ytickcrarr_s(end) = [];
             ytickvarr4Alt    = ytickvarr;
             ytickcrarr4Alt   = ytickcrarr;
             ytickcrarr_s4Alt = ytickcrarr_s;




             %------
             % select Power array
             %------
             if BeamNum == 1
                 SelPowerArr   = SelPowerArr(:,FitRange);
             end%if BeamNum == 1


             %------
             % adjust noise arrays
             %------
             TmpSize       = size(SelPowerArr);
             SelNoiseArr   = repmat(SelNoise,TmpSize(1),TmpSize(2));


             %------
             % calculate the relative value
             %------
%              SelPowerArr      = SelPowerArr./SelNoiseArr;


             %------
             % Power in dB
             %------
             FitNoneZero               = find( SelPowerArr > 0 );
             SelPowerArr(FitNoneZero)  = 10 * log10(SelPowerArr(FitNoneZero));



             %------
             % set axis parameters
             %------
             mvaluex    = [ fix(min(TimeArr)) ceil(max(TimeArr)) ];
             mvaluey    = [ LowerRange4Ana, UpperRange4Ana ];



             %------
             % image
             %------
             %%% subplot
             subplot( 3,1,Ichannel );


             %%% set axis-control parameters for the altitude
             h        = line( [TimeArr(1), TimeArr(end)]-1000    ...
                            , [AltArr(1), AltArr(end)]-1000);
             ax4alt   = gca;
             set( ax4alt, 'XColor', 'k', 'YColor', 'k' )


             %%% image
             imagen( TimeArr, RangeArr, SelPowerArr' )


             %%% x-axis
             if Ichannel == 3
                 TmpChar   = [ 'Seconds from ' StartTimeChar ' UT' ];
                 xlabel( TmpChar );
             end%if Ichannel == 3

             if length(TimeArr) == 1
                 IntegerRangeArr = 1;
             else
                 IntegerRangeArr  = unique(fix(TimeArr));
                 IntegerRangeArr  = ceil(TimeArr(1)):fix(TimeArr(end));
             end
             
             xtickvarr        = (IntegerRangeArr(1):IntegerRangeArr(end));
             TmpNum           = length(xtickvarr);
             xtickcrarr       = [];
             for Ix = 1:TmpNum
                 TmpChar     = num2str(xtickvarr(Ix));
                 xtickcrarr  = [ xtickcrarr, {TmpChar} ];
             end%for Ix
             xtickcrarr_s    = xtickcrarr;
             xtickcrarr_s(:) = [];
             xlim(mvaluex);
             set( gca               ...
                 , 'XTick'           ...
                 , xtickvarr         ...
                 , 'XTickLabel'      ...
                 , xtickcrarr )



             %%% y-axis label for the altitude
             if Ichannel == 1
                 ylabel( 'Altitude (km)' )
             end%if Ichannel == 1
             set( gca               ...
                , 'YTick'           ...
                , ytickvarr4Alt     ...
                , 'YTickLabel'      ...
                , ytickcrarr4Alt )
             ylim( mvaluey4Alt )


             %%% color axis
%              LowerColorValue   = 60;
%              UpperColorValue   = 70;

    %          caxis([ min(SelPowerArr(:)) max(SelPowerArr(:)) ]);
    %                   
    %          switch ChannelType(Ichannel)
    %              case 'I'
    %                  LowerColorValue   = 0;
    %                  UpperColorValue   = 25;
    %              case 'D'
    %                  LowerColorValue   = 0;
    %                  UpperColorValue   = 25;
    %              case 'U'
    %                  LowerColorValue   = 0;
    %                  UpperColorValue   = 25;
    %          end%switch ChannelType(Ichannel)
    
             LowerColorValue = min(SelPowerArr(:));
             UpperColorValue = max(SelPowerArr(:));
             
             if isnan(LowerColorValue) | isnan(UpperColorValue)
                 LowerColorValue   = 60;
                 UpperColorValue   = 70; 
             end
             
             colorbar('Location', 'EastOutside');
             caxis( [LowerColorValue UpperColorValue])



             %%% axis control for the range
             ax4range = axes( 'Position', get(ax4alt,'Position')   ...
                            , 'XAxisLocation', 'top'            ...
                            , 'YAxisLocation', 'right'             ...
                            , 'Color', 'none'                      ...
                            , 'XColor', 'k', 'YColor', 'b');


             %%% calculate the y-axis range for the range
             mvaluey4Range  = mvaluey4Alt                        ...
                            / cos(abs(BeamAngleX(Ibeam))/180*pi) ...
                            / cos(abs(BeamAngleY(Ibeam))/180*pi);


             %%% x-axis
             set( gca               ...
                 , 'XTick'           ...
                 , xtickvarr         ...
                 , 'XTickLabel'      ...
                 , xtickcrarr_s )


             %%% axis-range limitation for the range
             ylim( mvaluey4Range )


             %%% y-axis label for the range
             if Ichannel == 1
                 ylabel( 'Range (km)' )
             end%if Ichannel == 1
             set( gca                 ...
                 , 'YTick'             ...
                 , ytickvarr4Range     ...
                 , 'YTickLabel'        ...
                 , ytickcrarr4Range )



             %%% character (channel #)
             ChannelNumChar  = num2str(Ichannel);
             mvaluex         = xlim;
             mvaluey         = ylim;
             TmpChar         = [ 'Ch.' ChannelNumChar ];
             posx            = mvaluex(2) - (mvaluex(2)-mvaluex(1))*0.10;
             posy            = mvaluey(2) + (mvaluey(2)-mvaluey(1))*0.03;
             text( posx, posy, TmpChar, 'FontSize', 10 );


             %%% title
             if Ichannel == 1
                 yy     = num2str(years(1));
                 mm     = num2str(months(1));
                 dd     = num2str(days(1));

                 yy     = func_CheckCharLength(yy,2,'0');
                 mm     = func_CheckCharLength(mm,2,'0');
                 dd     = func_CheckCharLength(dd,2,'0');
                 DateChar   = [ yy, mm, dd ];

                 IntegrationChar = IPP * Factor4IntTime / 1000;
                 IntegrationChar = [ num2str(IntegrationChar) ' ms' ];

                 TitleChar  = [ 'Start Time (HHMMSS UT): ' StartTimeChar    ...
                              , ' on ' DateChar ' (' IntegrationChar        ...
                              ' Integration)' ];
                 TmpChar   = [ 'Selected Data: ' DataFileName4GIR ];

                 BeamAngleChar  = [ '({\theta}x, {\theta}y): (' ];
                 BeamAngleXChar = num2str(BeamAngleX(Ibeam));
                 BeamAngleYChar = num2str(BeamAngleY(Ibeam));
                 BeamAngleChar  = [ BeamAngleChar, BeamAngleXChar  ...
                                    ', ' BeamAngleYChar ')' ];

                 posx      = mvaluex(1) + ( mvaluex(2) - mvaluex(1) ) * 0.00;
                 posy      = mvaluey(1) - ( mvaluey(2) - mvaluey(1) ) * 0.00;

                 TmpFit    = find( TmpChar == '\' );
                 TmpChar( TmpFit ) = '/';

                 title( {'relative power (dB)', ...
                         TitleChar, [TmpChar '  ' BeamAngleChar]}, ...
                         'FontSize', 7 );
             end%if Ichannel == 1
         end%for Ichannel


         %------
         % color bar
         %------
         %%% position
         Top      = 0.05;
         Height   = 0.02;
         Left     = 0.70;
         Bottom   = Top - Height;
         Width    = 0.20;
         subplot( 'Position', [ Left, Bottom, Width, Height ] )


         %%% new arrays for the color bar
         xarr     = LowerColorValue:UpperColorValue;
         yarr     = [0,1];
         carr     = [xarr; xarr];


         %%% x-axis tick mark
         xticknum   = length(xarr);
         if length(xarr) == 2
             xtickvarr_c = xarr;
         else
             xtickvarr_c  = [ xarr(1), xarr(fix(xticknum/3))           ...
                            , xarr(fix(xticknum/3)*2)                  ...
                            , xarr(end) ];
         end%if length(xarr) == 2
         xtickvarr_c  = unique(xtickvarr_c);
         xtickcrarr_c = [];
         for Ix = 1:length(xtickvarr_c)
             xtickcrarr_c   = [ xtickcrarr_c, {num2str(xtickvarr_c(Ix))} ];
         end%for Ix


         %%% y-axis tick mark
         ytickvarr_c   = 0:1;
         ytickcrarr_c  = [{}, {}];


         %%% image
         imagen( xarr, yarr, carr );


         %%% axis
         set( gca           ...
            , 'XTick'       ...
            , xtickvarr_c   ...
            , 'XTickLabel'  ...
            , xtickcrarr_c )
        set( gca           ...
            , 'YTick'       ...
            , ytickvarr_c   ...
            , 'YTickLabel'  ...
            , ytickcrarr_c )

        %%% title
        TitleChar    = [ 'dB' ];
        title(TitleChar, 'FontSize', 9 )


        %------
        % save as jpg
        %------
        FileNameChar   = [ 'GIR_Power_' DateChar, '.', StartTimeChar ];
        if BeamNum == 1
            FileNameChar = [ FileNameChar, '.jpg' ];
        else
            FileNameChar = [ FileNameChar, '-', num2str(Ibeam), '.jpg' ];
        end%if BeamNum == 1
        print( '-djpeg', FileNameChar );

     end%for Ibeam
end%for Iext