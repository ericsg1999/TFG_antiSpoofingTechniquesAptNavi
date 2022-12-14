function settings = initSettings()
%Functions initializes and saves settings. Settings can be edited inside of
%the function, updated from the command line or updated using a dedicated
%GUI - "setSettings".  
%
%All settings are described inside function code.
%
%settings = initSettings()
%
%   Inputs: none
%
%   Outputs:
%       settings     - Receiver settings (a structure). 

%--------------------------------------------------------------------------
%                         CU Multi-GNSS SDR  
% (C) Updated by Yafeng Li, Nagaraj C. Shivaramaiah and Dennis M. Akos
% Based on the original work by Darius Plausinaitis,Peter Rinder, 
% Nicolaj Bertelsen and Dennis M. Akos
%--------------------------------------------------------------------------

%This program is free software; you can redistribute it and/or
%modify it under the terms of the GNU General Public License
%as published by the Free Software Foundation; either version 2
%of the License, or (at your option) any later version.
%
%This program is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with this program; if not, write to the Free Software
%Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
%USA.
%--------------------------------------------------------------------------

% CVS record:
% $Id: initSettings.m,v 1.9.2.31 2006/08/18 11:41:57 dpl Exp $
%% Display the available signals in order to let the user decide
disp('These are the available signals to read and process:')
disp('0) Borre_DiscreteComponents')
disp('1) TEXBAT_cleanStatic')
disp('2) TEXBAT_ds2')
disp('3) TEXBAT_ds3')
disp('4) TEXBAT_ds4')
disp('5) TEXBAT_ds5')
disp('7) TEXBAT_ds7')
disp('8) NAVI_spoofed')
prompt='Choose the signal by entering the number: ';
signal_file=input(prompt);

%% Switch event. Creating the settings structure depending on the signal choosen by the user
switch signal_file
    case 0 %'Borre_DiscreteComponents'
        %% Processing settings ====================================================
        % Number of milliseconds to be processed used 36000 + any transients (see
        % below - in Nav parameters) to ensure nav subframes are provided
        settings.msToProcess        = 20000;        %[ms]

        % Maximum number of satellites to process. For each satellite, it
        % will be assigned settings.AptNumberChannelsPerSat number of
        % channels for each satellite to process
        settings.maxNumSatToProcess   = 8; %anteriorment es deia numberOfChannels

        % Move the starting point of processing. Can be used to start the signal
        % processing at any point in the data record (e.g. for long records). fseek
        % function is used to move the file read point, therefore advance is byte
        % based only. 
        settings.skipNumberOfBytes     = 0;

        %% Raw signal file name and other parameter ===============================
        % This is a "default" name of the data file (signal record) to be used in
        % the post-processing mode
        settings.fileName           = 'D:\TexBat_spoofedsignals\cleanStatic.bin';
        % Data type used to store one sample
        settings.dataType           = 'int16';  

        % File Types
        %1 - 8 bit real samples S0,S1,S2,...
        %2 - 8 bit I/Q samples I0,Q0,I1,Q1,I2,Q2,...                      
        settings.fileType           = 2;

        % Intermediate, sampling and code frequencies
        settings.IF                 = 0;     % [Hz]
        settings.samplingFreq       = 25e6;        % [Hz]
        settings.codeFreqBasis      = 1.023e6;     % [Hz]

        % Define number of chips in a code period
        settings.codeLength         = 1023.;

        %% Acquisition settings ===================================================
        % Skips acquisition in the script postProcessing.m if set to 1
        settings.skipAcquisition    = 0;
        % List of satellites to look for. Some satellites can be excluded to speed
        % up acquisition
        settings.acqSatelliteList   = 1:32;         %[PRN numbers]
        % Band around IF to search for satellite signal. Depends on max Doppler.
        % It is single sideband, so the whole search band is tiwce of it.
        settings.acqSearchBand      = 14;           %[KHz]
        % Non-coherent integration times after 1ms coherent integration
        settings.acqNonCohTime      = 20;                %[ms]
        % Threshold for the signal presence decision rule
        settings.acqThreshold       = 3.5;
        % Frequency search step for coarse acquisition
        settings.acqSearchStep      = 250;               % [Hz]
        % Sampling rate threshold for downsampling 
        settings.resamplingThreshold    = 8e6;            % [Hz]
        % Enable/dissable use of downsampling for acquisition
        settings.resamplingflag         = 0;              % 0 - Off
                                                          % 1 - On
        % Activates acqusition search grid plots or not. 1 (active), 0 (not active)
        settings.acqInitialPlots=0;
        %% Tracking loops settings ================================================
        % Code tracking loop parameters
        settings.dllDampingRatio         = 0.7;
        settings.dllNoiseBandwidth       = 1.5;       %[Hz]
        settings.dllCorrelatorSpacing    = 0.5;     %[chips]

        % Carrier tracking loop parameters
        settings.pllDampingRatio         = 0.7;
        settings.pllNoiseBandwidth       = 20;      %[Hz]
        % Integration time for DLL and PLL
        settings.intTime                 = 0.001;      %[s]
        %% Navigation solution settings ===========================================

        % Period for calculating pseudoranges and position
        settings.navSolPeriod       = 500;          %[ms]

        % Elevation mask to exclude signals from satellites at low elevation
        settings.elevationMask      = 5;           %[degrees 0 - 90]
        % Enable/dissable use of tropospheric correction
        settings.useTropCorr        = 1;            % 0 - Off
                                                    % 1 - On

        % True position of the antenna in UTM system (if known). Otherwise enter
        % all NaN's and mean position will be used as a reference .
        settings.truePosition.E     = nan;
        settings.truePosition.N     = nan;
        settings.truePosition.U     = nan;

        %% Plot settings ==========================================================
        % Enable/disable plotting of the tracking results for each channel
        settings.plotTracking       = 1;            % 0 - Off; 1 - On
        settings.plotAcquisition = 1;
        settings.plotNavigation = 1;
        %% Constants ==============================================================
        settings.c                  = 299792458;    % The speed of light, [m/s]
        settings.startOffset        = 68.802;       %[ms] Initial sign. travel time

        %% CNo Settings============================================================
        % Accumulation interval in Tracking (in Sec)
        settings.CNo.accTime=0.001;
        % Accumulation interval for computing VSM C/No (in ms)
        settings.CNo.VSMinterval = 40;
        %% APT detection settings ===========================================================
        %Indicates if the APT spoofing detection is ON (1) or OFF (0)
        settings.AptActive=0;
        %Indicates the period of the APT detection (time between detection checks)
        settings.AptPeriod=1000; %[ms]
        %Activates acquisition search grid plots or not in the APT spoofing
        %detection. 1 (active), 0 (not active)
        settings.AptPlots=1;
        %Although settings.AptPlots is active, you might not desire to
        %display them, for instance, if you want to save them directly without
        %displaying them.
        settings.AptShowPlots=0;
        %Saves plots in C:\Users\erics\OneDrive\Documentos\MATLAB\TFG\Borre\Images
        settings.AptSavePlots=1;
        %Number of channels per satellite 
        settings.AptNumberChannelsPerSat=2;
        %APT threshold. How many times second peak shall be bigger than
        %third peak
        settings.AptThreshold=1;
        %% NAVI settings ===================================================================
        settings.NaviTowActive=0;
        settings.NaviTowPeriodBits=300; 
        
        %% SCB settings ====================================================================
        settings.SbcActive=1;
        settings.SbcPeriod= 1000;%[ms]
        
    case 1 %'TEXBAT_cleanStatic'
        %% Processing settings ====================================================
        % Number of milliseconds to be processed used 36000 + any transients (see
        % below - in Nav parameters) to ensure nav subframes are provided
        settings.msToProcess        = 37000;      % 37000 [ms]

        % Maximum number of satellites to process. For each satellite, it
        % will be assigned settings.AptNumberChannelsPerSat number of
        % channels for each satellite to process
        settings.maxNumSatToProcess   = 8; %anteriorment es deia numberOfChannels

        % Move the starting point of processing. Can be used to start the signal
        % processing at any point in the data record (e.g. for long records). fseek
        % function is used to move the file read point, therefore advance is byte
        % based only. 
        settings.skipNumberOfBytes     = 0;
        settings.fileStartingReadingSecond=0;
        % Texbat spoofing scenarios may not be perfectly aligned with the
        % cleanStatic signal. In paper "Detailed Analysis of the TEXBAT
        % Datasets Using a High Fidelity Software GPS Receiver" it is
        % detailed these offsets.
        settings.fileStartingOffsetSecond=0; 
        
        settings.powerCorrectionFactor=1;%0.373;
        %% Raw signal file name and other parameter ===============================
        % This is a "default" name of the data file (signal record) to be used in
        % the post-processing mode
        settings.fileName           = 'D:\TexBat_spoofedsignals\cleanStatic.bin';
        % Data type used to store one sample
        settings.dataType           = 'int16';  

        % File Types
        %1 - 8 bit real samples S0,S1,S2,...
        %2 - 8 bit I/Q samples I0,Q0,I1,Q1,I2,Q2,...                      
        settings.fileType           = 2;

        % Intermediate, sampling and code frequencies
        settings.IF                 = 0;     % [Hz]
        settings.samplingFreq       = 25e6;        % [Hz]
        settings.codeFreqBasis      = 1.023e6;     % [Hz]

        % Define number of chips in a code period
        settings.codeLength         = 1023.;

        %% Acquisition settings ===================================================
        % Skips acquisition in the script postProcessing.m if set to 1
        settings.skipAcquisition    = 0;
        % List of satellites to look for. Some satellites can be excluded to speed
        % up acquisition
        settings.acqSatelliteList   = 1:32;         %[PRN numbers]
        % Band around IF to search for satellite signal. Depends on max Doppler.
        % It is single sideband, so the whole search band is tiwce of it.
        settings.acqSearchBand      = 7000;           %[KHz]
        % Non-coherent integration times after 1ms coherent integration
        settings.acqNonCohTime      = 10;                %[ms]
        % Threshold for the signal presence decision rule
        settings.acqThreshold       = 3.5;
        % Frequency search step for coarse acquisition
        settings.acqSearchStep      = 250;               % [Hz]
        % Sampling rate threshold for downsampling 
        settings.resamplingThreshold    = 8e6;            % [Hz]
        % Enable/dissable use of downsampling for acquisition
        settings.resamplingflag         = 0;              % 0 - Off
                                                          % 1 - On
        % Activates acqusition search grid plots or not. 1 (active), 0 (not active)
        settings.acqInitialPlots=0;
        settings.acqFineFreqSearch=1;
        %% Tracking loops settings ================================================
        % Code tracking loop parameters
        settings.dllDampingRatio         = 0.7;
        settings.dllNoiseBandwidth       = 1.5;       %[Hz]
        settings.dllCorrelatorSpacing    = 0.5;     %[chips]

        % Carrier tracking loop parameters
        settings.pllDampingRatio         = 0.7;
        settings.pllNoiseBandwidth       = 20;      %[Hz]
        % Integration time for DLL and PLL
        settings.intTime                 = 0.001;      %[s]
        %% Navigation solution settings ===========================================

        % Period for calculating pseudoranges and position
        settings.navSolPeriod       = 500;          %[ms]

        % Elevation mask to exclude signals from satellites at low elevation
        settings.elevationMask      = 5;           %[degrees 0 - 90]
        % Enable/dissable use of tropospheric correction
        settings.useTropCorr        = 1;            % 0 - Off
                                                    % 1 - On

        % True position of the antenna in UTM system (if known). Otherwise enter
        % all NaN's and mean position will be used as a reference .
        settings.truePosition.E     = nan;
        settings.truePosition.N     = nan;
        settings.truePosition.U     = nan;

        %% Plot settings ==========================================================
        % Enable/disable plotting of the tracking results for each channel
        settings.plotTracking       = 1;            % 0 - Off; 1 - On
        settings.plotAcquisition = 1;
        settings.plotNavigation = 1;
        %% Constants ==============================================================
        settings.c                  = 299792458;    % The speed of light, [m/s]
        settings.startOffset        = 68.802;       %[ms] Initial sign. travel time

        %% CNo Settings============================================================
        % Accumulation interval in Tracking (in Sec)
        settings.CNo.accTime=0.001;
        % Accumulation interval for computing VSM C/No (in ms)
        settings.CNo.VSMinterval = 40;
        %% APT detection settings ===========================================================
        %Indicates if the APT spoofing detection is ON (1) or OFF (0)
        settings.AptActive=0;
        %Indicates the period of the APT detection (time between detection checks)
        settings.AptPeriod=1000; %[ms]
        %Activates acquisition search grid plots or not in the APT spoofing
        %detection. 1 (active), 0 (not active)
        settings.AptPlots=1;
        %Although settings.AptPlots is active, you might not desire to
        %display them, for instance, if you want to save them directly without
        %displaying them.
        settings.AptShowPlots=0;
        %Saves plots in C:\Users\erics\OneDrive\Documentos\MATLAB\TFG\Borre\Images
        settings.AptSavePlots=1;
        %Number of channels per satellite 
        settings.AptNumberChannelsPerSat=2;
        %APT threshold. How many times second peak shall be bigger than
        %third peak
        settings.AptThreshold=2;
        
        %% NAVI settings ===================================================================
        settings.NaviTowActive=0;
        settings.NaviTowPeriodBits=300; 
        
        %% SCB settings ====================================================================
        settings.SbcActive=0;
        settings.SbcPeriod= 1000;%[ms]
    case 2 %'TEXBAT_ds2'
       %% Processing settings ====================================================
        % Number of milliseconds to be processed used 36000 + any transients (see
        % below - in Nav parameters) to ensure nav subframes are provided
        settings.msToProcess        = 80000;      % 37000 [ms]

        % Maximum number of satellites to process. For each satellite, it
        % will be assigned settings.AptNumberChannelsPerSat number of
        % channels for each satellite to process
        settings.maxNumSatToProcess   = 8; %anteriorment es deia numberOfChannels

        % Move the starting point of processing. Can be used to start the signal
        % processing at any point in the data record (e.g. for long records). fseek
        % function is used to move the file read point, therefore advance is byte
        % based only. 
        settings.skipNumberOfBytes     = 0;
        settings.fileStartingReadingSecond=100;
        % Texbat spoofing scenarios may not be perfectly aligned with the
        % cleanStatic signal. In paper "Detailed Analysis of the TEXBAT
        % Datasets Using a High Fidelity Software GPS Receiver" it is
        % detailed these offsets.
        settings.fileStartingOffsetSecond=0; 
        
        settings.powerCorrectionFactor=1;%0.373;
        %% Raw signal file name and other parameter ===============================
        % This is a "default" name of the data file (signal record) to be used in
        % the post-processing mode
        settings.fileName           = 'D:\TexBat_spoofedsignals\ds2.bin';
        % Data type used to store one sample
        settings.dataType           = 'int16';  

        % File Types
        %1 - 8 bit real samples S0,S1,S2,...
        %2 - 8 bit I/Q samples I0,Q0,I1,Q1,I2,Q2,...                      
        settings.fileType           = 2;

        % Intermediate, sampling and code frequencies
        settings.IF                 = 0;     % [Hz]
        settings.samplingFreq       = 25e6;        % [Hz]
        settings.codeFreqBasis      = 1.023e6;     % [Hz]

        % Define number of chips in a code period
        settings.codeLength         = 1023.;

        %% Acquisition settings ===================================================
        % Skips acquisition in the script postProcessing.m if set to 1
        settings.skipAcquisition    = 0;
        % List of satellites to look for. Some satellites can be excluded to speed
        % up acquisition
        settings.acqSatelliteList   = 1:32;         %[PRN numbers]
        % Band around IF to search for satellite signal. Depends on max Doppler.
        % It is single sideband, so the whole search band is tiwce of it.
        settings.acqSearchBand      = 7000;           %[KHz]
        % Non-coherent integration times after 1ms coherent integration
        settings.acqNonCohTime      = 10;                %[ms]
        % Threshold for the signal presence decision rule
        settings.acqThreshold       = 3.5;
        % Frequency search step for coarse acquisition
        settings.acqSearchStep      = 250;               % [Hz]
        % Sampling rate threshold for downsampling 
        settings.resamplingThreshold    = 8e6;            % [Hz]
        % Enable/dissable use of downsampling for acquisition
        settings.resamplingflag         = 0;              % 0 - Off
                                                          % 1 - On
        % Activates acqusition search grid plots or not. 1 (active), 0 (not active)
        settings.acqInitialPlots=0;
        settings.acqFineFreqSearch=1;
        %% Tracking loops settings ================================================
        % Code tracking loop parameters
        settings.dllDampingRatio         = 0.7;
        settings.dllNoiseBandwidth       = 1.5;       %[Hz]
        settings.dllCorrelatorSpacing    = 0.5;     %[chips]

        % Carrier tracking loop parameters
        settings.pllDampingRatio         = 0.7;
        settings.pllNoiseBandwidth       = 20;      %[Hz]
        % Integration time for DLL and PLL
        settings.intTime                 = 0.001;      %[s]
        %% Navigation solution settings ===========================================

        % Period for calculating pseudoranges and position
        settings.navSolPeriod       = 500;          %[ms]

        % Elevation mask to exclude signals from satellites at low elevation
        settings.elevationMask      = 5;           %[degrees 0 - 90]
        % Enable/dissable use of tropospheric correction
        settings.useTropCorr        = 1;            % 0 - Off
                                                    % 1 - On

        % True position of the antenna in UTM system (if known). Otherwise enter
        % all NaN's and mean position will be used as a reference .
        settings.truePosition.E     = nan;
        settings.truePosition.N     = nan;
        settings.truePosition.U     = nan;

        %% Plot settings ==========================================================
        % Enable/disable plotting of the tracking results for each channel
        settings.plotTracking       = 1;            % 0 - Off; 1 - On
        settings.plotAcquisition = 1;
        settings.plotNavigation = 1;
        %% Constants ==============================================================
        settings.c                  = 299792458;    % The speed of light, [m/s]
        settings.startOffset        = 68.802;       %[ms] Initial sign. travel time

        %% CNo Settings============================================================
        % Accumulation interval in Tracking (in Sec)
        settings.CNo.accTime=0.001;
        % Accumulation interval for computing VSM C/No (in ms)
        settings.CNo.VSMinterval = 40;
        %% APT detection settings ===========================================================
        %Indicates if the APT spoofing detection is ON (1) or OFF (0)
        settings.AptActive=1;
        %Indicates the period of the APT detection (time between detection checks)
        settings.AptPeriod=1000; %[ms]
        %Activates acquisition search grid plots or not in the APT spoofing
        %detection. 1 (active), 0 (not active)
        settings.AptPlots=1;
        %Although settings.AptPlots is active, you might not desire to
        %display them, for instance, if you want to save them directly without
        %displaying them.
        settings.AptShowPlots=0;
        %Saves plots in C:\Users\erics\OneDrive\Documentos\MATLAB\TFG\Borre\Images
        settings.AptSavePlots=1;
        %Number of channels per satellite 
        settings.AptNumberChannelsPerSat=2;
        %APT threshold. How many times second peak shall be bigger than
        %third peak
        settings.AptThreshold=2;
        
        %% NAVI settings ===================================================================
        settings.NaviTowActive=1;
        settings.NaviTowPeriodBits=300; 
        
        %% SCB settings ====================================================================
        settings.SbcActive=0;
        settings.SbcPeriod= 1000;%[ms]
    case 3 %'TEXBAT_ds3'
       %% Processing settings ====================================================
        % Number of milliseconds to be processed used 36000 + any transients (see
        % below - in Nav parameters) to ensure nav subframes are provided
        settings.msToProcess        = 37000;      % 37000 [ms]

        % Maximum number of satellites to process. For each satellite, it
        % will be assigned settings.AptNumberChannelsPerSat number of
        % channels for each satellite to process
        settings.maxNumSatToProcess   = 8; %anteriorment es deia numberOfChannels

        % Move the starting point of processing. Can be used to start the signal
        % processing at any point in the data record (e.g. for long records). fseek
        % function is used to move the file read point, therefore advance is byte
        % based only. 
        settings.skipNumberOfBytes     = 0;
        settings.fileStartingReadingSecond=184;
        % Texbat spoofing scenarios may not be perfectly aligned with the
        % cleanStatic signal. In paper "Detailed Analysis of the TEXBAT
        % Datasets Using a High Fidelity Software GPS Receiver" it is
        % detailed these offsets.
        settings.fileStartingOffsetSecond=0; 
        
        settings.powerCorrectionFactor=1;%0.373;
        %% Raw signal file name and other parameter ===============================
        % This is a "default" name of the data file (signal record) to be used in
        % the post-processing mode
        settings.fileName           = 'D:\TexBat_spoofedsignals\ds3.bin';
        % Data type used to store one sample
        settings.dataType           = 'int16';  

        % File Types
        %1 - 8 bit real samples S0,S1,S2,...
        %2 - 8 bit I/Q samples I0,Q0,I1,Q1,I2,Q2,...                      
        settings.fileType           = 2;

        % Intermediate, sampling and code frequencies
        settings.IF                 = 0;     % [Hz]
        settings.samplingFreq       = 25e6;        % [Hz]
        settings.codeFreqBasis      = 1.023e6;     % [Hz]

        % Define number of chips in a code period
        settings.codeLength         = 1023.;

        %% Acquisition settings ===================================================
        % Skips acquisition in the script postProcessing.m if set to 1
        settings.skipAcquisition    = 0;
        % List of satellites to look for. Some satellites can be excluded to speed
        % up acquisition
        settings.acqSatelliteList   = 1:32;         %[PRN numbers]
        % Band around IF to search for satellite signal. Depends on max Doppler.
        % It is single sideband, so the whole search band is tiwce of it.
        settings.acqSearchBand      = 7000;           %[KHz]
        % Non-coherent integration times after 1ms coherent integration
        settings.acqNonCohTime      = 10;                %[ms]
        % Threshold for the signal presence decision rule
        settings.acqThreshold       = 2.5;%3.5
        % Frequency search step for coarse acquisition
        settings.acqSearchStep      = 250;               % [Hz]
        % Sampling rate threshold for downsampling 
        settings.resamplingThreshold    = 8e6;            % [Hz]
        % Enable/dissable use of downsampling for acquisition
        settings.resamplingflag         = 0;              % 0 - Off
                                                          % 1 - On
        % Activates acqusition search grid plots or not. 1 (active), 0 (not active)
        settings.acqInitialPlots=0;
        settings.acqFineFreqSearch=1;
        %% Tracking loops settings ================================================
        % Code tracking loop parameters
        settings.dllDampingRatio         = 0.7;
        settings.dllNoiseBandwidth       = 1.5;       %[Hz]
        settings.dllCorrelatorSpacing    = 0.5;     %[chips]

        % Carrier tracking loop parameters
        settings.pllDampingRatio         = 0.7;
        settings.pllNoiseBandwidth       = 20;      %[Hz]
        % Integration time for DLL and PLL
        settings.intTime                 = 0.001;      %[s]
        %% Navigation solution settings ===========================================

        % Period for calculating pseudoranges and position
        settings.navSolPeriod       = 500;          %[ms]

        % Elevation mask to exclude signals from satellites at low elevation
        settings.elevationMask      = 5;           %[degrees 0 - 90]
        % Enable/dissable use of tropospheric correction
        settings.useTropCorr        = 1;            % 0 - Off
                                                    % 1 - On

        % True position of the antenna in UTM system (if known). Otherwise enter
        % all NaN's and mean position will be used as a reference .
        settings.truePosition.E     = nan;
        settings.truePosition.N     = nan;
        settings.truePosition.U     = nan;

        %% Plot settings ==========================================================
        % Enable/disable plotting of the tracking results for each channel
        settings.plotTracking       = 1;            % 0 - Off; 1 - On
        settings.plotAcquisition = 1;
        settings.plotNavigation = 1;
        %% Constants ==============================================================
        settings.c                  = 299792458;    % The speed of light, [m/s]
        settings.startOffset        = 68.802;       %[ms] Initial sign. travel time

        %% CNo Settings============================================================
        % Accumulation interval in Tracking (in Sec)
        settings.CNo.accTime=0.001;
        % Accumulation interval for computing VSM C/No (in ms)
        settings.CNo.VSMinterval = 40;
        %% APT detection settings ===========================================================
        %Indicates if the APT spoofing detection is ON (1) or OFF (0)
        settings.AptActive=0;
        %Indicates the period of the APT detection (time between detection checks)
        settings.AptPeriod=100; %[ms]
        %Activates acquisition search grid plots or not in the APT spoofing
        %detection. 1 (active), 0 (not active)
        settings.AptPlots=0;
        %Although settings.AptPlots is active, you might not desire to
        %display them, for instance, if you want to save them directly without
        %displaying them.
        settings.AptShowPlots=0;
        %Saves plots in C:\Users\erics\OneDrive\Documentos\MATLAB\TFG\Borre\Images
        settings.AptSavePlots=0;
        %Number of channels per satellite 
        settings.AptNumberChannelsPerSat=2;
        %APT threshold. How many times second peak shall be bigger than
        %third peak
        settings.AptThreshold=2;
        
        %% NAVI settings ===================================================================
        settings.NaviTowActive=1;
        settings.NaviTowPeriodBits=300; 
        %% SCB settings ====================================================================
        settings.SbcActive=0;
        settings.SbcPeriod= 1000;%[ms]
    case 4 %'TEXBAT_ds4'
        %% Processing settings ====================================================
        % Number of milliseconds to be processed used 36000 + any transients (see
        % below - in Nav parameters) to ensure nav subframes are provided
        settings.msToProcess        = 80000;      % 37000 [ms]

        % Maximum number of satellites to process. For each satellite, it
        % will be assigned settings.AptNumberChannelsPerSat number of
        % channels for each satellite to process
        settings.maxNumSatToProcess   = 8; %anteriorment es deia numberOfChannels

        % Move the starting point of processing. Can be used to start the signal
        % processing at any point in the data record (e.g. for long records). fseek
        % function is used to move the file read point, therefore advance is byte
        % based only. 
        settings.skipNumberOfBytes     = 170;
        settings.fileStartingReadingSecond=190;
        % Texbat spoofing scenarios may not be perfectly aligned with the
        % cleanStatic signal. In paper "Detailed Analysis of the TEXBAT
        % Datasets Using a High Fidelity Software GPS Receiver" it is
        % detailed these offsets.
        settings.fileStartingOffsetSecond=0; 
        
        settings.powerCorrectionFactor=1;%0.373;
        %% Raw signal file name and other parameter ===============================
        % This is a "default" name of the data file (signal record) to be used in
        % the post-processing mode
        settings.fileName           = 'D:\TexBat_spoofedsignals\ds4.bin';
        % Data type used to store one sample
        settings.dataType           = 'int16';  

        % File Types
        %1 - 8 bit real samples S0,S1,S2,...
        %2 - 8 bit I/Q samples I0,Q0,I1,Q1,I2,Q2,...                      
        settings.fileType           = 2;

        % Intermediate, sampling and code frequencies
        settings.IF                 = 0;     % [Hz]
        settings.samplingFreq       = 25e6;        % [Hz]
        settings.codeFreqBasis      = 1.023e6;     % [Hz]

        % Define number of chips in a code period
        settings.codeLength         = 1023.;

        %% Acquisition settings ===================================================
        % Skips acquisition in the script postProcessing.m if set to 1
        settings.skipAcquisition    = 0;
        % List of satellites to look for. Some satellites can be excluded to speed
        % up acquisition
        settings.acqSatelliteList   = 1:32;         %[PRN numbers]
        % Band around IF to search for satellite signal. Depends on max Doppler.
        % It is single sideband, so the whole search band is tiwce of it.
        settings.acqSearchBand      = 7000;           %[KHz]
        % Non-coherent integration times after 1ms coherent integration
        settings.acqNonCohTime      = 10;                %[ms]
        % Threshold for the signal presence decision rule
        settings.acqThreshold       = 3.5;
        % Frequency search step for coarse acquisition
        settings.acqSearchStep      = 250;               % [Hz]
        % Sampling rate threshold for downsampling 
        settings.resamplingThreshold    = 8e6;            % [Hz]
        % Enable/dissable use of downsampling for acquisition
        settings.resamplingflag         = 0;              % 0 - Off
                                                          % 1 - On
        % Activates acqusition search grid plots or not. 1 (active), 0 (not active)
        settings.acqInitialPlots=0;
        settings.acqFineFreqSearch=1;
        %% Tracking loops settings ================================================
        % Code tracking loop parameters
        settings.dllDampingRatio         = 0.7;
        settings.dllNoiseBandwidth       = 1.5;       %[Hz]
        settings.dllCorrelatorSpacing    = 0.5;     %[chips]

        % Carrier tracking loop parameters
        settings.pllDampingRatio         = 0.7;
        settings.pllNoiseBandwidth       = 20;      %[Hz]
        % Integration time for DLL and PLL
        settings.intTime                 = 0.001;      %[s]
        %% Navigation solution settings ===========================================

        % Period for calculating pseudoranges and position
        settings.navSolPeriod       = 500;          %[ms]

        % Elevation mask to exclude signals from satellites at low elevation
        settings.elevationMask      = 5;           %[degrees 0 - 90]
        % Enable/dissable use of tropospheric correction
        settings.useTropCorr        = 1;            % 0 - Off
                                                    % 1 - On

        % True position of the antenna in UTM system (if known). Otherwise enter
        % all NaN's and mean position will be used as a reference .
        settings.truePosition.E     = nan;
        settings.truePosition.N     = nan;
        settings.truePosition.U     = nan;

        %% Plot settings ==========================================================
        % Enable/disable plotting of the tracking results for each channel
        settings.plotTracking       = 1;            % 0 - Off; 1 - On
        settings.plotAcquisition = 1;
        settings.plotNavigation = 1;
        %% Constants ==============================================================
        settings.c                  = 299792458;    % The speed of light, [m/s]
        settings.startOffset        = 68.802;       %[ms] Initial sign. travel time

        %% CNo Settings============================================================
        % Accumulation interval in Tracking (in Sec)
        settings.CNo.accTime=0.001;
        % Accumulation interval for computing VSM C/No (in ms)
        settings.CNo.VSMinterval = 40;
        %% APT detection settings ===========================================================
        %Indicates if the APT spoofing detection is ON (1) or OFF (0)
        settings.AptActive=1;
        %Indicates the period of the APT detection (time between detection checks)
        settings.AptPeriod=4000; %[ms]
        %Activates acquisition search grid plots or not in the APT spoofing
        %detection. 1 (active), 0 (not active)
        settings.AptPlots=1;
        %Although settings.AptPlots is active, you might not desire to
        %display them, for instance, if you want to save them directly without
        %displaying them.
        settings.AptShowPlots=0;
        %Saves plots in C:\Users\erics\OneDrive\Documentos\MATLAB\TFG\Borre\Images
        settings.AptSavePlots=1;
        %Number of channels per satellite 
        settings.AptNumberChannelsPerSat=2;
        %APT threshold. How many times second peak shall be bigger than
        %third peak
        settings.AptThreshold=2;
        
        %% NAVI settings ===================================================================
        settings.NaviTowActive=0;
        settings.NaviTowPeriodBits=300; 

        %% SCB settings ====================================================================
        settings.SbcActive=1;
        settings.SbcPeriod= 1000;%[ms]
    case 5 %'TEXBAT_ds5'
        %% Processing settings ====================================================
        % Number of milliseconds to be processed used 36000 + any transients (see
        % below - in Nav parameters) to ensure nav subframes are provided
        settings.msToProcess        = 37000;        %[ms]

        % Maximum number of satellites to process. For each satellite, it
        % will be assigned settings.AptNumberChannelsPerSat number of
        % channels for each satellite to process
        settings.maxNumSatToProcess   = 8; %anteriorment es deia numberOfChannels

        % Move the starting point of processing. Can be used to start the signal
        % processing at any point in the data record (e.g. for long records). fseek
        % function is used to move the file read point, therefore advance is byte
        % based only. 
        settings.skipNumberOfBytes     = 0;

        %% Raw signal file name and other parameter ===============================
        % This is a "default" name of the data file (signal record) to be used in
        % the post-processing mode
        settings.fileName           = 'D:\TexBat_spoofedsignals\ds5.bin';
        % Data type used to store one sample
        settings.dataType           = 'int16';  

        % File Types
        %1 - 8 bit real samples S0,S1,S2,...
        %2 - 8 bit I/Q samples I0,Q0,I1,Q1,I2,Q2,...                      
        settings.fileType           = 2;

        % Intermediate, sampling and code frequencies
        settings.IF                 = 0;     % [Hz]
        settings.samplingFreq       = 25e6;        % [Hz]
        settings.codeFreqBasis      = 1.023e6;     % [Hz]

        % Define number of chips in a code period
        settings.codeLength         = 1023.;

        %% Acquisition settings ===================================================
        % Skips acquisition in the script postProcessing.m if set to 1
        settings.skipAcquisition    = 0;
        % List of satellites to look for. Some satellites can be excluded to speed
        % up acquisition
        settings.acqSatelliteList   = 1:32;         %[PRN numbers]
        % Band around IF to search for satellite signal. Depends on max Doppler.
        % It is single sideband, so the whole search band is tiwce of it.
        settings.acqSearchBand      = 7000;           %[Hz]
        % Non-coherent integration times after 1ms coherent integration
        settings.acqNonCohTime      = 20;                %[ms]
        % Threshold for the signal presence decision rule
        settings.acqThreshold       = 3.5;
        % Frequency search step for coarse acquisition
        settings.acqSearchStep      = 500;               % [Hz]
        % Sampling rate threshold for downsampling 
        settings.resamplingThreshold    = 8e6;            % [Hz]
        % Enable/dissable use of downsampling for acquisition
        settings.resamplingflag         = 0;              % 0 - Off
                                                          % 1 - On
        % Activates acqusition search grid plots or not. 1 (active), 0 (not active)
        settings.acqInitialPlots=0;                                                          
        %% Tracking loops settings ================================================
        % Code tracking loop parameters
        settings.dllDampingRatio         = 0.7;
        settings.dllNoiseBandwidth       = 1.5;       %[Hz]
        settings.dllCorrelatorSpacing    = 0.5;     %[chips]

        % Carrier tracking loop parameters
        settings.pllDampingRatio         = 0.7;
        settings.pllNoiseBandwidth       = 20;      %[Hz]
        % Integration time for DLL and PLL
        settings.intTime                 = 0.001;      %[s]
        %% Navigation solution settings ===========================================

        % Period for calculating pseudoranges and position
        settings.navSolPeriod       = 500;          %[ms]

        % Elevation mask to exclude signals from satellites at low elevation
        settings.elevationMask      = 5;           %[degrees 0 - 90]
        % Enable/dissable use of tropospheric correction
        settings.useTropCorr        = 1;            % 0 - Off
                                                    % 1 - On

        % True position of the antenna in UTM system (if known). Otherwise enter
        % all NaN's and mean position will be used as a reference .
        settings.truePosition.E     = nan;
        settings.truePosition.N     = nan;
        settings.truePosition.U     = nan;

        %% Plot settings ==========================================================
        % Enable/disable plotting of the tracking results for each channel
        settings.plotTracking       = 1;            % 0 - Off; 1 - On
        settings.plotAcquisition = 1;
        settings.plotNavigation = 1;
        %% Constants ==============================================================
        settings.c                  = 299792458;    % The speed of light, [m/s]
        settings.startOffset        = 68.802;       %[ms] Initial sign. travel time

        %% CNo Settings============================================================
        % Accumulation interval in Tracking (in Sec)
        settings.CNo.accTime=0.001;
        % Accumulation interval for computing VSM C/No (in ms)
        settings.CNo.VSMinterval = 40;
        %% APT detection settings ===========================================================
        %Indicates if the APT spoofing detection is ON (1) or OFF (0)
        settings.AptActive=1;
        %Indicates the period of the APT detection (time between detection checks)
        settings.AptPeriod=10000; %[ms]
        %Activates acquisition search grid plots or not in the APT spoofing
        %detection. 1 (active), 0 (not active)
        settings.AptPlots=1;
        %Although settings.AptPlots is active, you might not desire to
        %display them, for instance, if you want to save them directly without
        %displaying them.
        settings.AptShowPlots=0;
        %Saves plots in C:\Users\erics\OneDrive\Documentos\MATLAB\TFG\Borre\Images
        settings.AptSavePlots=1;
        %Number of channels per satellite 
        settings.AptNumberChannelsPerSat=2;
        %APT threshold. How many times second peak shall be bigger than
        %third peak
        settings.AptThreshold=1;
        %% NAVI settings ===================================================================
        settings.NaviTowActive=0;
        settings.NaviTowPeriodBits=300; 
        
        %% SCB settings ====================================================================
        settings.SbcActive=1;
        settings.SbcPeriod= 1000;%[ms]
    case 7 %'TEXBAT_ds7'
       %% Processing settings ====================================================
        % Number of milliseconds to be processed used 36000 + any transients (see
        % below - in Nav parameters) to ensure nav subframes are provided
        settings.msToProcess        = 40000;      % 37000 [ms]

        % Maximum number of satellites to process. For each satellite, it
        % will be assigned settings.AptNumberChannelsPerSat number of
        % channels for each satellite to process
        settings.maxNumSatToProcess   = 8; %anteriorment es deia numberOfChannels

        % Move the starting point of processing. Can be used to start the signal
        % processing at any point in the data record (e.g. for long records). fseek
        % function is used to move the file read point, therefore advance is byte
        % based only. 
        settings.skipNumberOfBytes     = 0;
        settings.fileStartingReadingSecond=220;
        % Texbat spoofing scenarios may not be perfectly aligned with the
        % cleanStatic signal. In paper "Detailed Analysis of the TEXBAT
        % Datasets Using a High Fidelity Software GPS Receiver" it is
        % detailed these offsets.
        settings.fileStartingOffsetSecond=0; 
        
        settings.powerCorrectionFactor=1;%0.373;
        %% Raw signal file name and other parameter ===============================
        % This is a "default" name of the data file (signal record) to be used in
        % the post-processing mode
        settings.fileName           = 'D:\TexBat_spoofedsignals\ds7.bin';
        % Data type used to store one sample
        settings.dataType           = 'int16';  

        % File Types
        %1 - 8 bit real samples S0,S1,S2,...
        %2 - 8 bit I/Q samples I0,Q0,I1,Q1,I2,Q2,...                      
        settings.fileType           = 2;

        % Intermediate, sampling and code frequencies
        settings.IF                 = 0;     % [Hz]
        settings.samplingFreq       = 25e6;        % [Hz]
        settings.codeFreqBasis      = 1.023e6;     % [Hz]

        % Define number of chips in a code period
        settings.codeLength         = 1023.;

        %% Acquisition settings ===================================================
        % Skips acquisition in the script postProcessing.m if set to 1
        settings.skipAcquisition    = 0;
        % List of satellites to look for. Some satellites can be excluded to speed
        % up acquisition
        settings.acqSatelliteList   = 1:32;         %[PRN numbers]
        % Band around IF to search for satellite signal. Depends on max Doppler.
        % It is single sideband, so the whole search band is tiwce of it.
        settings.acqSearchBand      = 7000;           %[KHz]
        % Non-coherent integration times after 1ms coherent integration
        settings.acqNonCohTime      = 10;                %[ms]
        % Threshold for the signal presence decision rule
        settings.acqThreshold       = 3.5;
        % Frequency search step for coarse acquisition
        settings.acqSearchStep      = 250;               % [Hz]
        % Sampling rate threshold for downsampling 
        settings.resamplingThreshold    = 8e6;            % [Hz]
        % Enable/dissable use of downsampling for acquisition
        settings.resamplingflag         = 0;              % 0 - Off
                                                          % 1 - On
        % Activates acqusition search grid plots or not. 1 (active), 0 (not active)
        settings.acqInitialPlots=0;
        settings.acqFineFreqSearch=1;
        %% Tracking loops settings ================================================
        % Code tracking loop parameters
        settings.dllDampingRatio         = 0.7;
        settings.dllNoiseBandwidth       = 1.5;       %[Hz]
        settings.dllCorrelatorSpacing    = 0.5;     %[chips]

        % Carrier tracking loop parameters
        settings.pllDampingRatio         = 0.7;
        settings.pllNoiseBandwidth       = 20;      %[Hz]
        % Integration time for DLL and PLL
        settings.intTime                 = 0.001;      %[s]
        %% Navigation solution settings ===========================================

        % Period for calculating pseudoranges and position
        settings.navSolPeriod       = 500;          %[ms]

        % Elevation mask to exclude signals from satellites at low elevation
        settings.elevationMask      = 5;           %[degrees 0 - 90]
        % Enable/dissable use of tropospheric correction
        settings.useTropCorr        = 1;            % 0 - Off
                                                    % 1 - On

        % True position of the antenna in UTM system (if known). Otherwise enter
        % all NaN's and mean position will be used as a reference .
        settings.truePosition.E     = nan;
        settings.truePosition.N     = nan;
        settings.truePosition.U     = nan;

        %% Plot settings ==========================================================
        % Enable/disable plotting of the tracking results for each channel
        settings.plotTracking       = 1;            % 0 - Off; 1 - On
        settings.plotAcquisition = 1;
        settings.plotNavigation = 1;
        %% Constants ==============================================================
        settings.c                  = 299792458;    % The speed of light, [m/s]
        settings.startOffset        = 68.802;       %[ms] Initial sign. travel time

        %% CNo Settings============================================================
        % Accumulation interval in Tracking (in Sec)
        settings.CNo.accTime=0.001;
        % Accumulation interval for computing VSM C/No (in ms)
        settings.CNo.VSMinterval = 40;
        %% APT detection settings ===========================================================
        %Indicates if the APT spoofing detection is ON (1) or OFF (0)
        settings.AptActive=1;
        %Indicates the period of the APT detection (time between detection checks)
        settings.AptPeriod=1000; %[ms]
        %Activates acquisition search grid plots or not in the APT spoofing
        %detection. 1 (active), 0 (not active)
        settings.AptPlots=0;
        %Although settings.AptPlots is active, you might not desire to
        %display them, for instance, if you want to save them directly without
        %displaying them.
        settings.AptShowPlots=0;
        %Saves plots in C:\Users\erics\OneDrive\Documentos\MATLAB\TFG\Borre\Images
        settings.AptSavePlots=0;
        %Number of channels per satellite 
        settings.AptNumberChannelsPerSat=2;
        %APT threshold. How many times second peak shall be bigger than
        %third peak
        settings.AptThreshold=2;
        
        %% NAVI settings ===================================================================
        settings.NaviTowActive=0;
        settings.NaviTowPeriodBits=300; 
        
        %% SCB settings ====================================================================
        settings.SbcActive=1;
        settings.SbcPeriod= 100;%[ms]
        
    case 8 %'navi_spoofing'
       %% Processing settings ====================================================
        % Number of milliseconds to be processed used 36000 + any transients (see
        % below - in Nav parameters) to ensure nav subframes are provided
        settings.msToProcess        = 40000;      % 37000 [ms]

        % Maximum number of satellites to process. For each satellite, it
        % will be assigned settings.AptNumberChannelsPerSat number of
        % channels for each satellite to process
        settings.maxNumSatToProcess   = 8; %anteriorment es deia numberOfChannels

        % Move the starting point of processing. Can be used to start the signal
        % processing at any point in the data record (e.g. for long records). fseek
        % function is used to move the file read point, therefore advance is byte
        % based only. 
        settings.skipNumberOfBytes     = 0;
        settings.fileStartingReadingSecond=200;
        % Texbat spoofing scenarios may not be perfectly aligned with the
        % cleanStatic signal. In paper "Detailed Analysis of the TEXBAT
        % Datasets Using a High Fidelity Software GPS Receiver" it is
        % detailed these offsets.
        settings.fileStartingOffsetSecond=0; 
        
        settings.powerCorrectionFactor=1;%0.373;
        %% Raw signal file name and other parameter ===============================
        % This is a "default" name of the data file (signal record) to be used in
        % the post-processing mode
        settings.fileName           = 'D:\TexBat_spoofedsignals\gpssim.bin';
        % Data type used to store one sample
        settings.dataType           = 'int16';  

        % File Types
        %1 - 8 bit real samples S0,S1,S2,...
        %2 - 8 bit I/Q samples I0,Q0,I1,Q1,I2,Q2,...                      
        settings.fileType           = 2;

        % Intermediate, sampling and code frequencies
        settings.IF                 = 0;     % [Hz]
        settings.samplingFreq       = 25e6;        % [Hz]
        settings.codeFreqBasis      = 1.023e6;     % [Hz]

        % Define number of chips in a code period
        settings.codeLength         = 1023.;

        %% Acquisition settings ===================================================
        % Skips acquisition in the script postProcessing.m if set to 1
        settings.skipAcquisition    = 0;
        % List of satellites to look for. Some satellites can be excluded to speed
        % up acquisition
        settings.acqSatelliteList   = 1:32;         %[PRN numbers]
        % Band around IF to search for satellite signal. Depends on max Doppler.
        % It is single sideband, so the whole search band is tiwce of it.
        settings.acqSearchBand      = 7000;           %[KHz]
        % Non-coherent integration times after 1ms coherent integration
        settings.acqNonCohTime      = 10;                %[ms]
        % Threshold for the signal presence decision rule
        settings.acqThreshold       = 1.3;
        % Frequency search step for coarse acquisition
        settings.acqSearchStep      = 250;               % [Hz]
        % Sampling rate threshold for downsampling 
        settings.resamplingThreshold    = 8e6;            % [Hz]
        % Enable/dissable use of downsampling for acquisition
        settings.resamplingflag         = 0;              % 0 - Off
                                                          % 1 - On
        % Activates acqusition search grid plots or not. 1 (active), 0 (not active)
        settings.acqInitialPlots=0;
        settings.acqFineFreqSearch=1;
        %% Tracking loops settings ================================================
        % Code tracking loop parameters
        settings.dllDampingRatio         = 0.7;
        settings.dllNoiseBandwidth       = 1.5;       %[Hz]
        settings.dllCorrelatorSpacing    = 0.5;     %[chips]

        % Carrier tracking loop parameters
        settings.pllDampingRatio         = 0.7;
        settings.pllNoiseBandwidth       = 20;      %[Hz]
        % Integration time for DLL and PLL
        settings.intTime                 = 0.001;      %[s]
        %% Navigation solution settings ===========================================

        % Period for calculating pseudoranges and position
        settings.navSolPeriod       = 500;          %[ms]

        % Elevation mask to exclude signals from satellites at low elevation
        settings.elevationMask      = 5;           %[degrees 0 - 90]
        % Enable/dissable use of tropospheric correction
        settings.useTropCorr        = 1;            % 0 - Off
                                                    % 1 - On

        % True position of the antenna in UTM system (if known). Otherwise enter
        % all NaN's and mean position will be used as a reference .
        settings.truePosition.E     = nan;
        settings.truePosition.N     = nan;
        settings.truePosition.U     = nan;

        %% Plot settings ==========================================================
        % Enable/disable plotting of the tracking results for each channel
        settings.plotTracking       = 1;            % 0 - Off; 1 - On
        settings.plotAcquisition = 1;
        settings.plotNavigation = 1;
        %% Constants ==============================================================
        settings.c                  = 299792458;    % The speed of light, [m/s]
        settings.startOffset        = 68.802;       %[ms] Initial sign. travel time

        %% CNo Settings============================================================
        % Accumulation interval in Tracking (in Sec)
        settings.CNo.accTime=0.001;
        % Accumulation interval for computing VSM C/No (in ms)
        settings.CNo.VSMinterval = 40;
        %% APT detection settings ===========================================================
        %Indicates if the APT spoofing detection is ON (1) or OFF (0)
        settings.AptActive=0;
        %Indicates the period of the APT detection (time between detection checks)
        settings.AptPeriod=100; %[ms]
        %Activates acquisition search grid plots or not in the APT spoofing
        %detection. 1 (active), 0 (not active)
        settings.AptPlots=0;
        %Although settings.AptPlots is active, you might not desire to
        %display them, for instance, if you want to save them directly without
        %displaying them.
        settings.AptShowPlots=0;
        %Saves plots in C:\Users\erics\OneDrive\Documentos\MATLAB\TFG\Borre\Images
        settings.AptSavePlots=0;
        %Number of channels per satellite 
        settings.AptNumberChannelsPerSat=2;
        %APT threshold. How many times second peak shall be bigger than
        %third peak
        settings.AptThreshold=1.6;
        
        %% NAVI settings ===================================================================
        settings.NaviTowActive=1;
        settings.NaviTowPeriodBits=300; 
        
        %% SCB settings ====================================================================
        settings.SbcActive=0;
        settings.SbcPeriod= 100;%[ms]
end

        
        
