%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_PlotPSDvsFreq4uCLPShort_SpectrumAna4GIR
%          made by Jason Turnquist, GI UAF
%
%          ver.1.0: Aug-23-2007
%          ver.2.0: Jan-20-2008, Added save to user defined directory
%                                Plot power in dB or default scale 
%
%          # make line plot of PSD vs frequency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  func_PlotPSDvsFreq4uCLPShort_SpectrumAna4GIR(          ...
            PSDvsTimeArr1, PSDvsTimeArr2, PSDvsTimeArr3     ...
            , FreqArr1, FreqArr2, FreqArr3                  ...
            , hours, minutes, seconds, nseconds)
        


global_SpectrumAna4GIR

c           = 2.99792458e8;% speed of light
fradar      = 446; 

TmpSize    = size(PSDvsTimeArr1{1});

TmpNum      = ceil(TmpSize(1) / 2);


%% User Defined Paramaters
%%

%%% Parameters for plots
%%%

PSDinDBbit   	= 0;    %% 1 : Power will be plotted in dB (log scale)
                        %% 0 : Power will be plotted on default scale

AutoScaleYLim   = 1;    %% 1 : Automatically scale y-axis for each channel 
                        %%      Note: This will make the scale of each 
                        %%      channel differant 
                        %% 0 : Use default value defined by user
thresh          = 0.3;  %% min. y-value = ymin + ((ymin/ymax) - thresh)*ymin
%%% Plot cascade lines
PlotW2          = 0;    %% 1 : Plot vertical dashed line at frequency of cascade lines
                        %% 0 : No lines are plotted
NumCasLines     = 1;    %% Number of cascade lines to be plotted

%TimeNum         = 4;    %% Time element number to plot
Span            = 50;   %% 1/2 the span of the frequency domain
FiltBit         = 0;    %% 1: Filter using moving avgerage 
window          = 3;    %% window size of moving average 
                        %% must be odd number, even number reduced by one
tol             = 0.01;


%%% Defalut value for y-axis used when AutoScaleYLim   = 0
if PSDinDBbit
    default_ymin1   = 55;       %% Used with dB scale
    default_ymax1   = 120;      %%  
   	
    default_ymin2   = 55;       %% Used with dB scale
    default_ymax2   = 120;      %%  
   	
    default_ymin3   = 55;       %% Used with dB scale
    default_ymax3   = 120;      %%  
else
    default_ymin1   = 1*10^7;   %% Used with normal scale
    default_ymax1   = 1*10^11;   %% 
    
    default_ymin2   = 1*10^7;   %% Used with normal scale
    default_ymax2   = 1*10^12;   %%  
    
    default_ymin3   = 1*10^7;   %% Used with normal scale
    default_ymax3   = 1*10^12;   %%      
end


%% Span of Frequcney Domain
%%

%%% if Span < 0, use entire frequency domain
if Span < 0
    Domain = [ 1, 2*TmpNum - 1 ];
elseif Span > TmpNum
    disp('### ERROR: User defined variable Span is larger than the width if the frequency vector ###')
    return;
else
    Domain  = [ TmpNum - Span, TmpNum + Span ];
end

%%% Manually Set the Frequency Domain 
% Domain(1) = 150;
% Domain(2) = 240;

LengthNum   = length(PSDvsTimeArr1);

for Iext = 1:1:LengthNum
    
    %%% Noise
    maxPSD1 = max(PSDvsTimeArr1{Iext}(:));
    maxPSD2 = max(PSDvsTimeArr2{Iext}(:));
    maxPSD3 = max(PSDvsTimeArr3{Iext}(:));

    meanPSD1 = mean(PSDvsTimeArr1{Iext}(:));
    meanPSD2 = mean(PSDvsTimeArr2{Iext}(:));
    meanPSD3 = mean(PSDvsTimeArr3{Iext}(:));
    
%     if ((maxPSD1 / meanPSD1) < 1e2 & (maxPSD2 / meanPSD2) < 1e2 ...
%            & (maxPSD3 / meanPSD3) < 1e2)
%        continue; 
%     end

    
    Noise4PSDArr1    = maxPSD1 * tol;
    Noise4PSDArr2    = maxPSD2 * tol;
    Noise4PSDArr3    = maxPSD3 * tol;

    
    for TimeNum = 1:1:TmpSize(2)
        if ( PSDvsTimeArr1{Iext}(TmpNum - 5,TimeNum)*0.5   ...
            >= Noise4PSDArr1              |...
         PSDvsTimeArr2{Iext}(TmpNum - 5,TimeNum)*0.5   ...
            >= Noise4PSDArr2              |...
         PSDvsTimeArr3{Iext}(TmpNum + 5,TimeNum)*0.5   ...
            >= Noise4PSDArr3 )


%% Moving Average Filter
%%
            if FiltBit
                FilteredPSDArr1	= ...
                    smooth(PSDvsTimeArr1{Iext}(:,TimeNum), window, 'moving');
                FilteredPSDArr2	= ...
                    smooth(PSDvsTimeArr2{Iext}(:,TimeNum), window, 'moving');
                FilteredPSDArr3	= ...
                    smooth(PSDvsTimeArr3{Iext}(:,TimeNum), window, 'moving');
            else
                FilteredPSDArr1	= PSDvsTimeArr1{Iext}(:,TimeNum);
                FilteredPSDArr2	= PSDvsTimeArr2{Iext}(:,TimeNum);
                FilteredPSDArr3	= PSDvsTimeArr3{Iext}(:,TimeNum);
            end%if FiltBit

            %%% Power in decibel scale
            if PSDinDBbit 
                %% PSD in DB
                %%
                FitZero     = find(FilteredPSDArr1 > 0);
                PSDvsTimeinDBArr1   = 10*log10(FilteredPSDArr1(FitZero));
                FitZero     = find(FilteredPSDArr2 > 0);
                PSDvsTimeinDBArr2   = 10*log10(FilteredPSDArr2(FitZero));
                FitZero     = find(FilteredPSDArr3 > 0);
                PSDvsTimeinDBArr3   = 10*log10(FilteredPSDArr3(FitZero));
            else
                PSDvsTimeinDBArr1	= FilteredPSDArr1;
                PSDvsTimeinDBArr2	= FilteredPSDArr2;
                PSDvsTimeinDBArr3	= FilteredPSDArr3;
            end


%% Time
%%

            TmpChar	= num2str(hours((TimeNum-1)*Factor4IntTime + 1));
            HH    	= func_CheckCharLength(TmpChar , 2, '0');

            TmpChar	= num2str(minutes((TimeNum-1)*Factor4IntTime + 1 ));
            MM      = func_CheckCharLength(TmpChar, 2, '0');

            TmpChar	= num2str(seconds((TimeNum-1)*Factor4IntTime + 1));
            SS      = func_CheckCharLength(TmpChar , 2, '0');

            TmpChar	= num2str(nseconds((TimeNum-1)*Factor4IntTime + 1));
            NN      = func_CheckCharLength(TmpChar, 2, '0');


            TimeChar        = [ HH, ':', MM, ':',SS, ':', NN ];
            DateChar        = num2str(SelDate); 

            IntegrationChar = IPP * Factor4IntTime / 1000;
            IntegrationChar = [ num2str(IntegrationChar) ' ms' ];
            
            
            %%% ensures that the center of FreqArr is center frequency
            %%% Note: lenght of FreqArr and PSDvsTimeArr will always be odd
%             FreqArr1(TmpNum) = fradar; 
%             FreqArr2(TmpNum) = fradar + fHF;
%             FreqArr3(TmpNum) = fradar - fHF;
            
%% Calculation of Ion Acoustic and Plasma Line Frequency 
%%

% The ionline frequency is found from the maximum of the ionline spectrum 
% The upshifted/downshifted plasma lines are shifted from the HF frequency 
%  by odd multiples of the the ion acoustic frequency,
%  fPL = fradar +- (fHF - n*fIA), n = 1, 3, 5...

%             IonLineFit  = find(FilteredPSDArr1 == max(FilteredPSDArr1));
%             IonLineFreq = FreqArr1(IonLineFit(1)) - fradar;
%             
%             if IonLineFreq
%                  PLFreq  = abs(IonLineFreq);
%                 for i = 1:1:NumCasLines
% 
%                     UPLFreq(i) = fHF - (2*i-1)*PLFreq;
%                     DPLFreq(i) = (2*i-1)*PLFreq - fHF;
% 
%                 end
%             else
%                 UPLFreq(1:NumCasLines) = FreqArr2(TmpNum);
%                 DPLFreq(1:NumCasLines) = FreqArr3(TmpNum);
%             end

%% Plot Frequency vs Power for single intergrated time period
%%

%            figure( 'Visible', 'off' );
figure

            LowerRangeChar  = num2str(LowerRange4Ana);
            UpperRangeChar  = num2str(UpperRange4Ana);   
            TitleChar       = { [ 'PSD  (integration time: ', IntegrationChar, ')',...
                                '       Date.StartTime: ', DateChar, '.', TimeChar, ...
                                '       Range: ', LowerRangeChar, '-'      ...
                                UpperRangeChar, ' km' ];                            ...
                                ['']; [''] };


            suptitle([ TitleChar ]);

            %%%----------
            %%% Channel 1: Ion Line
            %%%----------

            subplot(3,1,1)


            %%% set limits
            % x limit : range of frequency domain
            % y limit : AutoScaleYLim - automaitcally scale the y-axis for
            %                           each channel
            %         : Default Limit - use default limit defined by user
                 
            xmin1   = FreqArr1(Domain(1)) - 446;
            xmax1   = FreqArr1(Domain(2)) - 446;
            
            if AutoScaleYLim
                ymin1   = min(PSDvsTimeinDBArr1(:));
                ymax1   = max(PSDvsTimeinDBArr1(:));

                ymax1   = 1.01*ymax1; 
                ymin1   = ymin1 + ((ymin1/ymax1) - thresh)*ymin1;

                if ((ymax1 <= ymin1) | (ymax1 < 0) | (ymin1 < 0))
                    ymin1   = min(PSDvsTimeinDBArr1(:));
                    ymax1   = max(PSDvsTimeinDBArr1(:));
                end
            else
                ymin1 = default_ymin1;
                ymax1 = default_ymax1;
            end
            
            plot(FreqArr1 - 446, PSDvsTimeinDBArr1, 'k');


            %%% limits and labels
            xlim([ xmin1 xmax1 ]);
            ylim([ ymin1, ymax1 ]);
            title([ 'Channel 1: Ion Line' ]);
            xlabel([ 'Frequency Offset (MHz)' ]);
            if PSDinDBbit
                ylabel([ 'Power (dB)' ]);
            else
                ylabel([ 'Power' ]);
            end

            hold on

            %%% center frequency line
            line([ 0 0 ], [ ymin1 ymax1 ],'LineStyle', '--', 'Color', 'r')
            if PlotW2
                line([ IonLineFreq IonLineFreq ], [ ymin1 ymax1 ],...
                    'LineStyle', '--', 'Color', 'r')
            end

%%
            %%%----------
            %%% Channel 2: Upshifted Plasma Line
            %%%----------

            subplot(3,1,2)  

            %%% set limits
            % x limit : range of frequency domain
            % y limit : AutoScaleYLim - automaitcally scale the y-axis for
            %                           each channel
            %         : Default Limit - use default limit defined by user
                           
            xmin2   = FreqArr2(Domain(1)) - 446;
            xmax2   = FreqArr2(Domain(2)) - 446;
            
            if AutoScaleYLim
                ymin2   = min(PSDvsTimeinDBArr2(:));
                ymax2   = max(PSDvsTimeinDBArr2(:));

                ymax2   = 1.01*ymax2; 
                ymin2   = ymin2 + ((ymin2/ymax2) - thresh)*ymin2;

                if ((ymax2 <= ymin2) | (ymax2 < 0) | (ymin2 < 0))
                    ymin2   = min(PSDvsTimeinDBArr2(:));
                    ymax2   = max(PSDvsTimeinDBArr2(:));
                end
            else
                ymin2 = default_ymin2;
                ymax2 = default_ymax2;
            end
            
            plot(FreqArr2 - 446, PSDvsTimeinDBArr2, 'k');

            %%% limits and labels
            xlim([ xmin2 xmax2 ]);
            ylim([ ymin2, ymax2 ]);
            title([ 'Channel 2: Upshifted Plasma Line' ]);
            xlabel([ 'Frequency Offset (MHz)' ]);
            if PSDinDBbit
                ylabel([ 'Power (dB)' ]);
            else
                ylabel([ 'Power' ]);
            end

            hold on

            %%% center frequency line
            line([ fHF fHF ], [ ymin2 ymax2 ],'LineStyle', '--', 'Color', 'r')
            
            if PlotW2
                for i = 1:1:NumCasLines
                    line([ UPLFreq(i) UPLFreq(i) ], [ ymin2 ymax2 ],...
                        'LineStyle', '--', 'Color', 'r')
                end
            end

%%
            %%%----------
            %%% Channel 1: Downshifted Plasma Line
            %%%----------

            subplot(3,1,3)

            %%% set limits
            % x limit : range of frequency domain
            % y limit : AutoScaleYLim - automaitcally scale the y-axis for
            %                           each channel
            %         : Default Limit - use default limit defined by user
                           
            xmin3   = FreqArr3(Domain(1)) - 446;
            xmax3   = FreqArr3(Domain(2)) - 446;
            
            if AutoScaleYLim
                ymin3   = min(PSDvsTimeinDBArr3(:));
                ymax3   = max(PSDvsTimeinDBArr3(:));

                ymax3   = 1.01*ymax3; 
                ymin3   = ymin3 + ((ymin3/ymax3) - thresh)*ymin3;

                if ((ymax3 <= ymin3) | (ymax3 < 0) | (ymin3 < 0))
                    ymin3   = min(PSDvsTimeinDBArr3(:));
                    ymax3   = max(PSDvsTimeinDBArr3(:));
                end
            else
                ymin3 = default_ymin3;
                ymax3 = default_ymax3;
            end
            
            plot(FreqArr3 - 446, PSDvsTimeinDBArr3, 'k');

            %%% limits and labels
            xlim([ xmin3 xmax3 ]);
            ylim([ ymin3, ymax3 ]);
            title([ 'Channel 3: Downshifted Plasma Line' ]);
            xlabel([ 'Frequency Offset (MHz)' ]);
            if PSDinDBbit
                ylabel([ 'Power (dB)' ]);
            else
                ylabel([ 'Power' ]);
            end

            hold on

            %%% center frequency line
            line([ -fHF -fHF ], [ ymin3 ymax3 ],'LineStyle', '--', 'Color', 'r')
            if PlotW2
                for i = 1:1:NumCasLines
                    line([ DPLFreq(i) DPLFreq(i) ], [ ymin3 ymax3 ],...
                        'LineStyle', '--', 'Color', 'r')
                end
            end


%% Save as jpg
%%


%             DataExtNumCharBegin     = num2str(SelDataExtNum4GIR(1));
%             DataExtNumCharEnd       = num2str(SelDataExtNum4GIR(end));
% 
%             DataChar        = [ DataNumChar, '.', DataExtNumCharBegin, '-', ...
%                                 DataExtNumCharEnd ];

            DataNumChar             = num2str(SelDataNum4GIR);
            DataExtNumChar          = num2str(SelDataExtNum4GIR(Iext));
            
            DataChar        = [ DataNumChar, '.', DataExtNumChar];
            
            %%if another directory was chosen for jpeg file
            if JpgSaveDirectory 
                 FolderName     = [ filesep, 'GIR_PSDvsTime', filesep, 'LinePlots', filesep, DateChar ];
                 DirectoryChar  = [ JpgSaveDirectory, FolderName ];

                % ------
                % list-up data file
                % ------
                % 
                % unix command
                %
                if isunix
                    CommandChar   = [ 'ls -1 ' DirectoryChar '*.Dt0' ];
                elseif ispc
                    CommandChar    = [ 'md ' DirectoryChar ];
                end

                %
                % execute the command and return results
                %
                 [ tmp, CommandResults ] = unix( CommandChar );  

            end %%if SelectedDirectory
            
            if PSDinDBbit
                FileNameChar   = ...
                    [ 'GIR_PSDvsFreq_dB_', DateChar, '.', DataChar, '.' ...
                    , HH, MM, SS, '.', NN ];
            else
                FileNameChar   = ...
                    [ 'GIR_PSDvsFreq_', DateChar, '.', DataChar, '.'    ...
                    , HH, MM, SS, '.', NN ];  
            end %%if PSDinDBbit
            
            if BeamNum == 1
                FileNameChar = [ FileNameChar, '.jpg' ];
            else
                FileNameChar = [ FileNameChar, '-', num2str(Ibeam), '.jpg' ];
            end%if BeamNum == 1
            
            FileNameChar = [ DirectoryChar, filesep, FileNameChar ];
            print( '-djpeg', FileNameChar );
        else
            continue;
        end %%PSDvsTimeArr1{Iext} ...
        close('all');
    end%for TimeNum = 1:TmpSize(2)
end%for Iext = 1:LengthNum

