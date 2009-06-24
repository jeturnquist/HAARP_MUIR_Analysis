function plotspectrogram(PSDArr, noise4PSDArr, FreqArr, fradar, time, n)

TmpNum          = size(PSDArr);
noise4PSDArr    = mean(PSDArr);
%noise4PSDArr   = mean(PSDArr2t(end-10:end, :));
noise4PSDArr    = repmat(noise4PSDArr, TmpNum(1), 1);

scPSDArr        = PSDArr ./ noise4PSDArr;

fitZero         = find(scPSDArr > 0);
scPSDArr(fitZero)   = 10*log10(PSDArr(fitZero));

f1      = figure(n);

imagesc([ time(1), time(end) ], FreqArr - fradar,  scPSDArr); 

xlabel(['Time(UT)']);%: seconds from 5:00']), 
ylabel(['Frequency Offset (MHz)']); 

title({ ['\fontsize{12}\bf HAARP MUIR on 20060808'];                 ...
        ['\fontsize{10}\rm PSD(dB) integration time = 0.01 s'];      ...
        [''];                                       ...
        ['UPL from GI Receiver data'] }); 

colormap( jet ) 
colorbar

