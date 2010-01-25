function [ SavedData ] = func_SpectrumAna4SRIRx(...
                                    GenParam, InputParam, RadarParam)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_SpectrumAna4SRIRx.m
%          made by J. Tunrquist, GI UAF
%
%          ver.1.0: Jun-28-2008
%          ver.1.1: Jan-24-2009: cleaned up code
%
%       Perform spectrum analysis on selected data sets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Global Params
global NODISPLAY
global RUNFROMSCRIPT 
global SAVEBIT

%% Read radar parameters from selected *.hf file

%%% IfileNum: Number of selected files for analysis
IfileNum = length(GenParam.SelectedFileNames);

[RadarParam, GenParam ] = func_GetRadarParamters4SRIRx( RadarParam	...
                                                , InputParam	...
                                                , GenParam );


%%
%% Iterate through selected file numbers 
%%
for Ifile = 1:1:IfileNum
    %------
    % Read data file
    %------
    [ CurrentData, RadarParam, GenParam ] = func_ReadDataFile_SRIRx_hdf5(...
                    GenParam, RadarParam, InputParam, Ifile);
     
    %------
    % Select time range for analysis
    %------            
    [ GenParam ] = func_SelectTimeRange(CurrentData, GenParam, RadarParam);
    
    
    
    if Ifile == 1 && ~NODISPLAY
            
        %% Display experimental information
        [ RadarParam, GenParam ] = ...
            func_DispExpInfomation( RadarParam, GenParam );                
                  
    end% if Ifile == 1  
    
   %------
   % Calculate Spectral Information 
   %------ 
   switch InputParam.PulseType
       case{'uCLP'} %%% Uncoded Long Pulse
           
           %------
           % Calculate spectral info for uncoded long pulse
           %------
           [ CurrentData ] = func_CalSpectraInfo4uCLP_SRIRx(            ...
                                    CurrentData, RadarParam, GenParam   ...
                                  , InputParam);
                              
            %------
            % Plot SNR and PSD vs Time  
            %------
            func_PlotSNRandPSDvsTime( CurrentData       ...
                                    , GenParam          ...
                                    , RadarParam        ...
                                    , InputParam        ...
                                    , Ifile )
                                
       case{'CLP'} %%% Coded Long Pulse
           
           %------
           % Calculate spectral info for coded long pulse
           %------
           [ CurrentData ] = func_CalSpectraInfo4CLP_SRIRx(             ...
                                    CurrentData, RadarParam, GenParam   ...
                                  , InputParam);
            
            %------
            % Plot PSD vs Range for each integration period  
            %------                  
            func_PlotPSDvsRange4IntPeriod_CLP( CurrentData  ...
                                             , GenParam     ...
                                             , RadarParam   ...
                                             , InputParam   ...
                                             , Ifile)
   end%switch PulseType
   
%%   
%% Save data in structure
%%
    if RUNFROMSCRIPT || SAVEBIT
    
      FileName = ['d00',num2str(GenParam.SelectedFileNumbers(Ifile))];

      SavedData.(FileName).du_sorted        = CurrentData.du_sorted;
      SavedData.(FileName).dp               = CurrentData.dp;
      SavedData.(FileName).BeamDir          = RadarParam.BeamDir;
      SavedData.(FileName).MatlabTime       = CurrentData.MatlabTime;
      SavedData.(FileName).SNRArr           = CurrentData.SNRArr;
      SavedData.(FileName).PSDArr           = CurrentData.PSDArr;
      SavedData.(FileName).SNRinDBArr       = CurrentData.SNRinDBArr;
      SavedData.(FileName).PSDinDBArr       = CurrentData.PSDinDBArr;
      SavedData.(FileName).TimeArrOfHour    = CurrentData.TimeArrOfHour;
      SavedData.(FileName).TimeArrOfMinute  = CurrentData.TimeArrOfMinute;
      SavedData.(FileName).TimeArrOfSecond  = CurrentData.TimeArrOfSecond;
      SavedData.(FileName).FreqArr          = CurrentData.FreqArr;
      SavedData.(FileName).Range            = CurrentData.Range;
    else
        SavedData = [];
        clear java
    end%% RUNFROMSCRIPT
                                
end% for Ifile                                