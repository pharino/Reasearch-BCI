function Classification_V3()

%%  -----------------------------------------------------------------------
%   Description:
%   Classification_V3: classify band power feature of all electrode EEG
%   -   Band on broad band and narrow band EEG
%       -   The Broad band feature frequency range from 7-30Hz
%       -   Narrow band cosist of mu band(7 - 15Hz) and beta band (15 - 30Hz)

%   -   Classifier:
%       -   Support vector machine
%           -   Kernel function: Linear kernel function
%           -   Method: Least square error

%%  -----------------------------------------------------------------------
%   Process handels control file
%       Dataset control file
Process.File.Path       = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Classification\Process\Classification V3';
Process.File.Name{1}    = 'Classification_V3-Input.txt';   % Input file
Process.File.Name{2}    = 'Classification_V3-Output.txt';  % Output file

%       Control file
for i = 1:length(Process.File.Name)
    Process.File.FullName{i} = fullfile(Process.File.Path, Process.File.Name{i});
end
%       Dataset file
for i = 1:length(Process.File.FullName)
    fid                         = fopen(Process.File.FullName{i});
    Process.File.Dataset{i}     = textscan(fid,'%s','delimiter','\n');
    fclose(fid);
end
%%  -----------------------------------------------------------------------
%   Feature Extraction Process
for File = 1:length(Process.File.Dataset{1,1}{1})
    
    %%  -------------------------------------------------------------------
    %   Load dataset
    display('--------------------------------------------------------------');
    display(strcat('Loading dataset <',num2str(File),'>'));
    display(Process.File.Dataset{1,1}{1}{File});
    Process.Data.Main               = load(Process.File.Dataset{1,1}{1}{File});
    
    %%  -------------------------------------------------------------------
    %   Classification EEG pattern using 2 band of frequency
    for Band = 1:4
        
        %   Selecting frequency band
        switch Band
            case 1  %   Mu band
                Process.Data.Temp.Classification.Feature.Select = Process.Data.Main.Signal(:,:,1,:);
            case 2  %   Beta band    
                Process.Data.Temp.Classification.Feature.Select = Process.Data.Main.Signal(:,:,2,:);
            case 3  %   Mu and Beta band
                Process.Data.Temp.Classification.Feature.Select = Process.Data.Main.Signal(:,:,1:2,:);
            case 4  %   Broad band
                Process.Data.Temp.Classification.Feature.Select = Process.Data.Main.Signal(:,:,3,:);
        end
        
        %   Rearange feature vector
        Process.Data.Temp.Classification.Feature.Select = Process.Data.Temp.Classification.Feature.Select(:,:);
        
        %   Classification using SVM
        display('Performing classification data...');        
        [ Process.Data.Temp.Classification.Result.ErrorMean, Process.Data.Temp.Classification.Result.ErrorFold ] = SVMClassification(...
            'linear',...
            'LS',...
            'Train-Test',...
            Process.Data.Main.Information.CrossValidation,...
            Process.Data.Main.Information.class_output,....
            Process.Data.Temp.Classification.Feature.Select);
        
        Process.Data.Temp.Classification.Result.AccuracyMean    = 100 - 100.*Process.Data.Temp.Classification.Result.ErrorMean;
        Process.Data.Output.AccuracyMean(File,Band,:)           = Process.Data.Temp.Classification.Result.AccuracyMean;
        Process.Data = rmfield(Process.Data,'Temp');
    end
    
    display(strcat('Finish dataset subject <',num2str(File),'>'));
end

%%  -------------------------------------------------------------------
    %   Create EEG structure for saving data
    
    display(strcat('Saving dataset <',num2str(File),'>'));
    Save    = Process.Data.Output.AccuracyMean;
    
    save(Process.File.Dataset{1,2}{1}{1},'Save');
    Process = rmfield(Process,'Data');

end
