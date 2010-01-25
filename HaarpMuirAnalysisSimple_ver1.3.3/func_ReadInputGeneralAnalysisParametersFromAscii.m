%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_ReadInputGeneralAnalysisParametersFromAscii.m
%           made by J. Turnquist, GI UAF
%
%       ver.1.0: Jun-24-2008: Read ascii file containting user created
%                             general analysis parameters
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ params, fid ] = func_ReadInputGeneralAnalysisParametersFromAscii(...
                      FileNameChar);

%------
% set global parameters
%------
% global_HaarpMUIRAnalysis;                  
global NODISPLAY

%%% Initalize empty cell array
params = cell(5,1);                 

%%% Open ascii file
try            
    fid  = fopen(FileNameChar);
catch
    if ~NODISPLAY
        disp('----------Error---------');
        ErrorChar = ['  File: ', FileNameChar, ' does not exist.'];
        disp(ErrorChar)
    end
    
    return; 
end

%% Read in general paramaters from ascii file
ii = 1;
while 1
    TmpChar = fgetl(fid);
    if strcmp(TmpChar(1), '#')
        while 1
            TmpChar  = fgetl(fid);
            if TmpChar < 1, fclose(fid); return; end %% break loop if EOF
            params{ii,1} = TmpChar;
            ii = ii + 1;
        end% while FLAG
    end% if strcmp(TmpChar(1), '#')     
end% while 1

