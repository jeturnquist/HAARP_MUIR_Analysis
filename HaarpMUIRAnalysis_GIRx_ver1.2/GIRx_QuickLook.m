function GIRx_QuickLook

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       GIRx_QuickLook.m
%          made by J. Tunrquist, GI UAF
%
%          ver.1.0: July-18-2009 
%          ver.1.1: Aug-10-2009 : fixed binary read
%
%           TO DO: Make readBinaryData function faster, currently this is
%                   the bottle neck in the program.
%
%       Quick look of GIRx data. Plots Power as a function of Time vs Range
%       (No spectral analysis)
%
%       At least one SRIRx data file from the same experiment is needed.
%   
%       This program is all inclusive, that is, there is only one m-file which
%       contains all pertinent fnctions.
%  
%   --------
%    Usage:
%   --------
%         For this QuickLook to work TWO data files are needed. First a SRI
%       Reciever (SRIRx) data file (*.h5) from the same experiment as the 
%       GI Reciver (GIRx) data that is being viewed. The second data file
%       needed is the GIRx data file (*.dat) to be viewed.
%
%         To make selecting data files easier, a GUI will open to the
%       directory defined by DataDirectory4SRIR and DataDirectory4GIR.
%         If no directory path is given, the GUI will open in the current
%       MATLAB directory, i.e. the directory which contains GIRx_QuickLook.m
%
%       -----------------------------------------------
%        The SRIRx data file supplies the information:
%       -----------------------------------------------
%          > IPP         - Inter Pulse Period
%          > TxStartTime - Transmitter start time
%          > RxStartTime - Reciever start time
%          > PulseLength
%          > SampleTime  - Baud Length (Not to be confused with the 
%                           Sampling Rate)
%          > Reciever center frequency - Not to be confused with the Down
%               Converter Knob setting
%
%       ----------------------------------
%        Required user defined paramters: 
%       ----------------------------------
%         These are paramaters that cannot be obtained from the SRIRx data
%        file or they may differ from the SRIRx paramters (Noteably the
%        Sampling Rate)
%
%          > PulseType      - CLP (Coded Long Pulse)
%                             uCLP (unCoded Long Pulse)
%          > DCKNOB         - Down converter knob setting (MHz)
%                               445 : Ionline
%                               450 : Downshifted plasma line 
%                               440 : Upshifted plamsa line 
%          > SamplingRate   - kHz (may differ from SRIRx)
%          > UpperRange     - Upper range for analysis (km)
%          > LowerRange     - Lower range for analysis (km)   
%          > TimeIntegraton - Integration time (ms)
%
%       -----------------------------------------------
%        Data directory for SRIRx and GIRx data files: 
%       -----------------------------------------------
%          > DataDirectory4SRIR - Directory for SRIRx data files
%          > DataDirectory4GIR  - Directory for GIRx data files
%
%
% NOTE:   The directory paths cannot contain spaces when  
%       running GIRx_QuickLook.m on a windows machince. MATLAB uses the
%       local command line (i.e DOS-prompt in windows). DOS-prompt does not
%       support spaces in directory names and it is not possible to escape
%       the spaces (if I am wrong please let me know). 
%         Thus, either place the data in a directory path containing no
%       spaces or use the windows short name convention.
%           'C:\Documents and Settings' --> 'C:\DOCUME~1' (short name)
%
%         On a *nix system it is possible to escape spaces using a
%       backslash (\).
%            '/PARS summer school 2007' --> '/PARS\ summer\ school\ 2007'
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set global variables
%%

global DCKNOB;          
global PulseType      
global SamplingRate   
global UpperRange      
global LowerRange 
global RangeOffsetValue 
global IntegrationTime 
global CenterFreqFromRadarFreq;

%% User defined parameters
%%

PulseType           = 'uCLP';       %% uCLP : Uncoded Long Pulse
                                    %% CLP  : Coded Long Pulse

                        
                        
                             %% Down converter knob selection (MHz)
DCKNOB              = 445;   %% 445 : Ionline
                             %% 450 : Downshifted plasma line 
                             %% 440 : Upshifted plamsa line 
                                    
SamplingRate        = 1000;  %% kHz  

UpperRange          = 400;   %% km

LowerRange          = 150;   %% km

IntegrationTime     = 10;    %% micro-seconds

%---------------------------------------------------
%%% Data directory for SRIRx and GIRx data files. 
%---------------------------------------------------

% DataDirectory4SRIR  = ['test_data/'];
% DataDirectory4GIR   = ['test_data/'];
% Directory4SRIRxData =  ...
%     '/Users/jet/Work/Data/Oct2008/SRIRx/';
DataDirectory4SRIR  = '/Users/jet/Work/Data/Oct2008/SRIRx/';
DataDirectory4GIR   = '/Users/jet/Work/Data/Oct2008/GIRx/';



%% End User defined parameters
%%




%% Check input arguments
%%

disp(['-----------------------------------------------------']);    
disp([' Use Arguments ']);
disp(['-----------------------------------------------------']);
disp(['Down Converter Knob        : ', num2str(DCKNOB)]);    
disp(['Pulse Type                 : ', PulseType]);
disp(['Sampling Rate (kHz)        : ', num2str(SamplingRate)]);
disp(['Upper Range (km)           : ', num2str(UpperRange)]);
disp(['Lower Range (km)           : ', num2str(LowerRange)]); 
disp(['Time Integration           : ', num2str(IntegrationTime)]);
disp(['----'])
response = input('Continue y/n [y]: ', 's');
if isempty(response)
    response = 'y';
end

if ~strcmp(response, 'y')
    return;
end
        

%% GUI prompt to select data files
%%
%%% GUI prompt to select SRIRx data file
prompt = ['Select SRIRx data file'];
SRIRxDataFileChar   = locateDataFile(...
    [DataDirectory4SRIR, '*.h5'], prompt);

%%% GUI prompt to select GIRx data file
prompt = ['Select GIRx data file'];
GIRxDataFileChar    = locateDataFile(...
    [DataDirectory4GIR, '*.dat'], prompt);


%% Reciever parameters
%%
tufile = hdf5read(SRIRxDataFileChar,'/Setup/Tufile');
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
IPP = str2num(IPPChar);


%% start time of sampling
BitChar = strmatch(' 7', tufCharArr);
RxStartChar = strvcat(tufCharArr(BitChar,6:8));
StartTime4Rx  = str2num(RxStartChar);

%%% get the sample time
SampleTime = cast( hdf5read( SRIRxDataFileChar,...
                                      '/Rx/SampleTime'), 'double');               

%%% get Pulse Length
% PulseLength           : pulse length (micro-second)
PulseLength = floor(cast( hdf5read(SRIRxDataFileChar,...
                              '/Raw11/Data/Pulsewidth'), 'double')*1e6);
                          
CenterFreqFromRadarFreq = hdf5read( SRIRxDataFileChar,...
                            '/Rx/TuningFrequency')';

%% Check Channels
%%
%------
% set parameters
%------
 switch DCKNOB
     case 440
         CenterFreqFromRadarFreq    = 26e6;
     case 445
         CenterFreqFromRadarFreq    = 21e6;
     case 450
         CenterFreqFromRadarFreq    = 16e6;
 end%switch DCKNum

 ChannelNum                 = 3;
 ChannelType                = char(ones(1,ChannelNum));
 
 
%------
% check the receiver channel type
%------
%%%
%%% iteration over ChannelNum
%%%
 for Ichannel = 1:ChannelNum
     %%% open the file
     fid   = fopen( GIRxDataFileChar, 'r' );
     
     
     %%% set parameters for reading parameters
     if Ichannel ~= 1
         fseek(fid,(Ichannel-1)*record_bytes,0);
     end%if Ichannel ~= 1
     
     
     %%% read data
     hdr          = fread(fid,4,'char');
     year         = fread(fid,1,'int');
     month        = fread(fid,1,'int');
     day          = fread(fid,1,'int');
     hour         = fread(fid,1,'int');
     minutes      = fread(fid,1,'int');
     second       = fread(fid,1,'int');
     nsecond      = fread(fid,1,'int');
     record_size  = fread(fid,1,'int');
     record       = fread(fid,1,'int');
     freq         = fread(fid,1,'int');
     sfreq        = fread(fid,1,'int');
     samples_to_collect = fread(fid,1,'int');
     
     
     %%% close the file
     fclose(fid);
     
     
     %%% calculate the size
     if Ichannel == 1
         record_bytes = 4*(samples_to_collect+13);
     end%if Ichannel == 1
     
     
     %%% check the receiver channel type
     FreqDel   = freq - CenterFreqFromRadarFreq;
     if FreqDel < 0
         ChannelType(Ichannel) = 'D';
     elseif FreqDel == 0
         ChannelType(Ichannel) = 'I';
     else
         ChannelType(Ichannel) = 'U';
     end%if FreqDel < 0
 end%for Ichannel;

%%% looking for a receiver channel for the ion-line measurement
 FitChannel4IL	= findstr(ChannelType,'I');
 FitChannel4UPL	= findstr(ChannelType,'U');
 FitChannel4DPL	= findstr(ChannelType,'D');

 
 
 
%% Determine the range offset value
%%
 [ hdr, du, years, months, days, hours, minutes,  ... 
   seconds, nseconds, freq ] =  ... 
    readGIRxBinaryData(GIRxDataFileChar, FitChannel4IL, 2); 




%% Read data from selected binary data file (*.dat)
%%
 [ hdr, du, years, months, days, hours, minutes,  ... 
   seconds, nseconds, freq ] =  ... 
    readGIRxBinaryData(GIRxDataFileChar, 0, 1); 

for ii = 1:1:3
    idx = find(isnan(du{ii}(:,1)));
    if ~isempty(idx)
        lch{ii} =  size(du{ii},1) - length(idx); 
        idx = find(isnan(du{ii}));
        if ~isempty(idx)
            du{ii}(idx) = 0;
        end
    else
        idx = find(isnan(du{ii}));
        if ~isempty(idx)
            du{ii}(idx) = 0;
        end
        lch{ii} = size(du{ii},1);
    end
end


%% Calculate the Noise for Power
%%
 [ Noise4Power1 ] = ...
     func_CalNoize4uCLP_SpectrumAna4GIR(du{FitChannel4IL});
 [ Noise4Power2 ] = ...
     func_CalNoize4uCLP_SpectrumAna4GIR(du{FitChannel4UPL});
 [ Noise4Power3 ] = ...
     func_CalNoize4uCLP_SpectrumAna4GIR(du{FitChannel4DPL});

 
%% Calculate the Power
%%
 disp( '   Calculating SNR, Power Spectra Density from the channel 2 ...' );
 ChannelNum  = FitChannel4IL;
 [ SNRvsTimeArr1, RangeArr1 ] =                ...
       func_CalSpectraInfo4uCLP_SpectrumVsTime4GIR(  ...
       du{FitChannel4IL}, Noise4Power1, ChannelNum );
   
 disp( '   Calculating SNR, Power Spectra Density from the channel 2 ...' );
 ChannelNum  = FitChannel4UPL;
 [ SNRvsTimeArr2, RangeArr2 ] =                ...
       func_CalSpectraInfo4uCLP_SpectrumVsTime4GIR(  ...
       du{FitChannel4UPL}, Noise4Power2, ChannelNum );
   
 disp( '   Calculating SNR, Power Spectra Density from the channel 3 ...' );
 ChannelNum  = FitChannel4DPL;
 [ SNRvsTimeArr3, RangeArr3 ] =                ...
       func_CalSpectraInfo4uCLP_SpectrumVsTime4GIR(  ...
       du{FitChannel4DPL}, Noise4Power3, ChannelNum );
 

   
%% Plot Power as a function of Range and Time   
%%
func_PlotSNRvsTime4uCLP_SpectrumAna4GIR(                ...
                SNRvsTimeArr1, SNRvsTimeArr2, SNRvsTimeArr3         ...
                , hours{1}, minutes{1}, seconds{1}, nseconds{1}, du{1})

clear

%% --------------------------- Begin Functions ----------------------------
%%


%% function to locate data directories/files
%%
    function [ DataFileChar ] = locateDataFile(DataDir, prompt)
        try dir(DataDir)
            [datafile, pathname] = uigetfile(DataDir, prompt);
        catch
            [datafile, pathname] = uigetfile;
        end
         DataFileChar = [pathname, datafile];
    end%%locateDataFile


%% function to read GIRx binary data from selected file
%%
    function [ hdr, du, years, months, days, hours, minutes,  ... 
               seconds, nseconds, freq ] =  ...
               readGIRxBinaryData(filename, ILCh, temp2)
        %%% much of this code is copied from sdrrad2.m

        %------
        % open the file
        %------
         fid  = fopen(filename);
        %------
        % calculate the data size
        %------

        %% read the header
        fseek(fid,4*8,-1);
        record_size = fread(fid,1,'int');

        fseek(fid,4*3,0);
        samples_to_collect = fread(fid,1,'int');

        %%% calculate the size
         record_bytes = 4*(samples_to_collect+13);

        %%% length of file in bytes
         fseek(fid,0,1); %% EOF
         file_length_bytes = ftell(fid); %% file length in bytes

         num_records = file_length_bytes / record_bytes;

        %%% get first channel ID 
        fseek(fid, 58, -1);
        framecount = fread(fid,1,'int16');
        chid = (framecount - 1000)/100; %%channel ID

        %%% use ion line channel to determine range offset
        if ILCh
            kk = 0;
            while 1
                fseek(fid, abs((ILCh-chid+kk))*record_bytes, -1);
                fseek(fid, 10*4, 0);
                tmpfreq = fread(fid, 1, 'int');
                if ~(tmpfreq - CenterFreqFromRadarFreq)
                    fseek(fid, abs((ILCh-chid+kk))*record_bytes, -1);
                    chid = ILCh;
                    break
                end
                kk = kk + 1;
            end
        else
            fseek(fid, 0, -1);
        end

        % fseek(fid, 0, -1);

        %%% prepare new arrays to be returned
         du       = cell(3,1);
         years    = cell(3,1);
         months   = cell(3,1);
         days     = cell(3,1);
         hours    = cell(3,1);
         minutes  = cell(3,1);
         seconds  = cell(3,1);
         nseconds = cell(3,1);
         freq     = cell(3,1);
         timestamp = cell(3,1); 	

         for ii = 1:1:3
             du{ii}       = nan(record_size,samples_to_collect);
             years{ii}    = zeros(record_size,1);
             months{ii}   = zeros(record_size,1);
             days{ii}     = zeros(record_size,1);
             hours{ii}    = zeros(record_size,1);
             minutes{ii}  = zeros(record_size,1);
             seconds{ii}  = zeros(record_size,1);
             nseconds{ii} = zeros(record_size,1);
         end


        %------
        % read data
        %------
        kk = 0;
         for ii = 1:num_records
            %%% Check Channel ID for each record
            if ~ILCh
                fseek(fid, 58,0);
                framecount = fread(fid, 1, 'int16');
                chid = (framecount - 1000)/100;
                fseek(fid, -60, 0);
            end
             hdr{chid}(ii-kk,:)        	= fread(fid,4,'char');
             years{chid}(ii-kk,:)     	= fread(fid,1,'int');
             months{chid}(ii-kk,:)    	= fread(fid,1,'int');
             days{chid}(ii-kk,:)       	= fread(fid,1,'int');
             hours{chid}(ii-kk,:)      	= fread(fid,1,'int');
             minutes{chid}(ii-kk,:)    	= fread(fid,1,'int');
             seconds{chid}(ii-kk,:)    	= fread(fid,1,'int');
             nseconds{chid}(ii-kk,:)  	= fread(fid,1,'int');
             record_size               	= fread(fid,1,'int');
             record                   	= fread(fid,1,'int');
             freq{chid}               	= fread(fid,1,'int');
             sfreq                    	= fread(fid,1,'int');
             samples_to_collect         = fread(fid,1,'int');

             %% the following is a small header 8 bytes long at the beggining of
             %% each IPP
             timestamp{chid}(ii-kk,:) 	= fread(fid,1,'int'); %% added by Todd Paris 4 bytes
             ch                       	= fread(fid,1,'int16'); %% added by Todd Paris 2 bytes
             framecount             	= fread(fid,1,'int16'); %% added by Todd Paris 2 bytes
%              chid = (framecount - 1000)/100;

             %% store data in cell array 

             for jj=1:(samples_to_collect-2)
                 du{chid}(ii-kk,jj) = complex(fread(fid,1,'int16'),fread(fid,1,'int16'));
             end

            %% Increment through the 3 channels
            if chid == 3
        %         chid = 0; %% reset channel ID to 1
                kk = kk - 1;
            end
        %     chid = chid + 1;
            kk = kk + 1;

            %%% calculate the range offset value
            %%% global: RangeOffsetValue: range offset value (km)
            if ii == 1 && temp2 == 2

                switch char(PulseType)
                    case {'CLP'}%for coded long pulse
                        func_CalRangeOffsetValue_Decode4CLP_SpectrumAna4GIR(du{ILCh}(1,:));
                    case {'uCLP'}%for coded long pulse
                        func_CalRangeOffsetValue_4uCLP_SpectrumAna4GIR(du{ILCh}(1,:));
                end%switch char(SelPulseCodingType)
       
                %%% show the range offset value on the display
                RangeOffsetValueChar  = num2str( RangeOffsetValue );
                TmpChar               = [ '  # Range offset value (km): ' ];
                TmpChar               = [ TmpChar RangeOffsetValueChar ];
                disp( TmpChar );


                %%% prepare dami data
                hdr         = -9999;
                du          = -9999;
                years       = -9999;
                months      = -9999;
                days        = -9999;
                hours       = -9999;
                minutes     = -9999;
                seconds     = -9999;
                nseconds	= -9999;
                freq        = -9999;


                %%% return
                return
            end%if i == 1 & temp2 == 2
         end%for i

        %------
        % close the file
        %------
         fclose(fid);
    end%%readGIRxBinaryData



%% Calculate Range offset for Coded Long Pulse
%%
    function func_CalRangeOffsetValue_Decode4CLP_SpectrumAna4GIR(du)
        %------
        % set parameters
        %------
         c                        = 2.99792458e8;
         InitialOffsetDataNumber  = ceil(400/BaudLength);
         SearchWidthDataNumber    = fix(200/BaudLength);


        %------
        % calculate the power
        %------
         dp   = du.*conj(du);

        %------
        % search the offset value
        %------
         MeanNoiseLevel     = mean(10*log10(dp(1:InitialOffsetDataNumber-2)));
         ss                 = InitialOffsetDataNumber;
         ee                 = InitialOffsetDataNumber + SearchWidthDataNumber;
         DiffValue          = 10*log10(dp(ss:ee)) - MeanNoiseLevel;
          TmpThresh          = 30;
         FirstLargeValueNum = find( abs(DiffValue) > TmpThresh );
         ss                 = FirstLargeValueNum(1)+ss-1;

        %------
        % calculate range offset value
        %------
         RangeOffsetValue  = ss-0.5;
         RangeOffsetValue  = RangeOffsetValue*BaudLength * c/1e6/1e3/2;


        %------
        % check the result
        %------
         FigureNumber = figure;
         range = (1:length(dp))*c*BaudLength*1e-6/1e3/2;
         range = range - RangeOffsetValue;
         semilogx(dp,range)
         ylim([ -100 200 ])
         hold on
         plot(xlim,zeros(1,2),'r:');
         ylabel( 'Range (km)' )
         xlabel( 'Backscatter echo power (a.u.)')

         Answer  = input( 'Check the range calibration (y/n): ', 's' );
         if Answer == 'y'
             close(FigureNumber);
             return
         else
             pause
         end%if Answer == 'y'
    end%%func_CalRangeOffsetValue_Decode4CLP_SpectrumAna4GIR


%% Calculate range offset for Uncoded Long Pulse
%%
    function func_CalRangeOffsetValue_4uCLP_SpectrumAna4GIR(du)
        %------
        % set parameters
        %------
        c                        = 2.99792458e8;

        InitialOffsetDataNumber  = ceil((StartTime4Tx-StartTime4Rx)*1e-6   ...
                                    *(SamplingRate*1e3));
        SearchWidthDataNumber    = 2000;

        %------
        % calculate the power
        %------
        dp   = du.*conj(du);

        %------
        % search the offset value
        %------

         MeanNoiseLevel     = mean(10*log10(dp(1:InitialOffsetDataNumber-2)));
         ss                 = InitialOffsetDataNumber;
         ee                 = InitialOffsetDataNumber + SearchWidthDataNumber;
         DiffValue          = 10*log10(dp(ss:ee)) - MeanNoiseLevel;
         TmpThresh          = 44;
        %  TmpThresh          = 50;
         FirstLargeValueNum = find( abs(DiffValue) > TmpThresh );
         ss                 = FirstLargeValueNum(1)+ss-1;


        %------
        % calculate range offset value
        %------
         RangeOffsetValue  = ss-0.5;
         PulseLength = 996;
          RangeOffsetValue  =                                            ...
             ( RangeOffsetValue+(PulseLength*1e-6*SamplingRate*1e3)/2 ) ...
             /(SamplingRate*1e3)* c/1e3/2;


        %------
        % check the result
        %------
         FigureNumber = figure;
         range = (1:length(dp))*c*1/(SamplingRate*1e3)/1e3/2;
         range = range - RangeOffsetValue;

         semilogx(dp,range)
         ylim([ -100 200 ])
         hold on
         plot(xlim,zeros(1,2),'r:');
         ylabel( 'Range (km)' )
         xlabel( 'Backscatter echo power (a.u.)')

         Answer  = input( 'Check the range calibration (y/n): ', 's' );
         if Answer == 'y'
             close(FigureNumber);
             return
         else
             pause
         end%if Answer == 'y'

        close('all')
    end%%func_CalRangeOffsetValue_4uCLP_SpectrumAna4GIR


%% function Calculate Noise for Power
%% 
    function [ Noise4Power ] = ...
         func_CalNoize4uCLP_SpectrumAna4GIR(du)
        %------
        % set parameters
        %------
         c = 2.99792458e8; % speed of light


        %% range to be analyzed
         BitLength4PulseLength = ceil(PulseLength*1e-6*SamplingRate*1e3);

         RangeNum       = length(du(1,:));
         FitRange4Noise	= (RangeNum - BitLength4PulseLength + 1):RangeNum;

        %% adjust the range selection
         sel_du         = du(:,FitRange4Noise);
         Power          = sel_du.*conj(sel_du);
         MeanPower      = mean(Power);
         GrossMeanPower = mean(Power(:));
         Threshold      = 10; 
         FitLarge       = find( MeanPower > GrossMeanPower*Threshold );
         DownShiftValue = FitLarge(1);
         FitRange4Noise	= FitRange4Noise - DownShiftValue;
        
        %------
        % calculate the PSD
        %------
        %% select du data
         sel_du   = du(:,FitRange4Noise)';
         sel_du  = conj(sel_du);
                            %new line on 07-18-06
                            %following with suggestion from R. Todd Parris
        %% Power
          Noise4Power = sel_du.*conj(sel_du);
          Noise4Power = mean(Noise4Power(:));
    end%%func_CalNoize4uCLP_SpectrumAna4GIR

%% Calculate Power
%%

    function [ SNRArr, RangeArr ] =                   ...
               func_CalSpectraInfo4uCLP_SpectrumVsTime4GIR(  ...
               du, noise, ChannelNum )

        %------
        % parameters
        %------
         c           = 2.99792458e8;% speed of light
         RadarFreq   = 446;% MHz

        %------
        % calculate the parameters
        %------
        %%% set parameters
         TmpSize                 = size(du);
         TimeNum                 = TmpSize(1);
         RangeNum                = TmpSize(2);

        %%% range
         range = (1:RangeNum)*c*1/(SamplingRate*1e3)/1e3/2;
         range = range - RangeOffsetValue;

         %%% range to be analyzed
         FitRange   = find( range >= LowerRange & range <= UpperRange );

        %%% estimate the iteration number following the integration time
         TimeNum4Integration = fix( TimeNum/IntegrationTime );

        %%% iteration over the integration time
         for Iint = 1:TimeNum4Integration
             %%% start & end time-element number
             st    = 1 + IntegrationTime*(Iint-1);
             et    = st + IntegrationTime - 1;

             %%%%%% display
             TmpChar    = [ 'Time:' num2str(Iint) '/'        ...
                            num2str(TimeNum4Integration) ];
             disp( TmpChar )

             sel_du  = du(st:et,FitRange)';
             %%%%%% Signal to Noise Ration (SNR)

             dp  = sel_du .* conj(sel_du);
             snr = (dp - noise)/noise;

             %%% product from the spectral analysis
             if Iint == 1
                 SNRArr   = snr;
                 RangeArr   = range;
             else
                 SNRArr   = [ SNRArr, snr ];
             end%if Iint == 1

         end%for Iint
    end%%func_CalSpectraInfo4uCLP_SpectrumVsTime4GIR



%% function Plot Power as a function of Altitude vs Time
%%
    function  func_PlotSNRvsTime4uCLP_SpectrumAna4GIR(          ...
                SNRArr1, SNRArr2, SNRArr3     ...
                , hours, minutes, seconds, nseconds, du) 

        c           = 2.99792458e8;% speed of light


        figure( 'Position', [ 100 100 600 800 ] )

        %%% Seconds
        TmpSeconds1     = seconds';
        TmpNseconds1    = nseconds';


        %% PSD in decibels
        %%
        idx1 = find(SNRArr1<.1);
        SNRArr1(idx1) = 0.1;
        idx2 = find(SNRArr2<.1);
        SNRArr2(idx2) = 0.1;
        idx3 = find(SNRArr3<.1);
        SNRArr3(idx3) = 0.1;

        SNRvsTimeinDBArr1 = 10*log10(SNRArr1);
        SNRvsTimeinDBArr2 = 10*log10(SNRArr2);
        SNRvsTimeinDBArr3 = 10*log10(SNRArr3);


        %% Time
        %%
        TmpChar	= num2str(hours(1));
        HH    	= func_CheckCharLength(TmpChar , 2, '0');

        TmpChar	= num2str(minutes(1));
        MM      = func_CheckCharLength(TmpChar, 2, '0');

        TmpChar	= num2str(seconds(1));
        SS      = func_CheckCharLength(TmpChar , 2, '0');

        TmpChar	= num2str(nseconds(1));
        NN      = func_CheckCharLength(TmpChar, 2, '0');


        TimeChar	= [ HH, ':', MM, ':',SS ];

        idx = find(isnan(TmpSeconds1));
        if isempty(idx)
            idx  = length(TmpSeconds1)+1;
        end

         NewTimeArrInSecond     = TmpSeconds1(1:idx-1) + TmpNseconds1(1:idx-1)/1e9 ...
                                - TmpSeconds1(1);
         FitNegative            = find( NewTimeArrInSecond < 0 );
         if length( FitNegative ) ~= 0
             NewTimeArrInSecond( FitNegative ) = ...
                 NewTimeArrInSecond( FitNegative ) + 60;
         end%if length( FitNegative ) ~= 0

        TimeRangeValue  = [ NewTimeArrInSecond(1), NewTimeArrInSecond( end ) ];

         range = (1:size(du,2))*c*1/(SamplingRate*1e3)/1e3/2;
         range = range - RangeOffsetValue;
        %  range = range - 94;
         FitRange   = find( range >= LowerRange & range <= UpperRange );

         range = range(FitRange);
        %% Plot
        %%

        IntegrationChar = IPP * IntegrationTime / 1000;
                         IntegrationChar = [ num2str(IntegrationChar) ' ms' ];

        caxis = [ -10 25 ];
        % caxis = [ 50 70 ];

        %%% Channel 1: Ion Line
        subplot(3,1,1)
        imagen(TimeRangeValue, range, SNRvsTimeinDBArr1, caxis);
        title({[ '\fontsize{10}\bf SNR(db): \fontsize{8}\rm integration time ' IntegrationChar  ]; ...
               [ '\fontsize{10}\bf Channel 1: Ion Line' ]});
        ylabel([ '\fontsize{10}\bf Range(km)' ])
        xlabel({[ '\fontsize{10}\bfTime \fontsize{8}\rm(seconds from ', ...
                TimeChar, ' )' ]; ['']})
        colorbar


        %%% Channel 2: Upshifted Plasma Line
        subplot(3,1,2)
        imagen(TimeRangeValue, range, SNRvsTimeinDBArr2, caxis);
        title([ '\fontsize{10}\bf Channel 2: Upshifted Plasma Line' ])
        ylabel([ '\fontsize{10}\bfRange(km)' ])
        xlabel({[ '\fontsize{10}\bfTime \fontsize{8}\rm(seconds from ', ...
                TimeChar, ' )' ]; ['']})
        colorbar


        %%% Channel 3: Downshifted Plasma Line
        subplot(3,1,3)
        imagen(TimeRangeValue, range, SNRvsTimeinDBArr3, caxis);
        title([ '\fontsize{10}\bf Channel 3: Downshifted Plasma Line' ])
        ylabel([ '\fontsize{10}\bfRange(km)' ])
        xlabel({[ '\fontsize{10}\bfTime \fontsize{8}\rm(seconds from ', ...
                TimeChar, ' )' ]; ['']})
        colorbar

    end%% func_PlotSNRvsTime4uCLP_SpectrumAna4GIR





end%%GIRx_QuickLook