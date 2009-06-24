% function SpectrumAna4GIR(b)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      SpectrumAna4GIR.m
%         made by Shin-ichiro Oyama, GI UAF
%
%         ver.1.0: 05-Jul-2006
%         ver.2.0: 01-Nov-2008 : No longer OS depenent 
%         # spectrum analysis using data taken with the GI receiver of MUIR
%
%
%         # NOTE:
%            Prepare below files in the data directory, which will be 
%            defined as "DataDirectory4GIR" in this program, 
%            BEFORE using this program.
%
%              #1 DataTable_[YYYYMMDD].txt
%                  Run "MakeDataTable4GIR.m" to make this ascii file, 
%                  which includes start-time (UT) for each data taken with 
%                  the GI receiver.
%
%              #2 GISRIDataNum_[YYYYMMDD].txt
%                  This file should be prepared by user manually. 
%                  The file created above will be helpful to prepare this.
%                  This file shows which the data number from the GI 
%                  receiver corresponds to the data number from the SRI
%                  receiver. This table will be used in this program.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------
% set global parameter
%------
 global_SpectrumAna4GIR;


%------
% set general parameters
%------
 
%%% data directory
%%%%%%% data from the GI receiver
%  DataDirectory4GIR  = 'J:\GIReceiver\';
%  DataDirectory4GIR  = 'C:\soyama\data\GIRtemp\';
%  DataDirectory4GIR  = 'H:\PARS2007\PARS2007_GIR_Data\';
% DataDirectory4GIR  = 'H:\HAARP~MUIR~data\MultiBandReciever\';
% DataDirectory4GIR  = 'H:\QNXDATA\';
% DataDirectory4GIR = 'H:\FrequencyTests_GI_Rx20080124\';
% DataDirectory4GIR = 'I:\PARS2008\data\GIRx\';
% DataDirectory4GIR =  'I:\2008_Oct_HAARP_campaign\GIRx\oyama_20081101_0145UT\';
% DataDirectory4GIR= 'I:\2008_Oct_HAARP_campaign\GIRx\pedersen_20081029_0300UT\';
DataDirectory4GIR = '/Users/jet/Work/Campain_Oct2008/GIRx/watkins_20081023_Expt-1_23-24_GIRx/';
% DataDirectory4GIR = '/Volumes/Dragon-100/Oct2008/GIRx/watkins_20081023_Expt-1_23-24_GIRx/';

%%%%%%% data from the SRI receiver
%  DataDirectory4SRIR = 'J:\SRIR\';
%  DataDirectory4SRIR = 'G:\MUIRatHAARP\';
%  DataDirectory4SRIR = 'H:\PARS2007\';
%  DataDirectory4SRIR = 'H:\FrequencyTests_SRI_Rx20080124\';
% DataDirectory4SRIR= 'I:\2008_Oct_HAARP_campaign\SRIRx\Oyama_Expt_1\data\Oyama_Expt_20081101\';
%   DataDirectory4SRIR= 'I:\PARS2008\data\SRIRx\Turnquist-Watkins_expt1\';
%  DataDirectory4SRIR = 'E:\';
% DataDirectory4SRIR='I:\2008_Oct_HAARP_campaign\SRIRx\Pedersen_20081029_expt2\';
% DataDirectory4SRIR = '/Users/jet/Work/Campain_Oct2008/SRIRx/';
DataDirectory4SRIR = '/Users/jet/Work/Campain_Oct2008/SRIRx/';
% DataDirectory4SRIR ='/Volumes/Dragon-100/Oct2008/SRIRx/';


%  SelDate            = 20080730;
 SelDate            = 20081023;
 
 
 
 %%%% Directory to save jpegs images to %%%%
%   Creates the specified directory and saves
%    the jpeg files there.
%   Directory cannot contain spaces.
%   Default directory same as raw data directory
%   Do Not end the file directory with a backslash
%    one is automaticlly included
%   i.e. 'C:\Workspace\MUIR_data'  (correct)
%        'C:\Workspace\MUIR_data\' (incorrect)
% 

 JpgSaveDirectory       = ...
         '/Users/jet/Work/Campain_Oct2008/GIRx/watkins_20081023_Expt-1_23-24_GIRx/analysis/tmp';
%      'C:\Workspace\GIR_data';
% JpgSaveDirectory = '/Volumes/Dragon-100/Oct2008/GIRx/watkins_20081023_Expt-1_23-24_GIRx/tmp';

                          
 
%------
% select data file
%------
%%% pick-up - the data number from the GI receiver,
%%%         - the pulse-coding type, and
%%%         - data number from the SRI receiver
 [ DataNum4GIR, PulseCodingType, DataNum4SRIR ] = ...
     func_FindDataNum4GIR_SpectrumAna4GIR;
 
     
     
%%% select A data number from the GI receiver
%%%      e.g. "33" of "33.01"
%%%
%%% global: SelDataNum4GIR
 func_SelDataNum4GIR_SpectrumAna4GIR(DataNum4GIR);
 
 
%%% select A data-extention number from the GI receiver
%%%      e.g. "01" of "33.01"
%%%
%%% global: SelDataExtNum4GIR
 func_SelDataExtNum4GIR_SpectrumAna4GIR;
 
     
%%% decide the data-file name (from the GI receiver)
%%%
%%% global: DataFileName4GIR
 func_DataFileName4GIR_SpectrumAna4GIR(1);
 
%%% find the SRI data-file corresponding GI-receiver data
%%%
%%% global: SelDataNum4SRIR
 func_SelDataNum4SISR_SpectrumAna4GIR(DataNum4GIR, DataNum4SRIR);     
 
%%% find the pulse coding type
%%% 
%%% global: SelPulseCodingType
func_SelPulseCodingType_SpectrumAna4GIR( DataNum4GIR, PulseCodingType )

%------
% select analyzing type
%------
 switch char(SelPulseCodingType)
     case {'CLP'}
         Decode4CLP_SpectrumAna4GIR;
     case {'uCLP'}
         BaudLength = 1;
         uCLP_SpectrumAna4GIR;
 end%switch SelPulseCodingType