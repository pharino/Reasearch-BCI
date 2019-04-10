function Classification_V2()

%%  -----------------------------------------------------------------------
%   Description:
%   Classification_V1: classify band power feature of selected electrodes 
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
Process.File.Path       = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Classification\Process\Classification V2';
Process.File.Name{1}    = 'Classification_V2-Input.txt';   % Input file
Process.File.Name{2}    = 'Classification_V2-Output.txt';  % Output file
Process.File.Name{3}    = 'Classification_V2-Channels.txt';  % Output file


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
    %   Select the channels for classification
    
    %       Selected channels
    Process.Data.Temp.Channels.Select   = Process.File.Dataset{1,3}{1,1};
    Process.Data.Temp.Channels.All      = Process.Data.Main.Information.clab(2:length(Process.Data.Main.Information.clab),1);
    
    %       Find index of selected channel
    Process.Data.Temp.Channels.Index = FindIndex(Process.Data.Temp.Channels.Select,Process.Data.Temp.Channels.All);
    
    %       Apply channel selection to data
    Process.Data.Main.Signal.Train = Process.Data.Main.Signal.Train(:,Process.Data.Temp.Channels.Index,:);
    Process.Data.Main.Signal.Test  = Process.Data.Main.Signal.Test(:,Process.Data.Temp.Channels.Index,:);
    
    
    %%  Create index for 5 fold cross-validation
    Process.Data.Temp.CrossValidation.NFold = 5;
    
    [Process.Data.Temp.CrossValidation.Validation,...
        Process.Data.Temp.CrossValidation.Train] = CrossIndex(...
        Process.Data.Temp.CrossValidation.NFold,...
        Process.Data.Main.Information.SignalSize.Train(1));
    
    for i = 1:Process.Data.Temp.CrossValidation.NFold        
        Process.Data.Main.Information.ClassLabel.CrossValidation.Train(i,:)      = Process.Data.Main.Information.ClassLabel.Train(Process.Data.Temp.CrossValidation.Train(i,:));
        Process.Data.Main.Information.ClassLabel.CrossValidation.Validation(i,:) = Process.Data.Main.Information.ClassLabel.Train(Process.Data.Temp.CrossValidation.Validation(i,:));  
    end
    
    Process.Data.Main.Information.Partition.CrossValidation = Process.Data.Temp.CrossValidation;
    
    %%  -------------------------------------------------------------------
    %   Band model selection
    display('Performing Model Selection...');
    for Band = 1:4
        
        %   Selecting feature
        switch Band
            case 1  %   Mu band
                Process.Data.Temp.Classification.Feature.Select = Process.Data.Main.Signal.Train(:,:,1);
            case 2  %   Beta band
                Process.Data.Temp.Classification.Feature.Select = Process.Data.Main.Signal.Train(:,:,2);
            case 3  %   Mu and Beta band
                Process.Data.Temp.Classification.Feature.Select = Process.Data.Main.Signal.Train(:,:,1:2);
            case 4  %   Broad band
                Process.Data.Temp.Classification.Feature.Select = Process.Data.Main.Signal.Train(:,:,3);
        end
        
        %   Rearange feature vector
        Process.Data.Temp.Classification.Feature.Select = Process.Data.Temp.Classification.Feature.Select(:,:);
        
        %   Classification using SVM
        
        [ Process.Data.Temp.Classification.Result.ErrorMean, Process.Data.Temp.Classification.Result.ErrorFold ] = SVMClassification(...
            'linear',...
            'LS',...
            'Train-Validation',...
            Process.Data.Main.Information.Partition.CrossValidation,...
            Process.Data.Main.Information.ClassLabel.Train,....
            Process.Data.Temp.Classification.Feature.Select);
        
        Process.Data.Temp.Classification.Result.AccuracyMean    = mean(100 - 100.*Process.Data.Temp.Classification.Result.ErrorMean);
        Process.Data.Temp.Model.Accuracy(Band)                  = Process.Data.Temp.Classification.Result.AccuracyMean;
        
        Process.Data.Temp = rmfield(Process.Data.Temp,'Classification');
    end
    
    %%  -------------------------------------------------------------------
    %   Applying testing set
    display('Performing Classification over testing set...');
    
    %   Select feature band that have the highest classification accuracy
    Band  = find(max(Process.Data.Temp.Model.Accuracy));
    
    %   Selecting feature
    switch Band
        case 1  %   Mu band
            Process.Data.Temp.Classification.Feature.Train  = Process.Data.Main.Signal.Train(:,:,1);
            Process.Data.Temp.Classification.Feature.Test   = Process.Data.Main.Signal.Test(:,:,1);
        case 2  %   Beta band
            Process.Data.Temp.Classification.Feature.Train  = Process.Data.Main.Signal.Train(:,:,2);
            Process.Data.Temp.Classification.Feature.Test   = Process.Data.Main.Signal.Test(:,:,2);
        case 3  %   Mu and Beta band
            Process.Data.Temp.Classification.Feature.Train  = Process.Data.Main.Signal.Train(:,:,1:2);
            Process.Data.Temp.Classification.Feature.Test   = Process.Data.Main.Signal.Test(:,:,1:2);
        case 4  %   Broad band
            Process.Data.Temp.Classification.Feature.Train  = Process.Data.Main.Signal.Train(:,:,3);
            Process.Data.Temp.Classification.Feature.Test   = Process.Data.Main.Signal.Test(:,:,3);
    end
    %   Rearange feature vector
    Process.Data.Temp.Classification.Feature.Train  = Process.Data.Temp.Classification.Feature.Train(:,:);
    Process.Data.Temp.Classification.Feature.Test   = Process.Data.Temp.Classification.Feature.Test(:,:);
    
    %   Train SVM
    Process.Data.Temp.Classification.SVMStruct = svmtrain(...
        Process.Data.Temp.Classification.Feature.Train,...
        Process.Data.Main.Information.ClassLabel.Train,...
        'Kernel_Function','linear',...
        'method','ls');
    
    %   Test with SVM
    %       Test subject by subject
    [m n] = size(Process.Data.Main.Information.SubjecPartition.Test);
    for i = 1:m
        
        Process.Data.Temp.Classification.ClassLabel.Prediction  = svmclassify(...
            Process.Data.Temp.Classification.SVMStruct,...
            Process.Data.Temp.Classification.Feature.Test(...
            Process.Data.Main.Information.SubjecPartition.Test(i,1):Process.Data.Main.Information.SubjecPartition.Test(i,2),:));
        
        Process.Data.Temp.Classification.ClassLabel.Target      =  Process.Data.Main.Information.ClassLabel.Test(...
            Process.Data.Main.Information.SubjecPartition.Test(i,1):Process.Data.Main.Information.SubjecPartition.Test(i,2));
        
        %   Evaluate the error rate
        Process.Data.Temp.Classification.Result.ErrorRate = erreval('Binary',...
            Process.Data.Temp.Classification.ClassLabel.Prediction,...
            Process.Data.Temp.Classification.ClassLabel.Target); 
        
        Process.Data.Temp.Classification.Result.SubjectAccuracy(i) = 100 - 100*Process.Data.Temp.Classification.Result.ErrorRate;
    end        
end

%%  Create EEG structure for saving data

display(strcat('Saving dataset <',num2str(File),'>'));
Result.Model            = Process.Data.Temp.Model;
Result.Model.BestModel  = Band; 
Result.SubjectAccuracy  = Process.Data.Temp.Classification.Result.SubjectAccuracy;

save(Process.File.Dataset{1,2}{1}{1},'-struct','Result','Model','SubjectAccuracy');
Process = rmfield(Process,'Data');

end
