function PreprocessingV3()
%   PreprocessingV1(): properties
%       - Sptial filter: Discrete Laplcian, N = 4
%       - Epoch signal : epoch time [- 2 5]
%       - Resampling   : from 100Hz to 128H
%       - Band pass filter: [7 - 30Hz]


%   Input:
%       BCI competition III, dataset IVa : aa, al, av, aw, ay
%       Path handle file: D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\2012\Conference\ICCAS 2012\Simulation
%       -   File : Full format dataset.txt
%   Output:
%       -   File : PreProcessing.txt
%%  Process handels control file
%       Dataset control file
Process.File.Path        = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Preprocessing\Process';
Process.File.Name{1}     = 'PreprocessingV3-Input.txt';    % Input name
Process.File.Name{2}     = 'PreprocessingV3-Output.txt';          % Outputfile

%       Control file
for File = 1:length(Process.File.Name)
    Process.File.FullName{File} = fullfile(Process.File.Path, Process.File.Name{File});
end
%       dataset file
for File = 1:length(Process.File.FullName)
    fid                                 = fopen(Process.File.FullName{File});
    Process.File.Dataset{File}          = textscan(fid,'%s','delimiter','\n');
    fclose(fid);
end

%%  Apply preProcessing algorithm
for File = 1:length(Process.File.Dataset{1,1}{1})
    
    %%  -------------------------------------------------------------------
    %   Load dataset
    display('--------------------------------------------------------------');
    display(strcat('Loading dataset <',num2str(File),'>'));
    display(Process.File.Dataset{1,1}{1}{File});
    
    Process.Data.Main       = load(Process.File.Dataset{1,1}{1}{File});
    
    
    %%  -------------------------------------------------------------------
    %   Create subject name
    
    display('Create subject name...');
    
    Process.Data.Temp.SubjectName       = [{'aa'},{'al'},{'av'},{'aw'},{'ay'},{'a'},{'b'},{'f'},{'g'}];
    Process.Data.Main.Information.Name  = Process.Data.Temp.SubjectName{File};
    
    %%  -------------------------------------------------------------------
    %   Normilize class output
    
    display('Modify class label to "1" and "0"...');
    
    Process.Data.Temp.ClassNormalize.ClassOutput    = Process.Data.Main.Information.class_output;
    Process.Data.Temp.ClassNormalize.ClassType      = unique(Process.Data.Temp.ClassNormalize.ClassOutput);
    
    for Trial = 1:length(Process.Data.Temp.ClassNormalize.ClassOutput)
        
        for Class = 1:length(Process.Data.Temp.ClassNormalize.ClassType)
            if Process.Data.Temp.ClassNormalize.ClassOutput(Trial) == Process.Data.Temp.ClassNormalize.ClassType(Class)
                Process.Data.Main.Information.class_output(Trial) = Class - 1;
                break;
            end
        end
    end    
       
    %   -------------------------------------------------------------------
    %   Apply Spatial Filter: Large Laplacian, 4 neighbor electrodes
    display('Applying spatial filter...');
    
    Process.Data.Temp.SpatialFilter.Structure   = spatial_filtering('Filter','Laplacian',...
        'Type','Large',...
        'Neighbor',4,...
        'Clab',Process.Data.Main.Information.clab,...
        'EEG',Process.Data.Main.Signal);
    
    Process.Data.Main.Signal    = Process.Data.Temp.SpatialFilter.Structure{find(strcmp(Process.Data.Temp.SpatialFilter.Structure,'EEG'))+1};
    Process.Data.Temp           = rmfield(Process.Data.Temp,'SpatialFilter');
    
    %   -------------------------------------------------------------------
    %   Creating epoch
    display('Cutting signal trial by trial...');
    range   = [-2 5]; % 2 second before stimuli and 5 second after stimuli
    
    Process.Data.Temp.Epoch.Structure   = epoch_signal(range,...
        Process.Data.Main.Information.fs,...
        Process.Data.Main.Information.marker_sample,...
        Process.Data.Main.Signal);
    
    Process.Data.Main.Signal            = Process.Data.Temp.Epoch.Structure{find(strcmp(Process.Data.Temp.Epoch.Structure,'EEG'))+1};
    Process.Data.Main.Information.Epoch = range;
    Process.Data.Temp                   = rmfield(Process.Data.Temp,'Epoch');
    
    %   -------------------------------------------------------------------
    %   Resampling and apply FIR1 bandpass filter
    display('Resamapling data and apply band pass filter...');
    Process.Data.Temp.FIR.Parameters   = fir_parameters('WindowFunction','hamming',...
        'SamplingFrequency',[Process.Data.Main.Information.fs 128],...% sampling frequency and downsampling frequency 
        'RatioOrder',128,...% filter ratio order
        'PassBand',[7 30],...% pass band frequency
        'Plot',0);% plot option
    
    %       Extract filter parameters
    h  = Process.Data.Temp.FIR.Parameters{find(strcmp(Process.Data.Temp.FIR.Parameters,'FIR1')) + 1 };
    p  = Process.Data.Temp.FIR.Parameters{find(strcmp(Process.Data.Temp.FIR.Parameters,'P')) + 1 };
    q  = Process.Data.Temp.FIR.Parameters{find(strcmp(Process.Data.Temp.FIR.Parameters,'Q')) + 1 };
    
    %       EEG matrix dimension trial X channel X sample
    d  = size(Process.Data.Main.Signal);
    %       Trial by trial
    progressbar;
    for tr = 1:d(1)
        %   Channel by channel
        for ch = 1:d(2)
            %   Up sampling, filter and down sampling
            Process.Data.Temp.FIR.Signal(tr,ch,:)     = upfirdn(Process.Data.Main.Signal(tr,ch,:),h,p,q);
        end
        progressbar(tr/d(1));
    end
    %       Update signal information
    Process.Data.Main.Signal                    = Process.Data.Temp.FIR.Signal;
    Process.Data.Main.Information.SignalSize    = size(Process.Data.Main.Signal);
    Process.Data.Main.Information.fs            = 128;      % Resampling to 128Hz
    Process.Data.Main.Information.EpochTime     = (0:(Process.Data.Main.Information.SignalSize(3)-1))*...
        (1/Process.Data.Main.Information.fs) + Process.Data.Main.Information.Epoch(1);
    Process.Data.Main.Information.BandPass      = [7 30]; %   07-30Hz band pass filter
    
    %%  -------------------------------------------------------------------
    %   Create 10 folds random validation data
    
    display('Creating 10-folds validation data...');
    Process.Data.Main.Information.SignalSize            = size(Process.Data.Main.Signal);
    Process.Data.Temp.CrossValidation.TrialSize         = Process.Data.Main.Information.SignalSize(1);
    Process.Data.Temp.CrossValidation.Partition         = [0.6 0.2 0.2];
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
    
    %   -------------------------------------------------------------------
    %   Create EEG structure
    display(strcat('Saving dataset <',num2str(File),'>'));
    Save        =  Process.Data.Main;
    Process     = rmfield(Process,'Data');
    %   Save Data
    save(Process.File.Dataset{1,2}{1}{File},'-struct','Save','Signal','Information');
end

end

