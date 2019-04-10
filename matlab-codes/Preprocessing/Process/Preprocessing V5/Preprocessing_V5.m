%% SCRIPT: Preprocessing V5
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
Process.File.Path       = '/media/pharino/Research Data/CHUM Pharino Master 2011-2013/Research Paper/Matlab code/Signal processing/Preprocessing/Process/Preprocessing V5';
Process.File.Name{1}    = 'Preprocessing V5-Linux-Input.txt';   % Input name
Process.File.Name{2}    = 'Preprocessing V5-Linux-Output.txt';  % Outputfilelinux
Process.File.Name{3}    = 'Preprocessing V5-Linux-Random Index.txt';  % Random index generator

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
for file = 3:length(Process.File.Dataset{1,1}{1})
    
    %%  Load EEG data set
    display(strcat('  > Status: Loading dataset <',num2str(file),'>'));
    display(Process.File.Dataset{1,1}{1}{file});
    
    % Raw EEG data
    Process.Data.Main       = load(Process.File.Dataset{1,1}{1}{file});
    Process.Data.Main.Information.SignalSize = size(Process.Data.Main.Signal);
    
    % Random index generted data
    Process.Data.Temp.RIndex = load(Process.File.Dataset{1,3}{1}{file});
    Process.Data.Temp.RIndex.size = size(Process.Data.Temp.RIndex.randindex);
    
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
    ftarget = Process.Data.Main.Information.fs;
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
    
    %% Spatial filtering using common spatial pattern (CSP)
    for imain = 1:parameters.nloop
        
        %%  Partition data to training and testing set
        % Random select training data, caution for comparing method
        % must use the same random index data
        
        % Create logical vector for training sample
        Process.Data.Temp.DataDivision.TrainLogic = false(...
            Process.Data.Main.Information.SignalSize(3),1);
        
        for i = 1:Process.Data.Temp.RIndex.size(1)
            Process.Data.Temp.DataDivision.TrainLogic( Process.Data.Temp.RIndex.randindex(i,imain)) = true;
        end
        
        Process.Data.Temp.DataDivision.TrainLogic = Process.Data.Temp.DataDivision.TrainLogic(:);
        
        % Training data samples
        Process.Data.Temp.DataDivision.Signal.Train     = Process.Data.Main.Signal(...
            :,:,Process.Data.Temp.DataDivision.TrainLogic);
        Process.Data.Temp.DataDivision.Signal.Train = permute(Process.Data.Temp.DataDivision.Signal.Train,[2,1,3]);
        Process.Data.Temp.DataDivision.SignalSize.Train = size(Process.Data.Temp.DataDivision.Signal.Train);
        Process.Data.Temp.DataDivision.ClassLabel.Train = Process.Data.Main.Information.class_output(...
            Process.Data.Temp.DataDivision.TrainLogic);
        
        % Testing data samples
        Process.Data.Temp.DataDivision.Signal.Test = Process.Data.Main.Signal(...
            :,:,~Process.Data.Temp.DataDivision.TrainLogic,:);
        Process.Data.Temp.DataDivision.Signal.Test = permute(Process.Data.Temp.DataDivision.Signal.Test,[2,1,3]);
        Process.Data.Temp.DataDivision.SignalSize.Test = size(Process.Data.Temp.DataDivision.Signal.Test);
        Process.Data.Temp.DataDivision.ClassLabel.Test = Process.Data.Main.Information.class_output(...
            ~Process.Data.Temp.DataDivision.TrainLogic);
        
        %% Caculating CSP
        %   Calculating CSP
        [Process.Data.Temp.CSP.W,...
            Process.Data.Temp.CSP.lamda,...
            Process.Data.Temp.CSP.index] = spf_csp(...
            Process.Data.Temp.DataDivision.Signal.Train,...
            Process.Data.Temp.DataDivision.ClassLabel.Train );
        
        Process.Data.Temp.CSP.WModel = []; % Selected model CSP
        NCSP = Process.Data.Temp.DataDivision.SignalSize.Train(1);
        
        for icsp = 1:NCSP
            
            % Showing processing status
            display(strcat('>> Status:',...
                ' Data set < ', num2str(file),'> -',...
                ' Repeating < ', num2str(imain),'> -',...
                ' CSP model < ', num2str(icsp),'>'));
            
            if mod(icsp,2) == 1 % Odd,  uses maximum criteria
                [Process.Data.Temp.CSP.W,...
                    Process.Data.Temp.CSP.WModel] = remove_vector(Process.Data.Temp.CSP.W,...
                    Process.Data.Temp.CSP.WModel,...
                    1);
            else % Even,  uses minimum criteria
                [Process.Data.Temp.CSP.W,...
                    Process.Data.Temp.CSP.WModel] = remove_vector(Process.Data.Temp.CSP.W,...
                    Process.Data.Temp.CSP.WModel,...
                    Process.Data.Temp.CSP.Wsize(2));
            end
            Process.Data.Temp.CSP.Wsize = size(Process.Data.Temp.CSP.W);
            
            %% Calcuating output signal from spatial filter
            %   Creating CSP model feature
            for k = 1:Process.Data.Temp.DataDivision.SignalSize.Train(3)
                % Selecting EEG signal
                temp1 = Process.Data.Temp.DataDivision.Signal.Train(:,:,k);
                
                % Filtered signal
                temp2 = Process.Data.Temp.CSP.WModel'*(temp1*temp1')*Process.Data.Temp.CSP.WModel;
                
                % CSP variance feature
                Process.Data.Temp.Classification.Feature.All(:,k) = diag(temp2*temp2');
            end
            
            % K-fold cross validation
            Process.Data.Temp.Classification.Index = CPartition(parameters.ntrain(file),parameters.kfold);
            
            for ival = 1:parameters.kfold
                % Dividing training and validaition set
                Process.Data.Temp.Classification.Feature.Train      = Process.Data.Temp.Classification.Feature.All(:,Process.Data.Temp.Classification.Index{2}(ival,:));
                Process.Data.Temp.Classification.Feature.Validation = Process.Data.Temp.Classification.Feature.All(:,Process.Data.Temp.Classification.Index{1}(ival,:));
                Process.Data.Temp.Classification.Label.Train        = Process.Data.Temp.DataDivision.ClassLabel.Train(Process.Data.Temp.Classification.Index{2}(ival,:));
                Process.Data.Temp.Classification.Label.Validation   = Process.Data.Temp.DataDivision.ClassLabel.Train(Process.Data.Temp.Classification.Index{1}(ival,:));
                
                % Training paralllel PLAs
                [Process.Data.Temp.Classification.W,...
                    Process.Data.Temp.Classification.istop,...
                    Process.Data.Temp.Classification.error] = Classifier_Perceptron(...
                    Process.Data.Temp.Classification.Feature.Train,...
                    Process.Data.Temp.Classification.Label.Train,...
                    'LR', 0.02);
                
                % Classifying validation set
                Process.Data.Temp.Classification.PLabel = Linear_Model(...
                    Process.Data.Temp.Classification.Feature.Validation,...
                    Process.Data.Temp.Classification.W,...
                    'hlim','integer');
                
                % Calculating confusing matrix
                Process.Data.Temp.Classification.ConfusionMatrix = confusionmat(...
                    Process.Data.Temp.Classification.PLabel,...
                    Process.Data.Temp.Classification.Label.Validation);
                
                
                % Calculating fitness value: error + spatial ration
                Process.Data.Temp.Classification.Fitness(ival) = fitness_from_CFM(Process.Data.Temp.Classification.ConfusionMatrix,...
                    icsp/NCSP,...
                    [0.8,0.2],...
                    2);
            end
            
            % Average fitness values of cross-validation
            Process.Data.Temp.Classification.Fitness = mean(Process.Data.Temp.Classification.Fitness);
            % Model fitness value
            Process.Data.Temp.Model.Fitness.CSP(icsp) = Process.Data.Temp.Classification.Fitness;
            Process.Data.Temp = rmfield(Process.Data.Temp,'Classification');
            
        end
        
        %%  Select CSP model
        % Minimizing fitness of models
        [juk1, ncsp] = min(Process.Data.Temp.Model.Fitness.CSP);
        Process.Data.Evaluation.ncsp(imain)         = ncsp; 
        Process.Data.Evaluation.Fitness(imain,:)    = Process.Data.Temp.Model.Fitness.CSP;
        
        % Choose CSP transformation matrix
        Process.Data.Temp.CSP.WModel = Process.Data.Temp.CSP.WModel(:,1:Process.Data.Evaluation.ncsp);
        
        % Apply training and testing set in the final model
        %   Training feature
        for k = 1:Process.Data.Temp.DataDivision.SignalSize.Train(3)
            % Selecting EEG signal
            temp1 = Process.Data.Temp.DataDivision.Signal.Train(:,:,k);
            % Filtered signal
            temp2 = Process.Data.Temp.CSP.WModel'*(temp1*temp1')*Process.Data.Temp.CSP.WModel;
            % CSP variance feature
            Process.Data.Temp.Classification.Feature.Train(:,k) = diag(temp2*temp2');
        end
        
        %   Test feature
        for k = 1:Process.Data.Temp.DataDivision.SignalSize.Test(3)
            % Selecting EEG signal
            temp1 = Process.Data.Temp.DataDivision.Signal.Test(:,:,k);
            % Filtered signal
            temp2 = Process.Data.Temp.CSP.WModel'*(temp1*temp1')*Process.Data.Temp.CSP.WModel;
            % CSP variance feature
            Process.Data.Temp.Classification.Feature.Test(:,k) = diag(temp2*temp2');
        end
        
        Process.Data.Temp.Classification.Label.Train    = Process.Data.Temp.DataDivision.ClassLabel.Train;
        Process.Data.Temp.Classification.Label.Test     = Process.Data.Temp.DataDivision.ClassLabel.Test;
        
        % Training paralllel PLAs
        [Process.Data.Temp.Classification.W,...
            Process.Data.Temp.Classification.istop,...
            Process.Data.Temp.Classification.error] = Classifier_Perceptron(...
            Process.Data.Temp.Classification.Feature.Train,...
            Process.Data.Temp.Classification.Label.Train,...
            'LR', 0.02);
        
        % Classifying training set
        Process.Data.Temp.Classification.PLabel.Train = Linear_Model(...
            Process.Data.Temp.Classification.Feature.Train,...
            Process.Data.Temp.Classification.W,...
            'hlim','integer');
        % Classifying test set
        Process.Data.Temp.Classification.PLabel.Test = Linear_Model(...
            Process.Data.Temp.Classification.Feature.Test,...
            Process.Data.Temp.Classification.W,...
            'hlim','integer');
        
        % Calculating confusing matrix of training  and test set
        Process.Data.Temp.Classification.ConfusionMatrix.Train = confusionmat(...
            Process.Data.Temp.Classification.PLabel.Train,...
            Process.Data.Temp.Classification.Label.Train);
        Process.Data.Temp.Classification.ConfusionMatrix.Test = confusionmat(...
            Process.Data.Temp.Classification.PLabel.Test,...
            Process.Data.Temp.Classification.Label.Test);
        
        % Calculaing fitness(Classification error rate includes)
        for i = 1:8
            Process.Data.Temp.Classification.Fitness.Train(i)  = fitness_from_CFM(Process.Data.Temp.Classification.ConfusionMatrix.Train,...
                ncsp/NCSP,...
                [0.8,0.2],...
                i);
            Process.Data.Temp.Classification.Fitness.Test(i)   = fitness_from_CFM(Process.Data.Temp.Classification.ConfusionMatrix.Test,...
                ncsp/NCSP,...
                [0.8,0.2],...
                i);
        end
        
        % Result of CSP model
        Process.Data.Evaluation.Performance.Train(imain,:) = Process.Data.Temp.Classification.Fitness.Train;
        Process.Data.Evaluation.Performance.Test(imain,:)  = Process.Data.Temp.Classification.Fitness.Test;
        % CSP model feature
        Process.Data.Evaluation.Feature{imain} = Process.Data.Temp.Classification.Feature;
        % Remove repeating structure
        Process.Data.Temp = rmfield(Process.Data.Temp,'Classification');
    end
    
    %%  Saving EEG data
    display(strcat('  > Status: Saving data set < ', num2str(file),'>'));
    Save        = Process.Data.Evaluation;
    Process     = rmfield(Process,'Data');
    %   Save Data
    display(Process.File.Dataset{1,2}{1}{file});
    save(Process.File.Dataset{1,2}{1}{file},'-struct','Save','ncsp','Fitness','Feature','Performance');
end