
global_SpectrumAna4GIR

fradar      = 446; 
TmpNum  = ceil(length(FreqArr1) / 2);


%% User Defined Paramaters
TimeNum     = 4;    %% Time element number too plot
Span        = 50;   %% 1/2 the span of the frequency domain
thresh      = 0.3;  %% min. y-value = ymin + ((ymin/ymax) - thresh)*ymin
FiltBit     = 1;    %% 1: Filter using moving avgerage 
window      = 3;    %% must be odd number, even number reduced by one


%% Span of Frequcney Domain
Domain  = [ TmpNum - Span, TmpNum + Span ];

%%% if Span == TmpNum, use entire frequency domain
if Span == TmpNum
    Domain = [ TmpNum - Span + 1, TmpNum + Span - 1 ];
end



%% Moving Average Filter
if FiltBit
    FilteredPSDArr1	= ...
        smooth(TmpPSDvsTimeArr1(:,TimeNum), window, 'moving');
    FilteredPSDArr2	= ...
        smooth(TmpPSDvsTimeArr2(:,TimeNum), window, 'moving');
    FilteredPSDArr3	= ...
        smooth(TmpPSDvsTimeArr3(:,TimeNum), window, 'moving');
else
    FilteredPSDArr1	= TmpPSDvsTimeArr1(:,TimeNum);
    FilteredPSDArr2	= TmpPSDvsTimeArr2(:,TimeNum);
    FilteredPSDArr3	= TmpPSDvsTimeArr3(:,TimeNum);
end%if FiltBit


%% PSD in DB
FitZero     = find(FilteredPSDArr1 > 0);
PSDvsTimeinDBArr1   = 10*log10(FilteredPSDArr1(FitZero));
FitZero     = find(FilteredPSDArr2 > 0);
PSDvsTimeinDBArr2   = 10*log10(FilteredPSDArr2(FitZero));
FitZero     = find(FilteredPSDArr3 > 0);
PSDvsTimeinDBArr3   = 10*log10(FilteredPSDArr3(FitZero));





%% Time

TmpChar	= num2str(hours{TmpNum}(1));
HH    	= func_CheckCharLength(TmpChar , 2, '0');

TmpChar	= num2str(minutes{TmpNum}(1));
MM      = func_CheckCharLength(TmpChar, 2, '0');

TmpChar	= num2str(seconds{TmpNum}(1));
SS      = func_CheckCharLength(TmpChar , 2, '0');

TmpChar	= num2str(nseconds{TmpNum}(1));
NN      = func_CheckCharLength(TmpChar, 2, '0');


TimeChar        = [ HH, ':', MM, ':',SS ];
DateChar        = num2str(SelDate); 
 
IntegrationChar = IPP * Factor4IntTime / 1000;
                 IntegrationChar = [ num2str(IntegrationChar) ' ms' ];

               
%% Plot Frequency vs Power for single intergrated time period
figure;
  
TitleChar       = [ 'PSD  (intergration time: ', IntegrationChar, ')' ];
TitleChar       = [ TitleChar, 'Date.StartTime: ', DateChar, '.', ...
                    TimeChar ];

suptitle([ TitleChar ]);

%%%----------
%%% Channel 1: Ion Line
%%%----------

subplot(3,1,1)

%%% ensures that the center of FreqArr is center frequency
%%% FreqArr and PSDvsTimeArr will always be odd
FreqArr1(TmpNum) = fradar; 


%%% set limits
xmin1   = FreqArr1(Domain(1)) - 446;
xmax1   = FreqArr1(Domain(2)) - 446;
ymin1   = min(PSDvsTimeinDBArr1(:));
ymax1   = max(PSDvsTimeinDBArr1(:));

ymax1   = ymax1 + 0.01*ymax1; 
ymin1   = ymin1 + ((ymin1/ymax1) - thresh)*ymin1;

plot(FreqArr1 - 446, PSDvsTimeinDBArr1, 'k');


%%% limits and labels
xlim([ xmin1 xmax1 ]);
ylim([ ymin1, ymax1 ]);
title([ 'Channel 1: Ion Line' ]);
xlabel([ 'Frequency Offset (MHz)' ]);
ylabel([ 'Power (dB)' ]);

hold on

%%% center frequency line
line([ 0 0 ], [ ymin1 ymax1 ],'LineStyle', '--', 'Color', 'r')


%%
%%%----------
%%% Channel 2: Upshifted Plasma Line
%%%----------

subplot(3,1,2)

%%% ensures that the center of FreqArr is center frequency
%%% FreqArr and PSDvsTimeArr will always be odd
FreqArr2(TmpNum) = fradar + fHF;  

%%% set limits
xmin2   = FreqArr2(Domain(1)) - 446;
xmax2   = FreqArr2(Domain(2)) - 446;
ymin2   = min(PSDvsTimeinDBArr2(:));
ymax2   = max(PSDvsTimeinDBArr2(:));

ymax2   = ymax2 + 0.01*ymax2;
ymin2   = ymin2 + ((ymin2/ymax2) - thresh)*ymin2;

plot(FreqArr2 - 446, PSDvsTimeinDBArr2, 'k');

%%% limits and labels
xlim([ xmin2 xmax2 ]);
ylim([ ymin2, ymax2 ]);
title([ 'Channel 2: Upshifted Plasma Line' ]);
xlabel([ 'Frequency Offset (MHz)' ]);
ylabel([ 'Power (dB)' ]);

hold on

%%% center frequency line
line([ fHF fHF ], [ ymin2 ymax2 ],'LineStyle', '--', 'Color', 'r')


%%
%%%----------
%%% Channel 1: Downshifted Plasma Line
%%%----------

subplot(3,1,3)

%%% ensures that the center of FreqArr is center frequency
%%% FreqArr and PSDvsTimeArr will always be odd
FreqArr3(TmpNum) = fradar - fHF; 

%%% set limits
xmin3   = FreqArr3(Domain(1)) - 446;
xmax3   = FreqArr3(Domain(2)) - 446;
ymin3   = min(PSDvsTimeinDBArr3(:));
ymax3   = max(PSDvsTimeinDBArr3(:));

ymax3   = ymax3 + 0.01*ymax3;
ymin3   = ymin3 + ((ymin3/ymax3) - thresh)*ymin3;

plot(FreqArr3 - 446, PSDvsTimeinDBArr3, 'k');

%%% limits and labels
xlim([ xmin3 xmax3 ]);
ylim([ ymin3, ymax3 ]);
title([ 'Channel 3: Downshifted Plasma Line' ]);
xlabel([ 'Frequency Offset (MHz)' ]);
ylabel([ 'Power (dB)' ]);

hold on

%%% center frequency line
line([ -fHF -fHF ], [ ymin3 ymax3 ],'LineStyle', '--', 'Color', 'r')