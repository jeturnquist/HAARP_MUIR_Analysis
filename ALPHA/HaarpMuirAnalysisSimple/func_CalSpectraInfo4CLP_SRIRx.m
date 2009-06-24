function [ CurrentData ] = func_CalSpectraInfo4CLP_SRIRx(...
                                CurrentData, RadarParam, GenParam       ...
                              , InputParam)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_CalSpectraInfo4CLP_SRIRx.m
%          made by J. Tunrquist, GI UAF
%
%          ver.1.0: July-9-2008
%          ver.1.1: Jan-10-2009: fixed frequency offset
%          ver.1.2: Jan-29-2009: function mean2 deprecated in MATLAB 2008
%
%       Perform spectrum analysis on selected data sets for coded long
%       pulse data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global DCKNOB
                          
c       = 2.99792458e8;    
bit = 0;
NumBeams = size(CurrentData.BeamCodes);
time_idx = GenParam.TimeIdx;
lphs = length(RadarParam.PhaseCoding);

if ~GenParam.Factor4IntTime
    IntegrationTime = CurrentData.PulsesIntegrated;
else
    IntegrationTime = GenParam.Factor4IntTime;
end% ~GenParam.Factor4IntTime
    
PhaseCodingArr = [];
for ii = 1:1:IntegrationTime
    PhaseCodingArr = [PhaseCodingArr; RadarParam.PhaseCoding]; 
end    

%%% initialize empty cell arrays for each beam direction
PSDArr     = cell(NumBeams(1),1);
PSDinDBArr = cell(NumBeams(1),1);

%%
%% Calculte Power Spectral Density vs Range for each integration period 
%%
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

        %% Calculate PSD

        if eeInt > size(du,2)
            eeInt = size(du,2);
            bit = 1;
        end

        selected_du = du(:,ssInt:eeInt);
        
%         PSD = zeros(size(PhaseCodingArr,2),ssRng+eeRng-1);
        
        
        for irange = ssRng:1:eeRng
            ss = irange;
            ee = irange + lphs - 1;
            
            if ee > size(du,1)
                continue
            end% if ee > size(du) 
            
            irange_du = selected_du(ss:ee,:);
            
            %% decode 
            if ~bit
                decoded_du = irange_du.*PhaseCodingArr';
            else
                decoded_du = irange_du.* ...
                    PhaseCodingArr(1:size(selected_du,2),:)'; 
            end
            

            %% Calculate Power Spectral Density
%             tmp_psd = fft(decoded_du);
            tmp_psd = fftshift(fft(decoded_du));
            tmp_psd = tmp_psd.*conj(tmp_psd);
            
            tmp_psd = mean(tmp_psd,2);
            PSD(:,irange - ssRng + 1) = tmp_psd;
            
        end% for irange 

%         idx = find(PSD <= 0);
%         PSD(idx) = thresh;
        psd_db = 10*log10(PSD);


        %% Concatonate arrays
        PSDArr{beam_idx}        = [ PSDArr{beam_idx}, {PSD} ];
        PSDinDBArr{beam_idx}    = [ PSDinDBArr{beam_idx}, {psd_db} ];


    end %for Iint
end %for length(BeamCodes)

%%%----------
%%% Save Data to Structures
%%%----------
CurrentData.PSDArr      = PSDArr;
CurrentData.PSDinDBArr  = PSDinDBArr;


%%
%% Create Frequency Array
%%
FitRange = size(PSDArr{1}{1});

FreqWidth = RadarParam.SamplingRate; %Hz
TransFreq = RadarParam.TransmitFreq; %Hz
RecCenterFreq   = RadarParam.ReceivingCenterFrequency(1);  %Hz

RadarFreq = 446;

% fHF = RecCenterFreq/1e6 - 21;
fHF = RecCenterFreq/1e6 - 446 + DCKNOB - 20;

CenterFreq = fHF;
FreqRes = FreqWidth/FitRange(1);
FreqArr = FreqRes:FreqRes:FreqWidth;
FreqArr = FreqArr - FreqWidth/2;

CurrentData.FreqArr = FreqArr/1e3 + CenterFreq;

clear PSDArr
clear PSDinDBArr