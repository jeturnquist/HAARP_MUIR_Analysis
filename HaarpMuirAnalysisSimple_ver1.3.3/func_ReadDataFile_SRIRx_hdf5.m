function [ CurrentData, RadarParam, GenParam ] = func_ReadDataFile_SRIRx_hdf5(...
                            GenParam, RadarParam, InputParam, Ifile)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_ReadDataFile_SRIRx_hdf5.m
%          made by J. Tunrquist, GI UAF
%
%          ver.1.0: Jun-28-2008
%          ver.1.1: Dec-11-2008 : Replaced MatlabTime with RadacTime
%                                 RadacTime is the time of each recorded
%                                 pulse.
%
%      Read data from hdf5 file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------
% set global parameters
%------
global NODISPLAY

IfileNum = length(GenParam.SelectedFileNames);

if ~NODISPLAY
    OutputChar = [ 'Reading: ' GenParam.SelectedFileNames{Ifile} ];
    disp( OutputChar );
end
                        
%% Read in data from file

%%% Initialize Current Data Structure
CurrentData = struct( 'du',[]                                    	...
                    , 'du_sorted',[]                                ...
                    , 'dp',[]                                      	...
                    , 'MatlabTime',[]                             	...
                    , 'RadacTime',[]                                ...
                    , 'Range',[]                                	...                            ...
                    , 'Beamcodeing',[]                              ...
                    , 'BeamCodes',[]                             	...
                    , 'PulseCount',[]                               ...
                    , 'PulsesIntegrated',[]                         ...
                    , 'SNRArr',[]                                   ...
                    , 'PSDArr',[]                                   ...
                    , 'SNRinDBArr',[]                               ...
                    , 'PSDinDBArr',[]                               ...
                    , 'PowerArr',[]                                 ...
                    , 'TimeArrOfHour',[]                            ...
                    , 'TimeArrOfMinute',[]                          ...
                    , 'TimeArrOfSecond',[]                          ... 
                    , 'Date',[] );

%%% Read data   

FileChar   = fullfile( InputParam.Directory4MUIRData              ...
                          , GenParam.SelectedDirChar                    ...
                          , GenParam.SelectedFileNames{Ifile});
                      
CurrentData.du = hdf5read( FileChar,...
                            '/Raw11/Data/Samples/Data');
CurrentData.dp = hdf5read( FileChar,...
                            '/Raw11/Data/Power/Data');
CurrentData.MatlabTime = hdf5read( FileChar,...
                            '/Time/MatlabTime');
CurrentData.RadacTime = hdf5read( FileChar,...
                            '/Raw11/Data/RadacHeader/RadacTime');                        
CurrentData.Range = hdf5read( FileChar,...
                            '/Raw11/Data/Samples/Range');
CurrentData.Beamcodeing = hdf5read( FileChar,...
                            '/Raw11/Data/RadacHeader/BeamCode');
CurrentData.BeamCodes = hdf5read( FileChar,...
                            '/Raw11/Data/Beamcodes');
CurrentData.PulsesIntegrated = hdf5read( FileChar,... 
                            '/Raw11/Data/PulsesIntegrated');
CurrentData.PulseCount = hdf5read( FileChar,...
                            '/Raw11/Data/RadacHeader/PulseCount');

%% Convert Beam Code to AZ and EL (deg)
RadarParam.BeamDir = func_BeamCode2AzEl(CurrentData.BeamCodes);
                        
%% Arrange raw data by beam code and time
NumBeams    = size(CurrentData.BeamCodes);
duDim       = size(CurrentData.du);
beam_idx = [];

du      = cell(NumBeams(1),1);


%% Reshape 4D Array into something useful and Parse Time by Beam Direction
%%
%%% Dimensions of 4D array:
%       duDim(1) : The voltages in quadtrature (QT)
%       duDim(2) : Range
%       duDim(3) : Record Length (# of pulses per record)
%       duDim(4) : Number of Records

%%% NumBeams : m by n array, m = # number of beams, n = # of records 
for ii = 1:1:duDim(4)
    for kk = 1:1:NumBeams(1)
        beam_idx = find(CurrentData.Beamcodeing(ii,kk) == ...
                            CurrentData.BeamCodes(:,1)); 

        count = 1;
        for jj = kk:NumBeams(1):length(CurrentData.Beamcodeing);
            %% parse data by beamcode
            tmpdu = CurrentData.du(:,:,jj,ii);

            complex_du = complex(tmpdu(1,:), tmpdu(2,:));
            du{beam_idx}(:,count,ii) = complex_du;
            
            %% parse time by beamcode
            tmpTime = datevec(datenum(1970,1,1,0,0 ...
                , CurrentData.RadacTime(jj,ii)));
            
            HourArr{beam_idx}(jj,ii)     = tmpTime(1,4);
            MinuteArr{beam_idx}(jj,ii)   = tmpTime(1,5);
            SecondArr{beam_idx}(jj,ii)   = tmpTime(1,6);
            
            count = count + 1;
        end
    end
end


du_sorted = cell(NumBeams(1),1);

for ii = 1:1:NumBeams(1)
    du_sorted{ii} = reshape(du{ii}, duDim(2), duDim(3)*duDim(4));
end

CurrentData.du_sorted = du_sorted;

CurrentData.Date            = datestr(CurrentData.MatlabTime(:,1),29);
CurrentData.TimeArrOfHour   = HourArr;
CurrentData.TimeArrOfMinute = MinuteArr;
CurrentData.TimeArrOfSecond = SecondArr;


