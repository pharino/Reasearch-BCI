function Pre_Processing_V1()
%%  FUNCTION
%   Pre_Processing_V2()
%   Dataset:
%       BCI competition III, dataset IVa : aa, al, av, aw, ay
%
%   Processing: epoching the signal and filtering
%   -   Load dataset
%   -   Normalise class to +1 or -1
%   -   Epoch the signal
%   -   Temporal filter: 7-15Hz, 16-30Hz, 7-30Hz
%   -   Create time sample marker
%   -   Seperate data into test and training set: by BCI III partition
%   -   Save data to file
%
%   Path handle file: D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Preprocessing\Process\Pre Processing
%   -   Input file:
%       -   Pre_Processing_V1-Input.txt
%   -   Output file:
%       -   Pre_Processing_V1-Output.txt

%%  Process handels control file
%       Dataset control file
Process.File.Path       = 'D:\CHUM Pharino Master 2011-2013\Research Paper\Matlab code\Signal processing\Preprocessing\Process\Pre Processing V1';
Process.File.Name{1}    = 'Pre_Processing_V1-Input1.txt';   % Input name
Process.File.Name{2}    = 'Pre_Processing_V1-Output1.txt';  % Outputfile
Process.File.Name{3}    = 'Pre_Processing_V1-Data Partition1.txt';% Traning and testing set partition
Process.File.Name{4}    = 'Pre_Processing_V1-Name.txt';% Subject name file

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

%%  Merge data for all subjects
MergeData = [];

%%  Apply preProcessing algorithm
for File = 1:length(Process.File.Dataset{1,1}{1})
    
    %%  Load dataset
    display('--------------------------------------------------------------');
    display(strcat('Loading dataset <',num2str(File),'>'));
    display(Process.File.Dataset{1,1}{1}{File});
    
    Process.Data.Main       = load(Process.File.Dataset{1,1}{1}{File});    
    
    %%  Normilize class output to -1 and 1(for binary classes)
    
    display('Modify class label to "-1" and "1"...');
    Process.Data.Main.Information.SignalSize        = size(Process.Data.Main.Signal);
    Process.Data.Temp.ClassNormalize.ClassOutput    = Process.Data.Main.Information.class_output;
    Process.Data.Temp.ClassNormalize.ClassType      = unique(Process.Data.Temp.ClassNormalize.ClassOutput);
    
    for Trial = 1:length(Process.Data.Temp.ClassNormalize.ClassOutput)
        if Process.Data.Temp.ClassNormalize.ClassOutput(Trial) == Process.Data.Temp.ClassNormalize.ClassType(1)
            Process.Data.Main.Information.class_output(Trial) = -1;
        else
            Process.Data.Main.Information.class_output(Trial) = 1;
        end
    end
    
    %%   Segmenting signal
    display('Creating EEG epoch...');
    %       Epoch paramters
    Process.Data.Temp.Epoch.range   = [0 4];    %   4 second after stimuli
    
    Process.Data.Temp.Epoch     = epoch_signal(Process.Data.Temp.Epoch.range,...
        Process.Data.Main.Information.fs,...
        Process.Data.Main.Information.marker_sample,...
        Process.Data.Main.Signal);
    
    %       Flip data to proceed another process
    Process.Data.Main.Signal    = Process.Data.Temp.Epoch{find(strcmp(Process.Data.Temp.Epoch,'EEG'))+1};
    Process.Data.Main.Information.Time.Epoch = Process.Data.Temp.Epoch{find(strcmp(Process.Data.Temp.Epoch,'Range'))+1};
    Process.Data                = rmfield(Process.Data,'Temp');
    
    %%  Temporal filter: bandpass filter: frequency 7-15Hz, 18-22Hz, 7-30Hz
    display('Filtering signal...');
    Process.Data.Temp.TFilter.paramters.Band        = [7 15; 18 22; 7 30];
    Process.Data.Temp.TFilter.paramters.Frequency   = [Process.Data.Main.Information.fs Process.Data.Main.Information.fs];
    Process.Data.Temp.TFilter.paramters.Ratio       = 100;
    
    Process.Data.Temp.TFilter.paramters.BandSize    = size(Process.Data.Temp.TFilter.paramters.Band);
    
    for Band = 1: Process.Data.Temp.TFilter.paramters.BandSize(1);
        
        Process.Data.Temp.TFilter.FIR   = fir_parameters(...
            'WindowFunction','hamming',...
            'SamplingFrequency',Process.Data.Temp.TFilter.paramters.Frequency,...
            'RatioOrder',Process.Data.Temp.TFilter.paramters.Ratio,...
            'PassBand',Process.Data.Temp.TFilter.paramters.Band(Band,:),...
            'Plot',0);
        
        %   Extract filter parameters
        Process.Data.Temp.TFilter.paramters.H  = Process.Data.Temp.TFilter.FIR{find(strcmp(Process.Data.Temp.TFilter.FIR,'FIR1')) + 1 };
        Process.Data.Temp.TFilter.paramters.P  = Process.Data.Temp.TFilter.FIR{find(strcmp(Process.Data.Temp.TFilter.FIR,'P')) + 1 };
        Process.Data.Temp.TFilter.paramters.Q  = Process.Data.Temp.TFilter.FIR{find(strcmp(Process.Data.Temp.TFilter.FIR,'Q')) + 1 };
        
        %   EEG matrix dimension trial X channel X sample
        Process.Data.Main.Information.SignalSize    = size(Process.Data.Main.Signal);
        
        %   Trial by trial
        for Trial = 1:Process.Data.Main.Information.SignalSize(1)
            
            %   Channel by channel
            for Channel = 1:Process.Data.Main.Information.SignalSize(2)
                
                %   Filter data
                Process.Data.Temp.TFilter.Signal(Trial,Channel,Band,:)     = filter(Process.Data.Temp.TFilter.paramters.H,...
                    1,Process.Data.Main.Signal(Trial,Channel,:));
            end
        end
    end
    
    %       Update signal information
    
    Process.Data.Main.Information.SignalSize            = size(Process.Data.Temp.TFilter.Signal);
    Process.Data.Main.Information.Filter.Temporal.Band  = Process.Data.Temp.TFilter.paramters.Band;
    Process.Data.Main.Information.fs                    = Process.Data.Temp.TFilter.paramters.Frequency(2);
    Process.Data.Main.Signal    = Process.Data.Temp.TFilter.Signal;
    Process.Data                = rmfield(Process.Data,'Temp');
    
    %%  Create time sample marker
    display('Creating time marker...');
    Process.Data.Temp.TimeSample.SelectEpoch    = [0 4];
    Process.Data.Temp.TimeSample.CurrentEpoch   = Process.Data.Main.Information.Time.Epoch;
    Process.Data.Temp.TimeSample.Sample         = (1/Process.Data.Main.Information.fs)*(0:Process.Data.Main.Information.SignalSize(4)-1) +...
        repmat(Process.Data.Temp.TimeSample.CurrentEpoch(1),1,Process.Data.Main.Information.SignalSize(4));
    
    Process.Data.Temp.TimeSample.TimeLimit    = [...
        max(find(Process.Data.Temp.TimeSample.Sample <= Process.Data.Temp.TimeSample.SelectEpoch(1))),...
        min(find(Process.Data.Temp.TimeSample.Sample >= Process.Data.Temp.TimeSample.SelectEpoch(2)))];
    Process.Data.Main.Signal = Process.Data.Main.Signal(:,:,:,Process.Data.Temp.TimeSample.TimeLimit(1):Process.Data.Temp.TimeSample.TimeLimit(2));
    
    Process.Data.Main.Information.TimeSample.Epoch     = Process.Data.Temp.TimeSample.SelectEpoch;
    Process.Data.Main.Information.TimeSample.Sample    = Process.Data.Temp.TimeSample.Sample;
    
    %%  Generate data partition for test and training
    display('partitioning data...');
    
    Process.Data.Temp.Partition.TempOutput{1}   = 1:str2double(Process.File.Dataset{1,3}{1}{File});
    Process.Data.Temp.Partition.TempOutput{2}   = str2double(Process.File.Dataset{1,3}{1}{File})+1:Process.Data.Main.Information.SignalSize(1);
    
    Process.Data.Main.Information.Partition.Train = Process.Data.Temp.Partition.TempOutput{1};
    Process.Data.Main.Information.Partition.Test  = Process.Data.Temp.Partition.TempOutput{2};
    
    %   Partitioning Class output label
    Process.Data.Temp.Partition.ClassLabel.Train = Process.Data.Main.Information.class_output(Process.Data.Temp.Partition.TempOutput{1});
    Process.Data.Temp.Partition.ClassLabel.Test  = Process.Data.Main.Information.class_output(Process.Data.Temp.Partition.TempOutput{2});
    
    Process.Data.Main.Information.ClassLabel = Process.Data.Temp.Partition.ClassLabel;
    
    %   Partitioning data
    Process.Data.Temp.Partition.Signal.Train     = Process.Data.Main.Signal(...
        Process.Data.Main.Information.Partition.Train,:,:,:);
    Process.Data.Temp.Partition.Signal.Test     = Process.Data.Main.Signal(...
        Process.Data.Main.Information.Partition.Test,:,:,:);
    
    Process.Data.Main.Signal = Process.Data.Temp.Partition.Signal;
    
    Process.Data.Main.Information.SignalSize.Train  = size(Process.Data.Main.Signal.Train);
    Process.Data.Main.Information.SignalSize.Test   = size(Process.Data.Main.Signal.Test);
    Process.Data        = rmfield(Process.Data,'Temp');
    
    %%  Merging individual ssubject with each other
    display(strcat('Merging dataset <',num2str(File),'>'));
    
    if isempty(MergeData)
        MergeData               =  Process.Data.Main;
        MergeData.Information   = rmfield(MergeData.Information,'class');
        MergeData.Information   = rmfield(MergeData.Information,'class_trial');
        MergeData.Information   = rmfield(MergeData.Information,'class_output');
        MergeData.Information   = rmfield(MergeData.Information,'Partition');
        MergeData.Information   = rmfield(MergeData.Information,'marker_sample');
    else
        
        MergeData.Signal.Train(MergeData.Information.SignalSize.Train(1)+1:MergeData.Information.SignalSize.Train(1)+Process.Data.Main.Information.SignalSize.Train(1),...
            :,:,:) = Process.Data.Main.Signal.Train;
        
        MergeData.Signal.Test(MergeData.Information.SignalSize.Test(1)+1:MergeData.Information.SignalSize.Test(1)+Process.Data.Main.Information.SignalSize.Test(1),...
            :,:,:) = Process.Data.Main.Signal.Test;
        
        %   Class label
        MergeData.Information.ClassLabel.Train(MergeData.Information.SignalSize.Train(1)+1:MergeData.Information.SignalSize.Train(1)+Process.Data.Main.Information.SignalSize.Train(1)) = ...
            Process.Data.Main.Information.ClassLabel.Train;
        MergeData.Information.ClassLabel.Test(MergeData.Information.SignalSize.Test(1)+1:MergeData.Information.SignalSize.Test(1)+Process.Data.Main.Information.SignalSize.Test(1)) = ...
            Process.Data.Main.Information.ClassLabel.Test;
        
        %   Subject name
        MergeData.Information.SubjectName{File} = Process.File.Dataset{1,4}{1}{File};
    end
    
    %   Change dataset size information and accumulate subject name
    MergeData.Information.SignalSize.Train  = size(MergeData.Signal.Train);
    MergeData.Information.SignalSize.Test   = size(MergeData.Signal.Test);
    
    %   Subject name
    MergeData.Information.SubjecPartition.Train(File,1) = MergeData.Information.SignalSize.Train(1)- Process.Data.Main.Information.SignalSize.Train(1) + 1;
    MergeData.Information.SubjecPartition.Train(File,2) = MergeData.Information.SignalSize.Train(1);
    
    MergeData.Information.SubjecPartition.Test(File,1)  = MergeData.Information.SignalSize.Test(1)- Process.Data.Main.Information.SignalSize.Test(1) + 1;
    MergeData.Information.SubjecPartition.Test(File,2)  = MergeData.Information.SignalSize.Test(1);
    
    %   Remove individual subject temporary data
    Process     = rmfield(Process,'Data');
    
end

%%  Save Data
display('Saving final data!');
save(Process.File.Dataset{1,2}{1}{1},'-struct','MergeData','Signal','Information');

end

