function Pre_Processing_V2()
%   PreProcessingV2
%   Input:
%       BCI competition III, dataset IVa : aa, al, av, aw, ay
%       Path handle file: D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Preprocessing\Process
%       -   File : Full format dataset 2.txt
%   Output:
%       -   File : PreProcessing 2.txt
%%  Process handels control file
%       Dataset control file
Process.File.Path        = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Preprocessing\Process';
Process.File.Name{1}     = 'Pre_Processing_V2-Input.txt';      % Input name
Process.File.Name{2}     = 'Pre_Processing_V2-Output.txt';           % Outputfile

%       Control file
for File = 1:length(Process.File.Name)
    Process.File.FullName{File} = fullfile(Process.File.Path, Process.File.Name{File});
end
%       dataset file
for File = 1:length(Process.File.FullName)
    fid                     = fopen(Process.File.FullName{File});
    Process.File.Dataset{File}  = textscan(fid,'%s','delimiter','\n');
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
    
    %%  -------------------------------------------------------------------
    %   Apply Spatial Filter: Large Laplacian, 4 neighbor electrodes
    display('Applying spatial filter...');
    Process.Data.Temp.SPF   = spatial_filtering('Filter','Laplacian',...
        'Type','Large',...
        'Neighbor',5,...
        'Clab',Process.Data.Main.Information.clab,...
        'EEG',Process.Data.Main.Signal);
    
    %       Flip data to proceed another process
    Process.Data.Main.Signal    = Process.Data.Temp.SPF{find(strcmp(Process.Data.Temp.SPF,'EEG'))+1};
    Process.Data.Main.Information.Filter.Spatial.Filter = Process.Data.Temp.SPF{find(strcmp(Process.Data.Temp.SPF,'Filter'))+1};
    Process.Data.Main.Information.Filter.Spatial.Type   = Process.Data.Temp.SPF{find(strcmp(Process.Data.Temp.SPF,'Type'))+1};
    Process.Data.Main.Information.Filter.Spatial.Size   = Process.Data.Temp.SPF{find(strcmp(Process.Data.Temp.SPF,'Neighbor'))+1};
    Process.Data                = rmfield(Process.Data,'Temp');
    
    %%  -------------------------------------------------------------------
    %   Epoch signal
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
    
    %%  -------------------------------------------------------------------
    %   Temporal bandpass filter
    display('Filtering signal...');
    Process.Data.Temp.TFilter.paramters.Band        = [7 15; 16 30];
    Process.Data.Temp.TFilter.paramters.Frequency   = [Process.Data.Main.Information.fs Process.Data.Main.Information.fs];
    Process.Data.Temp.TFilter.paramters.Ratio       = 100;
    
    Process.Data.Temp.TFilter.paramters.BandSize    = size(Process.Data.Temp.TFilter.paramters.Band);
    
    for Band = 1: Process.Data.Temp.TFilter.paramters.BandSize(1);
        
        Process.Data.Temp.TFilter.FIR   = fir_parameters(...
            'WindowFunction','hamming',...
            'SamplingFrequency',Process.Data.Temp.TFilter.paramters.Frequency,...
            'RatioOrder',Process.Data.Temp.TFilter.paramters.Ratio,...
            'PassBand',Process.Data.Temp.TFilter.paramters.Band(Band,:),...
            'Plot',1);
        %       Extract filter parameters
        Process.Data.Temp.TFilter.paramters.H  = Process.Data.Temp.TFilter.FIR{find(strcmp(Process.Data.Temp.TFilter.FIR,'FIR1')) + 1 };
        Process.Data.Temp.TFilter.paramters.P  = Process.Data.Temp.TFilter.FIR{find(strcmp(Process.Data.Temp.TFilter.FIR,'P')) + 1 };
        Process.Data.Temp.TFilter.paramters.Q  = Process.Data.Temp.TFilter.FIR{find(strcmp(Process.Data.Temp.TFilter.FIR,'Q')) + 1 };
        
        %       EEG matrix dimension trial X channel X sample
        Process.Data.Main.Information.SignalSize    = size(Process.Data.Main.Signal);
        %       Trial by trial
        for Trial = 1:Process.Data.Main.Information.SignalSize(1)
            %   Channel by channel
            for Channel = 1:Process.Data.Main.Information.SignalSize(2)
                %   Filter data
                Process.Data.Output.Signal(Trial,Channel,Band,:)     = filter(Process.Data.Temp.TFilter.paramters.H,...
                    1,Process.Data.Main.Signal(Trial,Channel,:));
            end
        end
    end
    
    %       Update signal information
    Process.Data.Main.Information.SignalSize            = size(Process.Data.Output.Signal);
    Process.Data.Main.Information.Filter.Temporal.Band  = Process.Data.Temp.TFilter.paramters.Band;
    Process.Data.Main.Information.fs                    = Process.Data.Temp.TFilter.paramters.Frequency(2);
    Process.Data.Main.Signal    =  Process.Data.Output.Signal;
    Process.Data                = rmfield(Process.Data,'Temp');
    Process.Data                = rmfield(Process.Data,'Output');
    
    
    %%  -------------------------------------------------------------------
    %   Create EEG structure
    display(strcat('Saving dataset <',num2str(File),'>'));
    Save     =  Process.Data.Main;
    Process = rmfield(Process,'Data');
    %   Save Data
    save(Process.File.Dataset{1,2}{1}{File},'-struct','Save','Signal','Information');
end

end

