function FeatureExtractionV5(varargin)
%%  -----------------------------------------------------------------------
%   FeatureExtractionV5
%   Dataset:
%       BCI competition III, dataset IVa : aa, al, av, aw, ay
%       BCI competition IV, dataset I : a, b, f,g

%   Processing: calculating band power feature of all channels
%   -   Load dataset
%   -   Create 10- random fold cross validation
%   -   Reselecting epoch time
%   -   Caculate Hjorth poarameters
%   -   Save data to file

%   Path handle file: D:\CHUM Pharino Master 2011-2013\Master
%   2011-2013\Research Paper\Matlab code\Signal processing\Feature extraction\Process\Feature Extraction V5
%   -   Input file:
%       -   Feature Extraction V5-Input.txt
%   -   Output file:
%       -   Feature Extraction V5-Output.txt

%%  Process handels control file
%       Dataset control file
Process.File.Path        = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Feature extraction\Process\Feature Extraction V5';
Process.File.Name{1}     = 'Feature Extraction V5-Input.txt';       % Input file
Process.File.Name{2}     = 'Feature Extraction V5-Output.txt';      % Output file

%       Control file
for File = 1:length(Process.File.Name)
    Process.File.FullName{File} = fullfile(Process.File.Path, Process.File.Name{File});
end
%       Dataset file
for File = 1:length(Process.File.FullName)
    fid                     = fopen(Process.File.FullName{File});
    Process.File.Dataset{File}  = textscan(fid,'%s','delimiter','\n');
    fclose(fid);
end

%%  Feature Extraction Process
for File = 1:length(Process.File.Dataset{1,1}{1})
    
    %%  -------------------------------------------------------------------
    %   Load dataset
    display('--------------------------------------------------------------');
    display(strcat('Loading dataset <',num2str(File),'>'));
    display(Process.File.Dataset{1,1}{1}{File});
    Process.Data.Main               = load(Process.File.Dataset{1,1}{1}{File});
    
    %%  -------------------------------------------------------------------
    %   Create 10 folds random validation data if there is not
    %   crossvalidation
    if ~isfield(Process.Data.Main.Information,'CrossValidation')
        display('Creating 10-folds validation data...');
        
        Process.Data.Temp.CrossValidation.TrialSize         = Process.Data.Main.Information.SignalSize(1);
        Process.Data.Temp.CrossValidation.Partition         = [0.6 0.20 0.20];
        Process.Data.Temp.CrossValidation.FoldNumber        = 10;
        
        Process.Data.Temp.CrossValidation.TempOutput        = CPartition(...
            Process.Data.Temp.CrossValidation.TrialSize,...
            Process.Data.Temp.CrossValidation.Partition,...
            Process.Data.Temp.CrossValidation.FoldNumber);
        
        Process.Data.Main.Information.CrossValidation.Train             = Process.Data.Temp.CrossValidation.TempOutput{1};
        Process.Data.Main.Information.CrossValidation.Validation        = Process.Data.Temp.CrossValidation.TempOutput{2};
        Process.Data.Main.Information.CrossValidation.Test              = Process.Data.Temp.CrossValidation.TempOutput{3};
        
        Process.Data.Main.Information.SignalSize            = size(Process.Data.Main.Signal);
        Process.Data        = rmfield(Process.Data,'Temp');
    end
           
    %%  -------------------------------------------------------------------
    %   Calculate Hjorth paramters
    
    Process.Data.Main.Information.SignalSize = size(Process.Data.Main.Signal);
    progressbar;
    for Trial = 1:Process.Data.Main.Information.SignalSize(1)
        for Channel = 1:Process.Data.Main.Information.SignalSize(2)
            for Band = 1:Process.Data.Main.Information.SignalSize(3)
                    Process.Data.Temp.Hjorth.X = Process.Data.Main.Signal(Trial,Channel,Band,:);
                    Process.Data.Temp.Hjorth.X = Process.Data.Temp.Hjorth.X(:);
                    
                    Process.Data.Temp.Hjorth.Activity(Trial,Channel,Band,:)   = Hjorth_activity(Process.Data.Temp.Hjorth.X);
                    
                    Process.Data.Temp.Hjorth.Mobility(Trial,Channel,Band,:)   = Hjorth_mobility(Process.Data.Temp.Hjorth.X);
                    
                    Process.Data.Temp.Hjorth.Complexity(Trial,Channel,Band,:) = Hjorth_complexity(Process.Data.Temp.Hjorth.X);
            end
        end
        progressbar(Trial/Process.Data.Main.Information.SignalSize(1));
    end
    
    Process.Data.Main.Signal = [];
    Process.Data.Main.Signal(:,:,:,1) = Process.Data.Temp.Hjorth.Activity;
    Process.Data.Main.Signal(:,:,:,2) = Process.Data.Temp.Hjorth.Mobility;
    Process.Data.Main.Signal(:,:,:,3) = Process.Data.Temp.Hjorth.Complexity;
    Process.Data = rmfield(Process.Data,'Temp');
    
    %   -------------------------------------------------------------------
    %   Create EEG structure
    display(strcat('Saving dataset <',num2str(File),'>'));    
    Save        =  Process.Data.Main;
    Process     = rmfield(Process,'Data');
    save(Process.File.Dataset{1,2}{1}{File},'-struct','Save','Signal','Information');
    
end
display('Finish all process!!!');
end

