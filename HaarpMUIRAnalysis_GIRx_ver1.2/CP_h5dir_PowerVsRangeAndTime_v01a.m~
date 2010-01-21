% 
%     CLP_dir_PowerVsRangeAndTime_v01a.m
%     MUIR/AMISR basic range-decoding software
%
%     Copyright (C) 2009  Chris Fallen
%                         University of Alaska Fairbanks
%                         Fairbanks, AK 99775
%                         ctfallen@alaska.edu
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% 
function [matPathList, figPathList] = ...
            CP_h5dir_PowerVsRangeAndTime_v01a(indir, outdir, varargin)
%function [matPathList, figPathList] = ...
%            CLP_PowerVsRangeAndPulseFromHDFdir_(indir, outdir, numPulseToInt)
%
%  indir = input directory path full of hdf files from MUIR
%  outdir = output directory path to put .fig and .mat files
%  numPulseToInt = (optional) number of pulses to time-integrate. default is 10
%
%  Note that imagen.m available from http://www.mathworks.com/matlabcentral/
%  needs to be in the Matlab path.
%
%  Software execution has been verified with
%  Matlab R2008b on  October 2008 MUIR C996_4us data
%  
lic{1}='CLP_dir_PowerVsRangeAndTime_v01a.m';
lic{2}='MUIR/AMISR basic range-decoding software';
lic{3}='';
lic{4}='Copyright (C) 2009  Chris Fallen';
lic{5}='                    University of Alaska Fairbanks';
lic{6}='                    Fairbanks, AK 99775';
lic{7}='                    ctfallen@alaska.edu';
lic{8}=' ';
lic{9}='This program is free software: you can redistribute it and/or modify';
lic{10}='it under the terms of the GNU General Public License as published by';
lic{12}='the Free Software Foundation, either version 3 of the License, or';
lic{13}='(at your option) any later version.';
lic{14}=' ';
lic{15}='This program is distributed in the hope that it will be useful,';
lic{16}='but WITHOUT ANY WARRANTY; without even the implied warranty of';
lic{17}='MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the';
lic{18}='GNU General Public License for more details.';
lic{19}=' ';
lic{20}='You should have received a copy of the GNU General Public License';
lic{21}='along with this program.  If not, see <http://www.gnu.org/licenses/>.';
lic{22}=' ';

% there must be a better way!
for l=1:length(lic)
    disp(lic{l})
end

%% begin main program

% copy this file into output directory for provenance
mkdir(outdir)
copyfile([mfilename('fullpath') '.m'], outdir);

%% load data from hdf files in indir into two structures,
%  radar data and radar meta data, 
%  plot power vs range and time, save the images and .mat files
%  of decoded data into outdir

flist = dir(fullfile(indir, '*.h5'));

% number of pulses to integrate
if isempty(varargin)
    numPulseToInt = 10;
else
    numPulseToInt = varargin{1};
end

matPathList = cell(length(flist)-2,1);
figPathList = cell(length(flist)-2,1);
for fiter = 1:length(flist)
    fnin=fullfile(indir,flist(fiter).name);
    fnout=fullfile(outdir,flist(fiter).name);
    disp(['reading and decoding... ' flist(fiter).name])
    tic, [data,meta] = readAndDecodeClpDataFromHdf(fnin,numPulseToInt); toc
    matPathList{fiter} = [fnout(1:end-7) '.mat'];
    % disp(['saving data to... ' matPathList{fiter}])
    % tic, save(matPathList{fiter}, 'data', 'meta'); toc
    disp(['generating image and saving to... ' fnout(1:end-7) '.{fig,png}'])
    tic, figPathList{fiter} = ...
        plotPowerVsRangeAndPulse(data,meta,numPulseToInt,...
            fnout(1:end-7),'fig','png','eps');
            %fnout(1:end-7),'eps');
    save([fnout(1:end-2),'mat'], 'data','meta');
end    


%% plot power vs range and time
function outpath = plotPowerVsRangeAndPulse(data,meta,numPulseToInt,...
                    savepathName,varargin)

filteredDecodedSampleData = ...
            intFilterDecodedSampleData(data.decodedSampleData,...
            numPulseToInt);

outpath = [];

%% plot the data amplitude.  time axis could possibly use some work
if nargout >=0
    % set(0,'defaultfigurevisible','visible','off')
    % hf=figure('visible','off');
    hf=figure('color',[1 1 1],'outerposition',[0 0 1280 800]);
end
ha=axes('parent',hf,'fontname','calibri','fontsize',10);
set(hf,'currentaxes',ha)


colormap(jet(256))

% use a hardcoded noise sample
% noise = mean(mean(filteredDecodedSampleData([data.Range>250e3 & data.Range<=400e3], 500:1000))); 
noise = 2.600776345751986e+004;  % from d0009108.h5 in March 2009 campaign

imagesc(data.PulseTime,data.Range/1e3, ...
   (10*log10(filteredDecodedSampleData/noise)),'parent',ha);
set(gca,'ydir','normal')

caxis([0 18])
ylim([-25,650])
hc=colorbar('peer',gca);
set(get(hc,'ylabel'),'string','Maximum Fourier power SNR (dB)','fontname','calibri','fontsize',10)
set(ha,'xtick',data.MatlabTime(1,:))
set(ha,'ytick',0:50:650)
% set(ha,'ycolor',[1,1,1],'xcolor',[1,1,1])  % how do I change the color of
% the ticks while leaving the color of the ticklabels fixed?
set(ha,'xticklabel',{datestr(data.MatlabTime(1,:),'HH:MM:SS')},'fontname','calibri','fontsize',10)
% set(ha,'xticklabel',datestr(linspace(data.PulseTime(1),data.PulseTime(end),7),'HH:MM:SS'))
% datetick('x','keeplimits','keepticks')
set(ha,'xminortick', 'off')
set(ha,'yminortick', 'on')

% extract beam direction info for title
beamc = data.Beamcodes(1);
beaminfo = meta.BeamcodeMap(beamc == meta.BeamcodeMap(:,1), :);
elm=(beaminfo(3));
azm=(beaminfo(2));

hold on
set(get(ha,'xlabel'),'string','Universal Time (hh:mm:ss)','fontname','calibri','fontsize',10) % datestr(data.PulseTime(1)) ' UT']) 
set(get(ha,'ylabel'),'string','Range (km)','fontname','calibri','fontsize',10)
set(get(ha,'title'),'string',...
    ['(' num2str(azm) ', ' num2str(elm) ')^{\circ} : ', ...
    datestr(data.MatlabTime(1,1),30) '.' ...
    datestr(data.MatlabTime(1,1),'FFF') ' -- ' ...
    datestr(data.MatlabTime(2,end),30) '.' ...
    datestr(data.MatlabTime(2,end),'FFF')],'fontname','calibri','fontsize',10) % ...
  %  ', ' num2str(numPulseToInt) ' pulse integration'])
set(hf,'color',[1 1 1])

% set(gca,'ydir','normal')

if nargin >= 5
    for aiter = 1:length(varargin)
    switch lower(varargin{aiter})
        case 'fig'
            outpath = [savepathName '.fig'];
            hgsave(hf,outpath)
        case 'png'
            outpath = [savepathName '.png'];
            print(hf,'-dpng','-r0', outpath)
        case 'jpg'
            outpath = [savepathName '.jpg'];
            print(hf,'-djpg','-r0', outpath)
        case 'eps'
            outpath = [savepathName '.eps'];
            print(hf,'-depsc','-tiff','-r0', outpath)
        otherwise
            display('unknown save option. figure not saved')
    end
    end
end

close(hf)


%% Integrate decoded sample data
function filteredDecodedSampleData = ...
            intFilterDecodedSampleData(decodedSampleData, numPulseToInt)

% easy use of the filter command, integrate numPulseToInt pulses in time
% using a moving window.  Remember that decodedSampleData is complex

filteredDecodedSampleData = filter(ones(1,numPulseToInt)/numPulseToInt,1,...
                                (decodedSampleData),[],2); 



function [data, meta] = readAndDecodeClpDataFromHdf(fn,numPulseToInt)

[data, meta] = readMuirHdfFile(fn);

PC = meta.PhaseCode;

% "silence" the first portion of the phase code to reduce ground clutter
% set this to zero to see the full longpulse data
% silenceCodeLen = 60;
% silenceCodeLen = 296/8;
silenceCodeLen = 0 * ceil(296/2);
% silenceCodeLen =ceil(296/2);
% silenceCodeLen = 222;
% silenceCodeLen = 0;

% decode each range bin by
% sampling the range bins above, 
% array-multiplying by the code,
% calculating the frequency power spectrum
% taking the maximum power
% normalizing (or not)
% time integrating the power (or not)
ddecodedSampleData=[];
mPhaseCode=meta.PhaseCode;
mPhaseCode = [zeros(1,silenceCodeLen), mPhaseCode(silenceCodeLen+1:end)];
dSampleData=data.SampleData;
disp('rows remaining:')
parfor rbin=1:size(data.SampleData,1),
    PC=[zeros(1,rbin-1) mPhaseCode zeros(1,size(dSampleData,1))];
    PC=PC(1:size(dSampleData,1));
       tmp = filter(ones(1,numPulseToInt)/numPulseToInt,1,abs(fft(dSampleData .* (PC.' * ones(1,size(dSampleData,2))),[],1)).^2);
       % % with normalization
       % ddecodedSampleData(rbin,:) = max(tmp)./sum(tmp);
       % % without
       ddecodedSampleData(rbin,:) = max(tmp);
       if mod(rbin,100) == 0, disp(['     ' num2str(rbin)]), end
end
data.decodedSampleData=ddecodedSampleData;


function [data, meta] = readMuirHdfFile(hdfFilePath)
%
% function [data, meta] = readMuirHdfFile(hdfFilePath)
%
% Extracts selected MUIR (AMISR) data from SRI receiver 
%
% hdfFilePath is a file path to a SRI receiver .h5 data file.
%
% data is a Matlab structure containing selected time-dependent receiver
% data extracted from the .h5 file.
%
% meta is a Matlab structure containing time-independent receiver data
% extracted from the .h5 file
%
% Limitations include:
%     1. Only works with fixed single-beam data
%
% Other notes:
%     1. This is experimental software still in development, user beware!
%
%
% Chris Fallen 
% June 2009 
%
%
% (du) range vs. time table of complex amplitudes
data.SampleData = hdf5read( hdfFilePath,...
                            '/Raw11/Data/Samples/Data');
data.SampleData = reshape(...
                      complex(data.SampleData(1,:,:,:),...
                      data.SampleData(2,:,:,:)),...
                      size(data.SampleData,2),...
                      size(data.SampleData,3)*size(data.SampleData,4));

% (dp) Integrated range vs. time data, 
data.PowerData = hdf5read( hdfFilePath,...
                            '/Raw11/Data/Power/Data');
data.PulsesIntegrated = hdf5read( hdfFilePath,... 
                            '/Raw11/Data/PulsesIntegrated');
                        
data.MatlabTime = hdf5read( hdfFilePath,...
                            '/Time/MatlabTime');
data.Range = hdf5read( hdfFilePath,...
                            '/Raw11/Data/Samples/Range');
data.BeamCode = hdf5read( hdfFilePath,...
                            '/Raw11/Data/RadacHeader/BeamCode');
data.Beamcodes = hdf5read( hdfFilePath,...
                            '/Raw11/Data/Beamcodes');
data.PulseCount = hdf5read( hdfFilePath,...
                        '/Raw11/Data/RadacHeader/PulseCount'); 

                    
% The time of each pulse is in radac time,
data.PulseTime = datenum([repmat([1970,1,1,0,0],numel((data.PulseCount)),1) ...
                          reshape(hdf5read( hdfFilePath,... 
                            '/Raw11/Data/RadacHeader/RadacTime'),...
                            1,[]).']).';

%% radar meta data                    
meta.TransmitFreq = hdf5read(hdfFilePath , '/Tx/TuningFrequency');
meta.SampleTime = hdf5read( hdfFilePath, '/Rx/SampleTime')';
meta.BeamcodeMap = hdf5read( hdfFilePath, '/Setup/BeamcodeMap').'   ;

[meta.IPP, meta.StartTime4Rx, meta.StartTime4Tx] = ...
    getTimingUnitFileData(hdfFilePath);

meta.PhaseCode = getExperimentFileData(hdfFilePath);

meta.ReceivingCenterFrequency = hdf5read( hdfFilePath,   ...
                            '/Rx/TuningFrequency')';

meta.ReceivingBandWidth = hdf5read( hdfFilePath,         ...
                            '/Rx/Bandwidth')';

                        
%                         
% % get the sample time
% RadarParam.SampleTime = cast( hdf5read( hdfFilePath,...
%                                       '/Rx/SampleTime'), 'double');
%                                   
% % get sampling rate
% RadarParam.SamplingRate  = cast( hdf5read( hdfFilePath,...
%                                 '/Rx/SampleRate'), 'double');
%                      
% 
% % get Pulse Length
% % PulseLength           : pulse length (s)
%  RadarParam.PulseLength = floor(cast( hdf5read(hdfFilePath,...
%                               '/Raw11/Data/Pulsewidth'), 'double'));
%                           

                          
% process the timing unit file in the hdf file.  it would be much if I knew
% where this information was encoded properly in the hdf file rather
% than resorting to parsing a big string                          
function [IPP, StartTime4Rx, StartTime4Tx] = ...
              getTimingUnitFileData(hdfFilePath)

tufile = hdf5read(hdfFilePath,'/Setup/Tufile');
tufstr = tufile.data;

%%% Generate character array from string
newlines = regexp(tufstr, '\n');
idx = 1;
tufCharArr = [];
for ii = 1:length(newlines)
    tmpLine = tufstr(idx+1:newlines(ii)-1);
    idx = newlines(ii);
    tufCharArr = strvcat(tufCharArr, tmpLine);
end


%% Pick up transmiter start time from timing unit file
BitChar = strmatch('-2', tufCharArr);   
tmpLineArr = tufCharArr(BitChar,:);
TxStartChar = [];
for ii = 1:length(BitChar)
    tmp = findstr(tmpLineArr(ii,:), 'Tx profile 1');
    if ~isempty(tmp)
        TxStartChar = [TxStartChar; tmpLineArr(ii,6:8)];
    end   
end

StartTime4Tx = str2num(TxStartChar);

%% Inter  Pulse Period (IPP)
BitChar = strmatch('-1', tufCharArr);
IPPChar = strvcat(tufCharArr(BitChar,11:16));
IPP = str2num(IPPChar)*1e-5;  % convert to (s)


%% start time of sampling
BitChar = strmatch(' 7', tufCharArr);
RxStartChar = strvcat(tufCharArr(BitChar,6:8));
StartTime4Rx  = str2num(RxStartChar);

%% get phase coding from experiment file field.  it would be much if I knew
% where this information was encoded properly in the hdf file rather
% than resorting to parsing a big string
function PhaseCode = getExperimentFileData(hdfFilePath)

expfile = hdf5read(hdfFilePath,'/Setup/Experimentfile');
expstr = expfile.data;

isCoded=regexp(expstr,'Name\=C');

if isCoded
% CTF2008 Attempt to parse the experiment file in order to extract the
% phase code used
 expstr = regexprep(expstr,'\;Code\=','');
 expstr = regexprep(expstr,'\n','');
 
 u = strfind(expstr,'+');
 v = strfind(expstr,'-');
 u = u(u<=500);
 v = v(v<=500);
 
% try to extract code length without using pulse length and baud length 
% codeLen = 996/4;
codeLen = length([u(:); v(:)]);

PhaseCode = zeros(1,codeLen);
codeStartIdx = min([u(:); v(:)]);

PhaseCode((u-codeStartIdx)+1) = 1;
PhaseCode((v-codeStartIdx)+1) = -1;

else % pulse is not coded

    % this is probably an OK method of determining the phase code length
    % for the coded pulse as well.  consider removing the string parsing
    % above.  CTF20090619
    pulseWidth = hdf5read(hdfFilePath,'/Raw11/Data/Pulsewidth');  % seconds
    sampRate =  hdf5read(hdfFilePath,'/Rx/SampleRate');  % (1/seconds)
    codeLen =  pulseWidth / (1/sampRate);
    PhaseCode = ones(1,codeLen);
    
end




