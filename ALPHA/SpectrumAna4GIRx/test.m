% close all
% clear all
% clc

code_ascii='+-+-+++++--++-+++----++++-+----++++-++-+-+-+---+---++++---+-+--++----+-+---++---++++-----++--++---++-+++--+++-+++----+--+++--++-+++-+-++++++---+-+++--+-+++---++----++--+++-+++----+-+----++-+++-++----'
for i=1:length(code_ascii)
    if code_ascii(i)=='+'
        code(i)=1;
    else
        code(i)=-1;
    end
end


filename='H:\GIReceiver\20060326\40.04.dat';
[hdr,rhdr,dp,du,cp,np,seconds] = drrad(filename,2,1);

du=du';
%du=du./(2^15);
%du=du./max(max(abs(du)));
du=du./(100);
du=du./(2^15);
power=abs(du).^2;

figure
H1=imagen(10*log10(power))

range=-125*.6:.6:(1100-125-1)*.6
time=0:.010:1499*.010
figure
H1=imagen(10*log10(power))
title('Enhanced Ion Line')
xlabel('Time from start of data collection (s)')
ylabel('Range (km)')
%axis([0 1100 0 1500 -100 0])
%view(-90,90)
%axis([-75.3 584.7 0 15])
colorbar

figure
H2=imagen(seconds,range,10*log10(power))
H=title('Enhanced Ion Line - GI Receiver')
set(H,'FontWeight','bold');
set(H,'FontSize',14);
xlabel('Time from start of data collection (s)')
ylabel('Range (km)')
hold on
H=line([120 120.1],[500 500])
set(H,'LineWidth',10)
set(H,'Color',[0 0 0])
axis([119.95 120.2 -75.3 584.7 ])
H=text(time(496)-.0032,470,'Heater On')
set(H,'FontWeight','bold');
set(H,'FontSize',12);
colorbar