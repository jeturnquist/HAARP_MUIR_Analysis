%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_PlotPSDvsFreq4uCLP_SpectrumAna4GIR
%          made by Jason Turnquist, GI UAF
%
%          ver.1.0: Aug-23-2007
%          ver.2.0: Jan-20-2008, Added save to user defined directory
%                                Plot power in dB or default scale 
%
%          # make line plot of PSD vs frequency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% function  func_PlotPSDvsFreq4uCLP_SpectrumAna4GIR(          ...
%             PSDvsTimeArr1, PSDvsTimeArr2, PSDvsTimeArr3     ...
%             , FreqArr1, FreqArr2, FreqArr3                  ...
%             , hours, minutes, seconds, nseconds)
        

        
global_SpectrumAna4GIR

c           = 2.99792458e8;% speed of light
fradar      = 446; 


%% User Defined Paramaters
%%

%%% Parameters for plots
%%%

PSDinDBbit   	= 1;    %% 1 : Power will be plotted in dB (log scale)
                        %% 0 : Power will be plotted on default scale

AutoScaleYLim   = 0;    %% 1 : Automatically scale y-axis for each channel 
                        %%      Note: This will make the scale of each 
                        %%      channel differant 
                        %% 0 : Use default value defined by user
thresh          = 0.3;  %% min. y-value = ymin + ((ymin/ymax) - thresh)*ymin

%%% Defalut value for y-axis used when AutoScaleYLim   = 0
if PSDinDBbit
    default_ymin1   = 55;       %% Used with dB scale
    default_ymax1   = 100;      %%  
   	
    default_ymin2   = 55;       %% Used with dB scale
    default_ymax2   = 100;      %%  
   	
    default_ymin3   = 55;       %% Used with dB scale
    default_ymax3   = 100;      %%  
else
    default_ymin1   = 1*10^7;   %% Used with normal scale
    default_ymax1   = 1*10^8;   %% 
    
    default_ymin2   = 1*10^7;   %% Used with normal scale
    default_ymax2   = 1*10^9;   %%  
    
    default_ymin3   = 1*10^7;   %% Used with normal scale
    default_ymax3   = 1*10^9;   %%      
end

%%% Plot cascade lines
PlotW2          = 0;    %% 1 : Plot vertical dashed line at frequency of cascade lines
                        %% 0 : No lines are plotted
NumCasLines     = 4;    %% Number of cascade lines to be plotted


%%% Parameters for smoothing data before plotting
%%%

%TimeNum         = 4;    %% Time element number to plot
Span            = 55;   %% 1/2 the span of the frequency domain
FiltBit         = 0;    %% 1: Filter using moving avgerage 
window          = 3;    %% window size of moving average 
                        %% must be odd number, even number reduced by one
tol             = 0.01;


%% Initialize Arrays
%%
time_idx = [];
PSDvsTimeinDBArr1   = [];
PSDvsTimeinDBArr2   = [];
PSDvsTimeinDBArr3   = []; 

PSDArr1 = cell2mat(PSDvsTimeArr1);
PSDArr2 = cell2mat(PSDvsTimeArr2);
PSDArr3 = cell2mat(PSDvsTimeArr3);


TmpSize    = size(PSDArr1);

TmpNum      = ceil(TmpSize(1) / 2);

%% Span of Frequcney Domain
%%

%%% if Span == TmpNum, use entire frequency domain
if Span == TmpNum
    Domain = [ TmpNum - Span + 1, TmpNum + Span - 1 ];
else
    Domain  = [ TmpNum - Span, TmpNum + Span ];
end


%%% Noise
maxPSD1 = max(PSDArr1(:));
maxPSD2 = max(PSDArr2(:));
maxPSD3 = max(PSDArr3(:));

meanPSD1 = mean(PSDArr1(:));
meanPSD2 = mean(PSDArr2(:));
meanPSD3 = mean(PSDArr3(:));

Noise4PSDArr1    = maxPSD1 * tol;
Noise4PSDArr2    = maxPSD2 * tol;
Noise4PSDArr3    = maxPSD3 * tol;

for TimeNum = 1:1:TmpSize(2)
    if ( PSDArr1(TmpNum - 5,TimeNum)*0.5      ...
        >= Noise4PSDArr1              |             ...
     PSDArr2(TmpNum - 5,TimeNum)*0.5          ...
        >= Noise4PSDArr2              |             ...
     PSDArr3(TmpNum + 5,TimeNum)*0.5          ...
        >= Noise4PSDArr3 )

        time_idx = [ time_idx, TimeNum ];
%% Moving Average Filter
%%
        if FiltBit
            FilteredPSDArr1	= ...
                smooth(PSDArr1(:,TimeNum), window, 'moving');
            FilteredPSDArr2	= ...
                smooth(PSDArr2(:,TimeNum), window, 'moving');
            FilteredPSDArr3	= ...
                smooth(PSDArr3(:,TimeNum), window, 'moving');
        else
            FilteredPSDArr1	= PSDArr1(:,TimeNum);
            FilteredPSDArr2	= PSDArr2(:,TimeNum);
            FilteredPSDArr3	= PSDArr3(:,TimeNum);
        end%if FiltBit

        %%% Power in decibel scale
        if PSDinDBbit 
            %% PSD in DB
            %%
            FitZero     = find(FilteredPSDArr1 > 0);
            tmpPSDvsTimeinDBArr1   = 10*log10(FilteredPSDArr1(FitZero));
            FitZero     = find(FilteredPSDArr2 > 0);
            tmpPSDvsTimeinDBArr2   = 10*log10(FilteredPSDArr2(FitZero));
            FitZero     = find(FilteredPSDArr3 > 0);
            tmpPSDvsTimeinDBArr3   = 10*log10(FilteredPSDArr3(FitZero));
        else
            tmpPSDvsTimeinDBArr1	= FilteredPSDArr1;
            tmpPSDvsTimeinDBArr2	= FilteredPSDArr2;
            tmpPSDvsTimeinDBArr3	= FilteredPSDArr3;
        end

    else
        continue;
    end %% if PSDvsTimeArr1{Iext}...
    
    PSDvsTimeinDBArr1	= [ PSDvsTimeinDBArr1, tmpPSDvsTimeinDBArr1 ];
    PSDvsTimeinDBArr2	= [ PSDvsTimeinDBArr2, tmpPSDvsTimeinDBArr2 ];
    PSDvsTimeinDBArr3	= [ PSDvsTimeinDBArr3, tmpPSDvsTimeinDBArr3 ];
    
end%for TimeNum = 1:TmpSize(2)

%% Time
%%

tmpHH  	= [];
tmpMM  	= [];
tmpSS  	= [];
tmpNN   = [];
CharHH  = {};
CharMM  = {};
CharSS  = {};
CharNN  = {};
TimeChar = {};

%%% Convert cell arrays to continuous vector
for i=1:1:length(hours),    tmpHH  	= [tmpHH; hours{i}]; end
for i=1:1:length(minutes),  tmpMM  	= [tmpMM; minutes{i}]; end
for i=1:1:length(seconds),  tmpSS 	= [tmpSS; seconds{i}]; end
for i=1:1:length(nseconds), tmpNN  	= [tmpNN; nseconds{i}]; end

%%% Pick out times of interest
HH	= tmpHH((time_idx)*Factor4IntTime + 1);
MM	= tmpMM((time_idx)*Factor4IntTime + 1);
SS	= tmpSS((time_idx)*Factor4IntTime + 1);
NN	= tmpNN((time_idx)*Factor4IntTime + 1);

%%% Mark start of each enhancement
intr_idx            = diff(time_idx);
tmp_idx             = find(intr_idx == 1);
intr_idx(tmp_idx)  	= 0;
intr_idx            = [ 1, sign(intr_idx) ];

%%% Times of interest
for i = 1:1:length(intr_idx)
    if intr_idx(i)
        TmpChar     = num2str(HH(i));
        CharHH{i}	= func_CheckCharLength(TmpChar , 2, '0');

        TmpChar     = num2str(MM(i));
        CharMM{i}	= func_CheckCharLength(TmpChar, 2, '0');

        TmpChar     = num2str(SS(i));
        CharSS{i}	= func_CheckCharLength(TmpChar , 2, '0');

        TmpChar     = num2str(NN(i));
        CharNN{i}	= func_CheckCharLength(TmpChar, 2, '0');
        TimeChar{i}	= [ CharHH{i}, ':', CharMM{i}, ':',CharSS{i}, ':', CharNN{i} ];
    else
        CharHH{i}   = {};
        CharMM{i}   = {};
        CharSS{i}   = {};
        CharNN{i}   = {};
        TimeChar{i} = {};
    end
end %%i = 1:1:lenght(intr_idx)

DateChar 	= num2str(SelDate); 

IntegrationChar = IPP * Factor4IntTime / 1000;
IntegrationChar = [ num2str(IntegrationChar) ' ms' ];


%%% ensures that the center of FreqArr is center frequency
%%% Note: lenght of FreqArr and PSDvsTimeArr will always be odd
%         FreqArr1(TmpNum) = fradar; 
%         FreqArr2(TmpNum) = fradar + fHF;
%         FreqArr3(TmpNum) = fradar - fHF;

%% Calculation of Ion Acoustic and Plasma Line Frequency 
%%

% The ionline frequency is found from the maximum of the ionline spectrum 
% The upshifted/downshifted plasma lines are shifted from the HF frequency 
%  by odd multiples of the the ion acoustic frequency,
%  fPL = fradar +- (fHF - n*fIA), n = 1, 3, 5...
% 
%         IonLineFit  = find(FilteredPSDArr1 == max(FilteredPSDArr1));
%         IonLineFreq = FreqArr1(IonLineFit(1)) - fradar;
% 
%         if IonLineFreq
%              PLFreq  = abs(IonLineFreq);
%             for i = 1:1:NumCasLines
% 
%                 UPLFreq(i) = fHF - (2*i-1)*PLFreq;
%                 DPLFreq(i) = (2*i-1)*PLFreq - fHF;
% 
%             end
%         else
%             UPLFreq(1:NumCasLines) = FreqArr2(TmpNum);
%             DPLFreq(1:NumCasLines) = FreqArr3(TmpNum);
%         end

%% Plot Frequency vs Power for single intergrated time period
%%

figure( 'Position', [ 100 100 600 800 ] );

tmpnum = size(PSDvsTimeinDBArr1);

%%%----------
%%% Channel 1: Ion Line
%%%----------
for j = 1:1:tmpnum(2)
    if j == 1
        k1 = 2;
    else
        k1 = k1 + 3;
    end
    subplotrc(tmpnum(2),3,k1);
    % subplot(3,1,1)


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

    plot(FreqArr1 - 446, PSDvsTimeinDBArr1(:,end-j+1), 'k');
    % ribbon(FreqArr1 - 446, PSDvsTimeinDBArr1);


    %%% limits and labels
    xlim([ xmin1 xmax1 ]);
    ylim([ ymin1, ymax1 ]);
    if j == 1
        title([ 'Channel 1: Ion Line' ]);
        set(gca,'YTickLabel','');
    elseif j ~= tmpnum(2)
        set(gca,'YTickLabel','');
    end
    
%     xlabel([ 'Frequency Offset (MHz)' ]);
%     if PSDinDBbit
%         ylabel([ 'Power (dB)' ]);
%     else
%         ylabel([ 'Power' ]);
%     end

    hold on

    %%% center frequency line
    line([ 0 0 ], [ ymin1 ymax1 ],'LineStyle', '--', 'Color', 'r')
    if PlotW2
        line([ IonLineFreq IonLineFreq ], [ ymin1 ymax1 ],...
            'LineStyle', '--', 'Color', 'r')
    end

   if 1
    %%
    %%%----------
    %%% Channel 2: Upshifted Plasma Line
    %%%----------

    if j == 1
        k2 = 3;
    else
        k2 = k2 + 3;
    end
    subplotrc(tmpnum(2),3,k2);
    % subplot(3,1,2)

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

    plot(FreqArr2 - 446, PSDvsTimeinDBArr2(:,end-j+1), 'k');
    % ribbon(FreqArr2 - 446, PSDvsTimeinDBArr2);

    %%% limits and labels
    xlim([ xmin2 xmax2 ]);
    ylim([ ymin2, ymax2 ]);
    if j == 1
        title([ 'Channel 2: Upshifted Plasma Line' ]);
        set(gca,'YTickLabel','');
    elseif j ~= tmpnum(2)
        set(gca,'YTickLabel','');
    end

%     xlabel([ 'Frequency Offset (MHz)' ]);
%     if PSDinDBbit
%         ylabel([ 'Power (dB)' ]);
%     else
%         ylabel([ 'Power' ]);
%     end

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
    %%% Channel 3: Downshifted Plasma Line
    %%%----------
    if j == 1
        k3 = 1;
    else
        k3 = k3 + 3;
    end
    subplotrc(tmpnum(2),3,k3);
    % subplot(3,1,3)

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

    plot(FreqArr3 - 446, PSDvsTimeinDBArr3(:,end-j+1), 'k');
    % ribbon(FreqArr3 - 446, PSDvsTimeinDBArr3);

    %%% limits and labels
    xlim([ xmin3 xmax3 ]);
    ylim([ ymin3, ymax3 ]);
    if j == 1
        title([ 'Channel 3: Downshifted Plasma Line' ]);
        set(gca,'YTickLabel','');
    elseif j ~= tmpnum(2)
        set(gca,'YTickLabel','');
    end
%     xlabel([ 'Frequency Offset (MHz)' ]);
%     if PSDinDBbit
%         ylabel([ 'Power (dB)' ]);
%     else
%         ylabel([ 'Power' ]);
%     end

    %%% print the times of the start of each enhancement on the y-axis
    tmp_idx = fliplr(intr_idx)
    tmpChar = fliplr(TimeChar)
    if tmp_idx(j) & j ~= length(TimeChar)
        h = ylabel([ tmpChar{j} ]);
        label_pos = get(h, 'pos');
        set(h, 'pos', [label_pos(1),label_pos(2)+60, label_pos(3)]);
    end %intr_idx(j)
    
    hold on

    %%% center frequency line
    line([ -fHF -fHF ], [ ymin3 ymax3 ],'LineStyle', '--', 'Color', 'r')
    if PlotW2
        for i = 1:1:NumCasLines
            line([ DPLFreq(i) DPLFreq(i) ], [ ymin3 ymax3 ],...
                'LineStyle', '--', 'Color', 'r')
        end
    end
   end %% if 0
end %%for j=1:1:tmpnum(2)

%% Join axis for each column
%%
samexaxis_modified('abc','xmt','on','ytac','join','yld',0,3);

%% Super Title and Super Axis Labels
%%
LowerRangeChar  = num2str(LowerRange4Ana);
UpperRangeChar  = num2str(UpperRange4Ana);   
% TitleChar       = { [ 'PSD  (integration time: ', IntegrationChar, ')',...
%                     '       Date.StartTime: ', DateChar, '.', TimeChar, ...
%                     '       Range: ', LowerRangeChar, '-'      ...
%                     UpperRangeChar, ' km' ];                            ...
%                     ['']; [''] };
TitleChar       =[ 'PSD  (integration: ', IntegrationChar, ')',...
                    '       Date.StartTime: ', DateChar, '.', TimeChar{1}, ...
                    '       Range: ', LowerRangeChar, '-'      ...
                    UpperRangeChar, ' km' ];
                
                

%%% x-axis super label
[ax,h1]=suplabel('Frequency Offset (MHz)');

%%% y-axis super label
if PSDinDBbit
    [ax,h2]=suplabel('Power (dB)','y');
else
    [ax,h2]=suplabel('Power','y');
end

%%% Super Title
[ax,h3]=suplabel( TitleChar  ,'t');
set(h3,'FontSize',12)

%% Save as jpg
%%


%             DataExtNumCharBegin     = num2str(SelDataExtNum4GIR(1));
%             DataExtNumCharEnd       = num2str(SelDataExtNum4GIR(end));
% 
%             DataChar        = [ DataNumChar, '.', DataExtNumCharBegin, '-', ...
%                                 DataExtNumCharEnd ];
return
DataNumChar             = num2str(SelDataNum4GIR);
DataExtNumChar          = num2str(SelDataExtNum4GIR(Iext));

DataChar        = [ DataNumChar, '.', DataExtNumChar];

%%if another directory was chosen for jpeg file
if JpgSaveDirectory 
     FolderName     = [ '\GIR_PSDvsTime\', DateChar ];
     DirectoryChar  = [ JpgSaveDirectory, FolderName ];

    % ------
    % list-up data file
    % ------
    % 
    % unix command
    %
     switch OSChar
         case { 'Linux' }
             %CommandChar   = [ 'ls -1 ' DirectoryChar '*.Dt0' ];
         case { 'Windows' }
             CommandChar    = [ 'md ' DirectoryChar ];
     end%switch OSChar

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

FileNameChar = [ DirectoryChar, '\', FileNameChar ];
print( '-djpeg', FileNameChar );


% close('all');