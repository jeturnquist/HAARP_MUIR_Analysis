{\rtf1\mac\ansicpg10000\cocoartf824\cocoasubrtf480
{\fonttbl\f0\fmodern\fcharset77 Courier;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
\margl1440\margr1440\vieww20660\viewh11120\viewkind0
\deftab720
\pard\pardeftab720\ql\qnatural

\f0\fs24 \cf2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\cf0 \
\cf2 %\
%       GIRx_QuickLook.m\
%          made by J. Tunrquist, GI UAF\
%\
%          ver.1.0: July-18-2009 \
%           TO DO: Make readBinaryData function faster, currently this is\
%                   the bottle neck in the program.\
%\
%       Quick look of GIRx data. Plots Power as a function of Time vs Range\
%       (No spectral analysis)\
%\
%       At least one SRIRx data file from the same experiment is needed.\
%   \
%       This program is all inclusive, that is, there is only one m-file which\
%       contains all pertinent fnctions.\
%  \
%   --------\
%    Usage:\
%   --------\
%         For this QuickLook to work TWO data files are needed. First a SRI\
%       Reciever (SRIRx) data file (*.h5) from the same experiment as the \
%       GI Reciver (GIRx) data that is being viewed. The second data file\
%       needed is the GIRx data file (*.dat) to be viewed.\
%\
%         To make selecting data files easier, a GUI will open to the\
%       directory defined by DataDirectory4SRIR and DataDirectory4GIR.\
%         If no directory path is given, the GUI will open in the current\
%       MATLAB directory, i.e. the directory which contains GIRx_QuickLook.m\
%\
%       -----------------------------------------------\
%        The SRIRx data file supplies the information:\
%       -----------------------------------------------\
%          > IPP         - Inter Pulse Period\
%          > TxStartTime - Transmitter start time\
%          > RxStartTime - Reciever start time\
%          > PulseLength\
%          > SampleTime  - Baud Length (Not to be confused with the \
%                           Sampling Rate)\
%          > Reciever center frequency - Not to be confused with the Down\
%               Converter Knob setting\
%\
%       ----------------------------------\
%        Required user defined paramters: \
%       ----------------------------------\
%         These are paramaters that cannot be obtained from the SRIRx data\
%        file or they may differ from the SRIRx paramters (Noteably the\
%        Sampling Rate)\
%\
%          > PulseType      - CLP (Coded Long Pulse)\
%                             uCLP (unCoded Long Pulse)\
%          > DCKNOB         - Down converter knob setting (MHz)\
%                               445 : Ionline\
%                               450 : Downshifted plasma line \
%                               440 : Upshifted plamsa line \
%          > SamplingRate   - kHz (may differ from SRIRx)\
%          > UpperRange     - Upper range for analysis (km)\
%          > LowerRange     - Lower range for analysis (km)   \
%          > TimeIntegraton - Integration time (ms)\
%\
%       -----------------------------------------------\
%        Data directory for SRIRx and GIRx data files: \
%       -----------------------------------------------\
%          > DataDirectory4SRIR - Directory for SRIRx data files\
%          > DataDirectory4GIR  - Directory for GIRx data files\
%\
%\
% NOTE:   The directory paths cannot contain spaces when  \
%       running GIRx_QuickLook.m on a windows machince. MATLAB uses the\
%       local command line (i.e DOS-prompt in windows). DOS-prompt does not\
%       support spaces in directory names and it is not possible to escape\
%       the spaces (if I am wrong please let me know). \
%         Thus, either place the data in a directory path containing no\
%       spaces or use the windows short name convention.\
%           'C:\\Documents and Settings' --> 'C:\\DOCUME~1' (short name)\
%\
%         On a *nix system it is possible to escape spaces using a\
%       backslash (\\).\
%            '/PARS summer school 2007' --> '/PARS\\ summer\\ school\\ 2007'\
%\
\pard\pardeftab720\ql\qnatural
\cf0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\cf2 \
}