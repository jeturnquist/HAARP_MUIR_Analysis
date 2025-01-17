function [ CurrentData ] = func_CalSpectraInfo4uCLP_SRIRx(...
                                CurrentData, RadarParam, GenParam       ...
                              , InputParam)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_CalSpectraInfo4uCLP_SRIRx.m
%          made by J. Tunrquist, GI UAF
%
%          ver.1.0: July-9-2008
%          ver.1.1: Jan-10-2009: fixed frequency offset
%          ver.1.2: Jan-29-2009: function mean2 deprecated in MATLAB 2008
%
%       Perform spectrum analysis on selected data sets for uncoded long
%       pulse data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global DCKNOB

NumBeams = size(CurrentData.BeamCodes);
time_idx = GenParam.TimeIdx;

if ~GenParam.Factor4IntTime
    IntegrationTime = CurrentData.PulsesIntegrated;
else
    IntegrationTime = GenParam.Factor4IntTime;
end% ~GenParam.Factor4IntTime
    
%% initialize empty cell arrays for each beam direction
SNRArr     = cell(NumBeams(1),1);
PSDArr     = cell(NumBeams(1),1);
SNRinDBArr = cell(NumBeams(1),1);
PSDinDBArr = cell(NumBeams(1),1);

%% threshhold for minimum SNR
thresh = 0.1;
RangeLength = size(CurrentData.du_sorted{1},1);

if ~time_idx;
    NumberOfIntegrations = size(CurrentData.du_sorted{1},2);
else
   NumberOfIntegrations =...
       size(CurrentData.du_sorted{1}(:,time_idx(1):time_idx(end)),2);
end

for beam_idx = 1:1:NumBeams(1)
    for ssInt = 1:IntegrationTime:NumberOfIntegrations
        if ~time_idx;
            du = CurrentData.du_sorted{beam_idx};
        else
            du = CurrentData.du_sorted{beam_idx}(:,time_idx(1):time_idx(end));
        end

        %% Integration time
        eeInt = ssInt + IntegrationTime - 1;

        %% Selected Range
        range = CurrentData.Range;
        idx_lower = find(range >= GenParam.LowerHeight*1000);    
        idx_upper = find(range <= GenParam.UpperHeight*1000);
        ssRng = idx_lower(1);
        eeRng = idx_upper(end);

        %% Calculate Power
%             selected_du = du(ssRng:eeRng, ssInt:eeInt);

        if eeInt > size(du,2)
            eeInt = size(du,2);
        end

        selected_du = du(ssRng:eeRng,ssInt:eeInt);
        dp = du(ssRng:eeRng,ssInt:eeInt).*conj(du(ssRng:eeRng,ssInt:eeInt));
        dp = mean(dp,2);
        %% Calculate noise 
        noise = mean(mean(du(end-10:end).*conj(du(end-10:end)) ));

        %% Calculate Signal to Noise Ratio
        snr = (dp - noise)/noise;
%             snr = snr(ssRng:eeRng,:);
        idx = find(snr < thresh);
        snr(idx) = thresh;

        %% Signal to Noise Ratio in Decibal
        snrdb = 10*log10(snr);

        %% Calculate Power Spectral Density
        tmp_psd = fftshift(fft(selected_du));
        psd = tmp_psd.*conj(tmp_psd);
        psd = mean(psd,2);

        idx = find(psd <= 0);
        psd(idx) = thresh;
        psd_db = 10*log10(psd);


        %% Concatonate arrays
        SNRArr{beam_idx}        = [ SNRArr{beam_idx}, snr ];
        PSDArr{beam_idx}        = [ PSDArr{beam_idx}, psd ];
        SNRinDBArr{beam_idx}    = [ SNRinDBArr{beam_idx}, snrdb ];
        PSDinDBArr{beam_idx}    = [ PSDinDBArr{beam_idx}, psd_db];


    end %for Iint
end %for length(BeamCodes)

%%% Save Data to Structures
CurrentData.SNRArr      = SNRArr;
CurrentData.PSDArr      = PSDArr;
CurrentData.SNRinDBArr  = SNRinDBArr;
CurrentData.PSDinDBArr  = PSDinDBArr;


%% Create Frequency Array
FitRange = size(SNRinDBArr{1},1);

FreqWidth = RadarParam.SamplingRate; %Hz
TransFreq = RadarParam.TransmitFreq; %Hz
RecCenterFreq   = RadarParam.ReceivingCenterFrequency(1);  %Hz


% fHF = RecCenterFreq/1e6 - 21;
fHF = RecCenterFreq/1e6 - 446 - 20 + DCKNOB;

CenterFreq = fHF;
FreqRes = FreqWidth/FitRange;
FreqArr = FreqRes:FreqRes:FreqWidth;
FreqArr = FreqArr - FreqWidth/2;

CurrentData.FreqArr = FreqArr/1e3 + CenterFreq;

clear SNRArr
clear PSDArr
clear SNRinDBArr
clear PSDinDBArr