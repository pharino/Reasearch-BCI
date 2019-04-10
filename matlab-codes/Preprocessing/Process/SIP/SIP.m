%% SCRIPT: subject independent parameters
%   Create a complete structure of subejc indepedenet parameters for EEG
%   analysis which include: times, frequency and spatial
%   Data set:
%   -   BCI competition III data set IVa: 5 subjects
%   -   BCI competition IV data set I: 4 subjects
%
%   Preprocessing stage
%   - 

%% Process controling file
% Clear PC memory
close all;
clear all;
clc;

% Dataset control file for linux system
Process.File.Path       = '/media/pharino/Research Data/CHUM Pharino Master 2011-2013/Research Paper/Matlab code/Signal processing/Preprocessing/Process/SIP';
Process.File.Name{1}    = 'SIP-Linux-Input.txt';   % Input name
Process.File.Name{2}    = 'SIP-Linux-Output.txt';  % Outputfilelinux

% % Dataset control file for Windows system
% Process.File.Path       = 'D:\CHUM Pharino Master 2011-2013\Research Paper\Matlab code\Signal processing\Preprocessing\Process\Preprocessing V5';
% Process.File.Name{1}    = 'Preprocessing V4-Windows-Input.txt';   % Input name
% Process.File.Name{2}    = 'Preprocessing V4-Windows-Output.txt';  % Outputfile

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
    
    % CSP fitness analysis data
    Process.Data.Main       = load(Process.File.Dataset{1,1}{1}{file});
    
    % Times parameters
    sip.time  = parameters.time(file,:);
    
    % Frequency parameters
    sip.frequency = parameters.frequency(file,:);
    
    %% Spatial parameters
    % Caculating t-test to number of selected electrode
    %   
    alpha = 0.01; % Confidential interval 99%
    % Null hypothesis: mean of population is equal to m, with with knowing
    % variance
    % Test mean value
    m = round(mean(mean(Process.Data.Main.ncsp)));
    % T-test
    [h,p,c] = ttest(Process.Data.Main.ncsp,m,alpha);
    
    % If null hypothesis is rejected with alpha sinigicant level, increases
    % alpha value by 1%
    while h == 1
        alpha = alpha + 0.01;
        
        [h,p,c] = ttest(Process.Data.Main.ncsp,m,alpha);
    end
    
    % Keeps result of t-test
    sip.spatial = m;
    sip.ttest.h = h;
    sip.ttest.p = p;
    sip.ttest.c = c;
    
    
    %%  Saving EEG data
    display(strcat('  > Status: Saving data set < ', num2str(file),'>'));
    Save        = sip;
    Process     = rmfield(Process,'Data');
    %   Save Data
    display(Process.File.Dataset{1,2}{1}{file});
    save(Process.File.Dataset{1,2}{1}{file},'-struct','Save','time','frequency','spatial','ttest');
end