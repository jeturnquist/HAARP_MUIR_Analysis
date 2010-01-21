%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       plotPSD4CLP_GIRx
%          made by S. Oyama, GI UAF
%
%          ver.1.0: Jul-18-2006
%          ver.2.0: Jul-31-2006: update for multi-beam data
%                                 (previous version:***-2.m)
%          ver.2.1: Aug-02-2006: add altitude
%                                 (previous version:***-3.m)
%          ver.2.2: May-23-2008: added iteration over data extentions
%                                   J.Turnquist
%
%          # make image plot of PSD at each time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotPSD4CLP_GIRx(                           ...
          Tmpyears, Tmpmonths, Tmpdays, Tmphours, Tmpminutes, ...
          Tmpseconds, Tmpnseconds,    ...
          TmpPSDArr1, TmpPSDArr2, TmpPSDArr3, FreqArr1, FreqArr2, FreqArr3,   ...
          TmpNoise4PSDArr1, TmpNoise4PSDArr2, TmpNoise4PSDArr3,      ...
          TmpRangeArr, Iint )
     
         
%------
% set global parameters
%------
 global_SpectrumAna4GIR;
 
 
 
%------
% set parameters
%------
 c           = 2.99792458e8;% speed of light
 fradar      = 446;
 TmpSize     = size(TmpPSDArr1{1});
 TimeNum     = TmpSize(2);
 NumDataExt  = length(TmpPSDArr1); 
 
%------
% iteration over data extention
%------
for Iext = 1:NumDataExt
    %------
    % Convert time cell arrays to matrices
    %------

    PSDArr1             = TmpPSDArr1{Iext};
    PSDArr2             = TmpPSDArr2{Iext};
    PSDArr3             = TmpPSDArr3{Iext};
   
    years               = Tmpyears{Iext};
    months              = Tmpmonths{Iext};
    days                = Tmpdays{Iext};
    hours               = Tmphours{Iext};
    minutes             = Tmpminutes{Iext};
    seconds             = Tmpseconds{Iext};
    nseconds            = Tmpnseconds{Iext};

    orgNoise4PSDArr1 	= TmpNoise4PSDArr1{Iext};
    orgNoise4PSDArr2 	= TmpNoise4PSDArr2{Iext};
    orgNoise4PSDArr3 	= TmpNoise4PSDArr3{Iext};
    
    orgRangeArr         = TmpRangeArr{Iext};
    
    %------
    % iteration over time
    %------
     for Itime = 1:TimeNum
         %------
         % iteration over BeamNum
         %------
         for Ibeam = 1:BeamNum
             %------
             % select PSD & RangeArr
             %------
             if BeamNum == 1
                 SelPSDArr1      = PSDArr1{Itime};
                 SelPSDArr2      = PSDArr2{Itime};
                 SelPSDArr3      = PSDArr3{Itime};
                 RangeArr        = orgRangeArr;
             else
                 SelPSDArr1      = PSDArr1{Ibeam,Itime};
                 SelPSDArr2      = PSDArr2{Ibeam,Itime};
                 SelPSDArr3      = PSDArr3{Ibeam,Itime};

                 %%% select range
                 Range4IPP       = (IPP*1e-6)*c/2 /1e3;
                 RangeArr        = orgRangeArr - Range4IPP*(Ibeam-1);
             end%if BeamNum == 1


             %------
             % select time
             %------

             st              = 1 + Factor4IntTime*(Itime-1);
             CurrentYear     = years{1}(st);
             CurrentMonth    = months{1}(st);
             CurrentDay      = days{1}(st);
             CurrentHour     = hours{1}(st);
             CurrentMinute   = minutes{1}(st);
             CurrentSecond   = seconds{1}(st);
             CurrentNsecond  = nseconds{1}(st);

             %%% shift time by IPP for multi-beam measuerment
             TimeShift       = IPP*(Ibeam-1)*1e3;%nano-second
             CurrentNsecond  = CurrentNsecond + TimeShift;
             if CurrentNsecond ~= mod(CurrentNsecond,1e9)
                 CurrentNsecond = mod(CurrentNsecond,1e9);
                 CurrentSecond  = CurrentSecond + 1;
                 if CurrentSecond >= 60
                     CurrentSecond = CurrentSecond - 60;
                     CurrentMinute = CurrentMinute + 1;
                     if CurrentMinute >= 60
                         CurrentMinute = CurrentMinute - 60;
                         CurrentHour   = CurrentHour + 1;
                         if CurrentHour >= 24
                             CurrentHour = CurrentHour - 24;

                             %%% check date-number
                             CurrentDateNum = ...
                                 datenum(CurrentYear,CurrentMonth,CurrentDay);
                             ShiftDateNum   = CurrentDateNum + 1;
                             ShiftDateChar  = datestr(ShiftDateNum,29);
                             CurrentYear    = str2num(ShiftDateChar(1:4));
                             CurrentMonth   = str2num(ShiftDateChar(6:7));
                             CurrentDay     = str2num(ShiftDateChar(9:10));
                         end%if CurrentHour >= 24
                     end%if CurrentMinute >= 60
                 end%if CurrentSecond >= 60
             end%if CurrentNsecond ~= mod(CurrentNsecond,1e9)


             %------
             % arrange range array
             %------
             %%% select range
    %          if Itime == 1 & Ibeam == 1
                 FitRange   = find( RangeArr >= LowerRange4Ana & ...
                                    RangeArr <= UpperRange4Ana );
                 RangeArr   = RangeArr(FitRange);
    %          end%if Itime == 1 & Factor4IntTime ~= 0


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
             AltArr    = RangeArr * sind(abs(BeamAngleX(Ibeam)));


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
             % adjust noise arrays
             %------
             TmpSize          = size(SelPSDArr1);
             Noise4PSDArr1    = repmat(orgNoise4PSDArr1,TmpSize(2),1)';
             Noise4PSDArr2    = repmat(orgNoise4PSDArr2,TmpSize(2),1)';
             Noise4PSDArr3    = repmat(orgNoise4PSDArr3,TmpSize(2),1)';


             %------
             % calculate the relative value
             %------
             SelPSDArr1    = SelPSDArr1./Noise4PSDArr1;
             SelPSDArr2    = SelPSDArr2./Noise4PSDArr2;
             SelPSDArr3    = SelPSDArr3./Noise4PSDArr3;


             %------
             % PSD in dB
             %------
             FitNoneZero               = find( SelPSDArr1 > 0 );
             SelPSDArr1(FitNoneZero)   = 10 * log10(SelPSDArr1(FitNoneZero));
             FitNoneZero               = find( SelPSDArr1 > 0 );
             SelPSDArr2(FitNoneZero)   = 10 * log10(SelPSDArr2(FitNoneZero));
             FitNoneZero               = find( SelPSDArr1 > 0 );
             SelPSDArr3(FitNoneZero)   = 10 * log10(SelPSDArr3(FitNoneZero));



             %------
             % set axis parameters
             %------
             mvaluex1    = [ min(FreqArr1) max(FreqArr1) ] - fradar;
             mvaluex2    = [ min(FreqArr2) max(FreqArr2) ] - fradar;
             mvaluex3    = [ min(FreqArr3) max(FreqArr3) ] - fradar;
             mvaluey     = [ LowerRange4Ana, UpperRange4Ana ];


             %------
             % image
             %------
             %%% iteration over channel number
             for Ichannel = 1:3
                 %%% subplot
                 subplot( 3,1,Ichannel );


                 %%% select data array
                 switch Ichannel
                     case 1
                         FreqArr   = FreqArr1;
                         SelPSDArr = SelPSDArr1;
                     case 2
                         FreqArr   = FreqArr2;
                         SelPSDArr = SelPSDArr2;
                     case 3
                         FreqArr   = FreqArr3;
                         SelPSDArr = SelPSDArr3;
                 end%switch Ichannel


                 %%% set axis-control parameters for the altitude
                 h        = line( [FreqArr(1), FreqArr(end)]    ...
                                , [AltArr(1), AltArr(end)]);
                 ax4alt   = gca;
                 set( ax4alt, 'XColor', 'k', 'YColor', 'k' )


                 %%% image
                 imagen( FreqArr-fradar, RangeArr, SelPSDArr' )
                
                 
                
                 %%% fHF line
                 if ChannelType(Ichannel) ~= 'I'
                     hold on
                     plot( ones(1,2)*sign(FreqArr(1)-fradar)*fHF, [0,1000], 'w--' )
                     hold off
                 end%if ChannelType(Ichannel) ~= 'I'


                 %%% y-axis label for the altitude
                 if Ichannel == 1
                     ylabel( 'Altitude (km)' )
                 end%if Ichannel == 1
                 set( gca               ...
                    , 'YTick'           ...
                    , ytickvarr4Alt     ...
                    , 'YTickLabel'      ...
                    , ytickcrarr4Alt )
%                  ylim( mvaluey4Alt )



                 %%% color axis
                 LowerColorValue   = 55;
                 UpperColorValue   = 75;

                 switch Ichannel
                     case 1
                         LowerColorValue = min(SelPSDArr1(:));
                         UpperColorValue = max(SelPSDArr1(:));
                     case 2
                         LowerColorValue = min(SelPSDArr2(:));
                         UpperColorValue = max(SelPSDArr2(:));
                     case 3
                         LowerColorValue = min(SelPSDArr3(:));
                         UpperColorValue = max(SelPSDArr3(:));
                 end%switch Ichannel
                 
%                  switch ChannelType(Ichannel)
%                      case 'I'
%                          LowerColorValue   = 65;
%                          UpperColorValue   = 70;
%                      case 'D'
%                          LowerColorValue   = 5;
%                          UpperColorValue   = 25;
%                      case 'U'
%                          LowerColorValue   = 5;
%                          UpperColorValue   = 25;
%                  end%switch ChannelType(Ichannel)
                   
%                   colorbar('Location', 'EastOutside');
                  caxis( [LowerColorValue UpperColorValue])
            
%                 Colortemp = caxis;
                 %%% axis control for the range
                 ax4range = axes( 'Position', get(ax4alt,'Position')   ...
                                , 'XAxisLocation', 'bottom'            ...
                                , 'YAxisLocation', 'right'             ...
                                , 'Color', 'none'                      ...
                                , 'XColor', 'k', 'YColor', 'b');


                 %%% calculate the y-axis range for the range
                 mvaluey4Range  = mvaluey4Alt / cosd(abs(360-BeamAngleY(Ibeam)));


                 %%% axis-range limitation for the range
%                  ylim( mvaluey4Range )


                 %%% y-axis label for the range
                 if Ichannel == 1
                     ylabel( 'Range (km)' )
                 end%if Ichannel == 1
                 set( gca                 ...
                    , 'YTick'             ...
                    , ytickvarr4Range     ...
                    , 'YTickLabel'        ...
                    , ytickcrarr4Range )




                 %%% x-axis
                 if Ichannel == 3
                     TmpChar  = [ {' '},{' '},{'Frequency offset (MHz)'}];
                     xlabel( TmpChar );
                 end%if Ichannel == 3
                 switch Ichannel
                     case 1
                         mvaluex = mvaluex1;
                     case 2
                         mvaluex = mvaluex2;
                     case 3
                         mvaluex = mvaluex3;
                 end%switch Ichannel

                 IntegerRangeArr  = unique(fix(FreqArr*10));
                 xtickvarr        = (IntegerRangeArr(1):0.5:IntegerRangeArr(end))/10;
                 TmpNum           = length(xtickvarr);
                 xtickcrarr       = [];
                 for Ix = 1:TmpNum
                     TmpChar     = num2str(xtickvarr(Ix));
                     xtickcrarr  = [ xtickcrarr, {TmpChar} ];
                 end%for Ix
                 xtickcrarr_s    = xtickcrarr;
                 xtickcrarr_s(:) = [];
                 set( gca               ...
                    , 'XTick'           ...
                    , xtickvarr         ...
                    , 'XTickLabel'      ...
                    , xtickcrarr )



                 %%% character (channel #)
                 ChannelNumChar  = num2str(Ichannel);
                 TmpChar         = [ 'Ch.' ChannelNumChar ];
                 mvaluex         = xlim;
                 posx            = mvaluex(2) - (mvaluex(2)-mvaluex(1))*0.10;
                 posy            = mvaluey(2) + (mvaluey(2)-mvaluey(1))*0.03;
                 text( posx, posy, TmpChar, 'FontSize', 10 );


                 %%% title
                 if Ichannel == 1
                     HH     = num2str(CurrentHour);
                     MM     = num2str(CurrentMinute);
                     SS     = num2str(CurrentSecond);
                     NN     = num2str(CurrentNsecond);

                     HH     = func_CheckCharLength(HH,2,'0');
                     MM     = func_CheckCharLength(MM,2,'0');
                     SS     = func_CheckCharLength(SS,2,'0');
                     NN     = func_CheckCharLength(NN,9,'0');

                     yy     = num2str(CurrentYear);
                     mm     = num2str(CurrentMonth);
                     dd     = num2str(CurrentDay);

                     yy     = func_CheckCharLength(yy,2,'0');
                     mm     = func_CheckCharLength(mm,2,'0');
                     dd     = func_CheckCharLength(dd,2,'0');
                     DateChar   = [ yy, mm, dd ];

                     IntegrationChar = IPP * Factor4IntTime / 1000;
                     IntegrationChar = [ num2str(IntegrationChar) ' ms' ];

                     TitleChar  = [ 'Time (HHMMSS:NN UT): ' HH MM SS ':' NN     ...
                                  , ' on ' DateChar ' (' IntegrationChar        ...
                                    ' Integration)' ];
                     TmpChar   = [ 'Selected Data: ' DataFileName4GIR ];

                     BeamAngleChar = [ '({\theta}x, {\theta}y): (' ];
                     BeamAngleXChar = num2str(BeamAngleX(Ibeam));
                     BeamAngleYChar = num2str(BeamAngleY(Ibeam));
                     BeamAngleChar  = [ BeamAngleChar, BeamAngleXChar  ...
                                        ', ' BeamAngleYChar ')' ];

                     mvaluex   = xlim;
                     mvaluey   = ylim;
                     posx      = mvaluex(1) + ( mvaluex(2) - mvaluex(1) ) * 0.00;
                     posy      = mvaluey(1) - ( mvaluey(2) - mvaluey(1) ) * 0.00;

                     TmpFit    = find( TmpChar == '\' );
                     TmpChar( TmpFit ) = '/';

                     title( {'relative power spectral density (dB)', ...
                             TitleChar, [ TmpChar '  ' BeamAngleChar]}, ...
                             'FontSize', 7, 'Interpreter', 'none' );
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
            if ~Iext
                DataNumChar             = num2str(SelDataNum4GIR);
                DataExtNumCharBegin     = num2str(SelDataExtNum4GIR(1));
                DataExtNumCharEnd       = num2str(SelDataExtNum4GIR(end));

                DataChar        = [ DataNumChar, '.', DataExtNumCharBegin, '-', ...
                                    DataExtNumCharEnd ];
            else
                DataNumChar             = num2str(SelDataNum4GIR);
                DataExtNumChar          = num2str(SelDataExtNum4GIR(Iext));

                DataChar        = [ DataNumChar, '.', DataExtNumChar];
            end
            
            if JpgSaveDirectory
                 FolderName     = fullfile('GIR_PSDvsFreq', DateChar );
                 DirectoryChar  = fullfile(JpgSaveDirectory, FolderName ); 

                 %%%
                 %%% Check directory tree, if needed make directry tree 
                 %%%

                 CommandChar   = [ 'cd ' DirectoryChar ];

                 [ status, CommandResults ] = unix( CommandChar );

                 if status 
                     [ status, CommandResults ] = mkdir( DirectoryChar ); 
                 end

            end %%if SelectedDirectory
            
            FileNameChar   = ...
                [ 'GIR_PSD_' DateChar, '.', DataChar, '.', HH, MM, SS, '.', NN, ];
            if BeamNum == 1
                FileNameChar = [ FileNameChar, '.jpg' ];
            else
                FileNameChar = [ FileNameChar, '-', num2str(Ibeam), '.jpg' ];
            end%if BeamNum == 1
            print( '-djpeg', fullfile(DirectoryChar, FileNameChar ) );
         end%for Ibeam
     end%for Itime
end%for Iext
