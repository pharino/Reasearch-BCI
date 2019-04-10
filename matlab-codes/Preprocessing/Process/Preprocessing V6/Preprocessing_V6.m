%% SCRIPT: Preprocessing V6
%   Data set:
%   -   BCI competition III data set IVa: 5 subjects
%   -   BCI competition IV data set I: 4 subjects
%
%   Preprocessing stage
%   -   Time filter: subject independent frequnecies
%   -   Frequnecy filter: subject independent frequnecies

%% Process controling file
% Clear PC memory
close all;
clear all;
clc;

% Dataset control file for linux system
Process.File.Path       = '/media/pharino/Research Data/CHUM Pharino Master 2011-2013/Research Paper/Matlab code/Signal processing/Preprocessing/Process/Preprocessing V6';
Process.File.Name{1}    = 'Preprocessing V6-Linux-Input.txt';   % Input name
Process.File.Name{2}    = 'Preprocessing V6-Linux-Output.txt';  % Outputfilelinux
Process.File.Name{3}    = 'SIP-Linux.txt';  % Random index generator

% % Dataset control file for Windows system
% Process.File.Path       = 'D:\CHUM Pharino Master 2011-2013\Research Paper\Matlab code\Signal processing\Preprocessing\Process\Preprocessing V5';
% Process.File.Name{1}    = 'Preprocessing V6-Windows-Input.txt';   % Input name
% Process.File.Name{2}    = 'Preprocessing V6-Windows-Output.txt';  % Outputfile

%       Control file
for File = 1:length(Process.File.Name)
    Process.File.FullName{File} = fullfile(Process.File.Path, Process.File.Name{File});
end
%       dataset file
for File = 1:length(Process.File.FullName)
    fid                         = fopen(Process.File.FullName{File});
    Process.File.Dataset{File}  = textscan(fid,'%s','delimiter','\n');
    fclose(fid);
end
%% Global parameter
%   These parameters are according to: M.Dalponte, F. Bovolo and L. Bruzzone in
% "Automatic selection of frequency and time intervals for classification of EEG signals"
%   Additional paramters for BCI IV data are manually selected

parameters.time         = [0.5,3.5; 0.5, 3.5; 0.8, 2.0; 0.9, 4.0; 0.8, 2.0; 1.0, 4.0; 1.0, 4.0; 1.0, 4.0; 1.0, 4.0];
parameters.frequency    = [11.5, 13.5; 10.5, 14.5; 11, 14; 10.5, 14.5; 8.5, 21.5; 8, 15; 8, 15; 8, 15;8, 15;];
parameters.ntrain       = [168, 224, 84, 56, 28, 100, 100, 100, 100]; % number of training samples
parameters.nloop        = 100; % number of repeating evaluation
parameters.kfold        = 10;

%%  Preprocesssing algorithm
for file = 1:length(Process.File.Dataset{1,1}{1})
    
    %%  Load EEG data set
    display(strcat('  > Status: Loading dataset <',num2str(file),'>'));
    display(Process.File.Dataset{1,1}{1}{file});
    
    % Raw EEG data
    Process.Data.Main       = load(Process.File.Dataset{1,1}{1}{file});
    Process.Data.Main.Information.SignalSize = size(Process.Data.Main.Signal);
        
    %%  Create EEG segmentation
    segtime = parameters.time(file,:);
    display(strcat('  > Status: Creating EEG segmentation time = [',num2str(segtime),']s'));
    
    Process.Data.Temp.Segmentation   = epoch_signal(segtime,...
        Process.Data.Main.Information.fs,...
        Process.Data.Main.Information.marker_sample,...
        Process.Data.Main.Signal);
    
    % Signal re-modify EEG data
    Process.Data.Main.Signal    = [];% clean old data
    Process.Data.Main.Signal    = Process.Data.Temp.Segmentation{8};% copy new data
    Process.Data.Main.Information.SignalSize = size(Process.Data.Main.Signal);% get new signal size
    Process.Data.Main.Information.MarkerSample = Process.Data.Temp.Segmentation{6};
    Process.Data.Main.Information.Epoch = segtime;
    
    % Clear temporary memory
    Process.Data.Temp = rmfield(Process.Data.Temp,'Segmentation');
    
    %%  Modify data structure of BCI III data set IVa
    trigger_bci = false;% logical true if it is BCI III data
    if Process.Data.Main.Information.fs == 100
        trigger_bci = true;% it is BCI data
        % Modify electrode name
        for i = 1:length(Process.Data.Main.Information.active_channels)
            Process.Data.Main.Information.ElectrodeName{i,1} = Process.Data.Main.Information.clab{i+1,1};
            Process.Data.Main.Information.ElectrodePosition(i,1) = Process.Data.Main.Information.clab{i+1,2};
            Process.Data.Main.Information.ElectrodePosition(i,2) = Process.Data.Main.Information.clab{i+1,3};
        end
        % Remove unused fields
        Process.Data.Main.Information = rmfield(Process.Data.Main.Information,'active_channels');
        Process.Data.Main.Information = rmfield(Process.Data.Main.Information,'clab');
    end
    
    
    %%  Filter and resampling
    %   Resampling and apply FIR1 bandpass filter
    % fdown = 100Hz and filter ratio order to fs/2
    ftarget = 2^nextpow2(Process.Data.Main.Information.fs);
    ratio = Process.Data.Main.Information.fs/2;
    
    %     if trigger_bci == true;% For BCI III data set IVa, fs is 100Hz, so keep
    %         % fdown = 100Hz and filter ratio order to fs/2
    %         ftarget = Process.Data.Main.Information.fs;
    %         ratio = Process.Data.Main.Information.fs/2;
    %     else % URIS data, fs = 500Hz, downsampling to fdown
    %         ftarget = fdown;
    %         ratio = ftarget;
    %     end
    %
    
    % Filtering EEG data
    passband = parameters.frequency(file,:);% subject frequecny band
    display(strcat('  > Status: Filtering signal for frequency band [ ', num2str(passband),']Hz'));
    
    % Create FIR filter window
    Process.Data.Temp.FIR.Parameters   = fir_parameters('WindowFunction','hamming',...
        'SamplingFrequency',[Process.Data.Main.Information.fs, ftarget],...% sampling frequency and downsampling frequency
        'RatioOrder',ratio,...% filter ratio order
        'PassBand',passband,...% pass band frequency
        'Plot',0);% plot option
    
    % Extract filter parameters
    h  = Process.Data.Temp.FIR.Parameters{find(strcmp(Process.Data.Temp.FIR.Parameters,'FIR1')) + 1 };
    p  = Process.Data.Temp.FIR.Parameters{find(strcmp(Process.Data.Temp.FIR.Parameters,'P')) + 1 };
    q  = Process.Data.Temp.FIR.Parameters{find(strcmp(Process.Data.Temp.FIR.Parameters,'Q')) + 1 };
    
    for ch = 1:Process.Data.Main.Information.SignalSize(1)% EEG channel
        for tr = 1:Process.Data.Main.Information.SignalSize(3)% data sample
            %   Up sampling, filter and down sampling
            Process.Data.Temp.FIR.Input = Process.Data.Main.Signal(ch,:,tr);
            Process.Data.Temp.FIR.Input = Process.Data.Temp.FIR.Input(:);
            Process.Data.Temp.FIR.Signal(:,ch,tr) = upfirdn(Process.Data.Temp.FIR.Input,h,p,q);
        end
    end
    
    % Signal re-modify EEG data
    Process.Data.Main.Signal    = [];% clean old data
    Process.Data.Main.Signal    = Process.Data.Temp.FIR.Signal;% copy new data
    Process.Data.Main.Information.SignalSize = size(Process.Data.Main.Signal);% get new signal size
    Process.Data.Main.Information.fs = ftarget;
    Process.Data.Main.Information.MarkerSample = abs(segtime(1))*ftarget+1;
    Process.Data.Main.Information.Passband = passband;
    
    % Clear temporary memory
    Process.Data.Temp = rmfield(Process.Data.Temp,'FIR');
    
    %% Normalize class output to positive integer values
    
    Label = unique(Process.Data.Main.Information.class_output);
    
    for i = 1:length(Process.Data.Main.Information.class_output)
        for k = 1:length(Label)
            if Process.Data.Main.Information.class_output(i) == Label(k)
                Process.Data.Main.Information.class_output(i) = k;
                break;
            end
        end
    end
           
    %%  Saving EEG data
    display(strcat('  > Status: Saving data set < ', num2str(file),'>'));
    Save        = Process.Data.Main;
    Process     = rmfield(Process,'Data');
    %   Save Data
    display(Process.File.Dataset{1,2}{1}{file});
    save(Process.File.Dataset{1,2}{1}{file},'-struct','Save','Signal','Information');
end