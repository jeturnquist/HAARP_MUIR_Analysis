function BeamDir = func_BeamCode2AzEl(BeamCodes)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       func_BeamCode2AzEl.m
%          made by J. Tunrquist, GI UAF
%
%          ver.1.0: Aug-7-2008
%
%      Convert beam code number to Azimuth and Elevation in degrees.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global NODISPLAY

%%% okazelgrid.mat, file provided by SRI (contact: Craig Heinselman)
%%%  file needs to be located in a MATLAB path
try
    load okazelgrid;
catch
    if ~NODISPLAY
        disp('');
        disp('Error: File okazelgrid.mat was not found.');
        disp('');
    end
    
    BeamDir = 0;
    
    return;
end

NumBeams = size(BeamCodes,1);
BeamDir = cell(NumBeams,1);

for ii = 1:1:NumBeams
    idx = find((BeamCodes(ii) - 32768) == dhat.icode);
    
    az = dhat.az(idx);
    el = dhat.el(idx);
    
    BeamDir{ii} = [az, el];
end


