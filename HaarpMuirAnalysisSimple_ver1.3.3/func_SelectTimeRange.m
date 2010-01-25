function [ GenParam ] = func_SelectTimeRange(...
                            CurrentData, GenParam, RadarParam)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_SelectTimeRange.m
%          made by J. Tunrquist, GI UAF
%
%          ver.1.0: Jun-28-2008
%          ver.1.1: Dec-11-2008
%          ver.1.2: Aug-27-2009 : fixed time range bug, if minutes crosses
%                                   hour mark. 
%
%      Read data from hdf5 file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
%------
% set global parameters
%------
global RUNFROMSCRIPT
global RUNALL

l = size(CurrentData.TimeArrOfHour{1});

HH = reshape(CurrentData.TimeArrOfHour{1},l(1)*l(2),1);
MM = reshape(CurrentData.TimeArrOfMinute{1},l(1)*l(2),1);
SS = reshape(CurrentData.TimeArrOfSecond{1},l(1)*l(2),1);

StartTimeChar = [num2str(HH(1)),':',num2str(MM(1)),':',num2str(SS(1))];
EndTimeChar   = [num2str(HH(end)),':',num2str(MM(end)),':',num2str(SS(end))];

%RUNALL =1;
if RUNFROMSCRIPT || RUNALL
    InputChar = 0; 
    FLAG = 1;
else 
    FLAG = 0;
end

while ~FLAG
    disp(['-------------------------------']);
    disp(['Select time range for analysis:']);
    disp(['-------------------------------']);
    disp(['0 - use entire data file']);
    disp(['Enter a time range in SECONDS after Start Time'])
    disp(['Start Time: HH:MM:SS.UUU ', StartTimeChar]);
    disp(['End Time:                ', EndTimeChar,   ' (ex. 1:10)'])

    InputChar = input('#');
    
    ss = 60*MM(1); 
    es = 60*MM(end);
    
    if ss >= es
        es = 60*(MM(end) + 60); %% if MM crosses hours mark and resets to 0 
                                %% increment add 60 seconds
    end
    
    TimeSpan = (es + SS(end)) - (ss + SS(1));
    if InputChar(end) > TimeSpan
        disp(['']);
        disp(['############# ERROR ###############']);
        disp(['Time range exceeds data time span.']);
        disp(['']);
        continue;
    else
        FLAG = 1;
    end
end

TimeArr = 3600*HH+60*MM+SS;

if ~InputChar 
    GenParam.TimeIdx = 0;
else

    st = InputChar(1)+3600*HH(1)+ss+SS(1);
    et = InputChar(end)+3600*HH(1)+ss+SS(1);
    
    idx1 = find(TimeArr >= st);
    idx2 = find(TimeArr <= et);
    GenParam.TimeIdx = [idx1(1):idx2(end)];
end
