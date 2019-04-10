function FeatureExtractionV3(varargin)
%   FeatureExtractionV2
%   Input:
%       BCI competition III, dataset IVa : aa, al, av, aw, ay
%       Path handle file: D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\2012\Conference\ICCAS 2012\Simulation
%       -   File : PreProcessing.tx
%   Output:
%       -   File : Feature Extraction.txt

%%  Process handels control file
%       Dataset control file
Process.File.Path        = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Feature extraction\Process\Feature Extraction V3';
Process.File.Name{1}     = 'Feature Extraction V3-Input.txt';       % Input file
Process.File.Name{2}     = 'Feature Extraction V3-Output.txt';      % Output file

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
    %   STFT transformation
    display('Performing short time Fourier transform...');
    %       Initialize parameters
    Process.Data.Temp.STFT.fs       = Process.Data.Main.Information.fs;
    Process.Data.Temp.STFT.win      = hamming(Process.Data.Temp.STFT.fs);       %   1Hz frequency band
    Process.Data.Temp.STFT.noverlap = length(Process.Data.Temp.STFT.win)- 10;   %   Time resolution (fs-10)/fs
    Process.Data.Temp.STFT.nfft     = 2^nextpow2(length(Process.Data.Temp.STFT.win));  %   FFT sample
    Process.Data.Temp.STFT.epoch    = Process.Data.Main.Information.Epoch;      %   Epoch time of the data
    Process.Data.Temp.STFT.epochSelect  = [0 4];                                %   Choose epoch time from -1 to 4s
    Process.Data.Temp.STFT.freqSelect   = [0 40];                               %   Frequency band from 0 to 40Hz
    
    %       Perform STFT
    Process.Data.Temp.STFT.DataSize     = size(Process.Data.Main.Signal);
    progressbar; %  Progress bar GUI
    
    for tr = 1:Process.Data.Temp.STFT.DataSize(1)       % Loop by trial
        for ch = 1:Process.Data.Temp.STFT.DataSize(2)   % Loop by channel
            [Process.Data.Temp.STFT.Data.Spec,...
                Process.Data.Temp.STFT.Data.Freq,...
                Process.Data.Temp.STFT.Data.Time,...
                Process.Data.Temp.STFT.Data.Power]  = spectrogram(...
                Process.Data.Main.Signal(tr,ch,:),...
                Process.Data.Temp.STFT.win,...
                Process.Data.Temp.STFT.noverlap,...
                Process.Data.Temp.STFT.nfft,...
                Process.Data.Temp.STFT.fs);
            %   The correspond time and frequency index
            if ch == 1
                %   Time index
                Process.Data.Temp.STFT.Data.Time    = Process.Data.Temp.STFT.Data.Time + Process.Data.Temp.STFT.epoch(1);
                Process.Data.Temp.STFT.TimeLimit    = [...
                    max(find(Process.Data.Temp.STFT.Data.Time <= Process.Data.Temp.STFT.epochSelect(1))),...
                    min(find(Process.Data.Temp.STFT.Data.Time >= Process.Data.Temp.STFT.epochSelect(2)))];
                
                %   Update information to dataset output
                Process.Data.Main.Information.STFT.Time = Process.Data.Temp.STFT.Data.Time(...
                    Process.Data.Temp.STFT.TimeLimit(1):Process.Data.Temp.STFT.TimeLimit(2));
                
                %   Frequency index
                Process.Data.Temp.STFT.FreqLimit        = [...
                    max(find(Process.Data.Temp.STFT.Data.Freq <= Process.Data.Temp.STFT.freqSelect(1))),...
                    min(find(Process.Data.Temp.STFT.Data.Freq >= Process.Data.Temp.STFT.freqSelect(2)))];
                
                %   Update information to dataset
                Process.Data.Main.Information.STFT.Freq = Process.Data.Temp.STFT.Data.Freq(...
                    Process.Data.Temp.STFT.FreqLimit(1):Process.Data.Temp.STFT.FreqLimit(2));
            end
            %   Time epoching with log-power
            Process.Data.Temp.STFT.Signal(tr,ch,:,:) = 20*log(Process.Data.Temp.STFT.Data.Power(...
                Process.Data.Temp.STFT.FreqLimit(1):Process.Data.Temp.STFT.FreqLimit(2),...
                Process.Data.Temp.STFT.TimeLimit(1):Process.Data.Temp.STFT.TimeLimit(2)));
        end
        
        progressbar(tr/Process.Data.Temp.STFT.DataSize(1)); % Update progres bar
    end
    
    %       Update data information
    Process.Data.Main           = rmfield(Process.Data.Main,'Signal');
    Process.Data.Main.Signal    = Process.Data.Temp.STFT.Signal;
    Process.Data.Main.Information.SignalSize = size(Process.Data.Main.Signal);
    Process.Data                = rmfield(Process.Data,'Temp');    
       
    %%  -------------------------------------------------------------------
    %   Caculate average power on the window segment
    
    display('Creating sub-window....');
    %       Size and delay for window WindowAverage
    Process.Data.Temp.SubWindow.Parameters.WindowLength  = 0.5;  % 0.5s windpw
    Process.Data.Temp.SubWindow.Parameters.WindowDelay   = 0.25; % 0.25s delay duration
    Process.Data.Temp.SubWindow.Parameters.Time          = Process.Data.Main.Information.STFT.Time;
    
    %       Calculate number of segment window
    Process.Data.Temp.SubWindow.Parameters.SignalSize       = Process.Data.Main.Information.SignalSize;
    Process.Data.Temp.SubWindow.Parameters.SignalLength     = max(Process.Data.Temp.SubWindow.Parameters.Time) - min(Process.Data.Temp.SubWindow.Parameters.Time);
    Process.Data.Temp.SubWindow.Parameters.SegmentNumber    = floor((Process.Data.Temp.SubWindow.Parameters.SignalLength - Process.Data.Temp.SubWindow.Parameters.WindowLength)/...
        Process.Data.Temp.SubWindow.Parameters.WindowDelay) + 1;
    Process.Data.Temp.SubWindow.Parameters.Step(1)          = floor(Process.Data.Temp.SubWindow.Parameters.WindowDelay/(Process.Data.Temp.SubWindow.Parameters.Time(2) - Process.Data.Temp.SubWindow.Parameters.Time(1)));
    Process.Data.Temp.SubWindow.Parameters.Step(2)          = floor(Process.Data.Temp.SubWindow.Parameters.WindowLength/(Process.Data.Temp.SubWindow.Parameters.Time(2) - Process.Data.Temp.SubWindow.Parameters.Time(1)));
    
    %       Prelocate data memory
    Process.Data.Temp.SubWindow.Data = zeros(...
        Process.Data.Temp.SubWindow.Parameters.SignalSize(1),...
        Process.Data.Temp.SubWindow.Parameters.SignalSize(2),...
        Process.Data.Temp.SubWindow.Parameters.SignalSize(3),...
        Process.Data.Temp.SubWindow.Parameters.SegmentNumber,...
        Process.Data.Temp.SubWindow.Parameters.Step(2)+1);
    
    progressbar;
    for N = 1:Process.Data.Temp.SubWindow.Parameters.SegmentNumber
        
        %       Find upper and lower index of the window
        Process.Data.Temp.SubWindow.LowerIndex = 1 + (N-1)*Process.Data.Temp.SubWindow.Parameters.Step(1);
        Process.Data.Temp.SubWindow.UpperBound = Process.Data.Temp.SubWindow.LowerIndex + Process.Data.Temp.SubWindow.Parameters.Step(2);
        
        %       Cutting the subwindow
        Process.Data.Temp.SubWindow.Data(:,:,:,N,:) = Process.Data.Main.Signal(:,:,:,...
            Process.Data.Temp.SubWindow.LowerIndex:Process.Data.Temp.SubWindow.UpperBound);
        progressbar(N/Process.Data.Temp.SubWindow.Parameters.SegmentNumber);
    end
    
    Process.Data.Main.Signal                    = Process.Data.Temp.SubWindow.Data;
    Process.Data.Main.Information.SubWindow     = Process.Data.Temp.SubWindow.Parameters;
    
    %%  -------------------------------------------------------------------
    %   Calculate the average power of subwindow
    
    display('Averaging sub-window power....');
    Process.Data.Main.Signal                    = mean(Process.Data.Main.Signal,5);
    Process.Data.Main.Information.SignalSize    = size(Process.Data.Main.Signal);
    Process.Data                                = rmfield(Process.Data,'Temp');
    
    %%  -------------------------------------------------------------------
    %   Calculate Fisher score for each cross-validation: using training
    %   data in cross-validation 
    
    display('Calculating Fisher score....');
    
    %       For each fold of training data
    Process.Data.Temp.FisherScore.SignalSize    = Process.Data.Main.Information.SignalSize;
    Process.Data.Temp.FisherScore.Fold          = min(size(Process.Data.Main.Information.CrossValidation.Train));
    Process.Data.Temp.FisherScore.Score         = zeros(Process.Data.Temp.FisherScore.Fold,...
        Process.Data.Temp.FisherScore.SignalSize(2)*Process.Data.Temp.FisherScore.SignalSize(3)*Process.Data.Temp.FisherScore.SignalSize(4));
    
    progressbar;
    for Fold = 1:Process.Data.Temp.FisherScore.Fold
        
        %       Class seperation
        Process.Data.Temp.FisherScore.ClassLabel    = unique(Process.Data.Main.Information.class_output);
        Process.Data.Temp.FisherScore.IndexTrain    = Process.Data.Main.Information.CrossValidation.Train(Fold,:);
        Process.Data.Temp.FisherScore.ClassOutput   = Process.Data.Main.Information.class_output;
        
        Process.Data.Temp.FisherScore.Score(Fold,:) = FisherScore(...
            Process.Data.Temp.FisherScore.ClassLabel,...
            Process.Data.Temp.FisherScore.IndexTrain,...
            Process.Data.Temp.FisherScore.ClassOutput,...
            Process.Data.Main.Signal(:,:));
        
        progressbar(Fold/Process.Data.Temp.FisherScore.Fold);
    end
    
    %       Calculate average score
    
    Process.Data.Temp.FisherScore.Score             = mean(Process.Data.Temp.FisherScore.Score,1);    
    [Process.Data.Temp.FisherScore.ScoreSort,...
        Process.Data.Temp.FisherScore.IndexSort]    = sort(Process.Data.Temp.FisherScore.Score, 'descend');
    
    Process.Data.Temp.FisherScore.Score             = Process.Data.Temp.FisherScore.Score(:);
    Process.Data.Temp.FisherScore.ScoreSort         = Process.Data.Temp.FisherScore.ScoreSort(:);
    Process.Data.Temp.FisherScore.IndexSort         = Process.Data.Temp.FisherScore.IndexSort(:);
    
    Process.Data.Main.Information.FisherScore.Score         = Process.Data.Temp.FisherScore.Score;
    Process.Data.Main.Information.FisherScore.ScoreSort     = Process.Data.Temp.FisherScore.ScoreSort;
    Process.Data.Main.Information.FisherScore.IndexSort     = Process.Data.Temp.FisherScore.IndexSort;
    Process.Data = rmfield(Process.Data,'Temp');
    
    %%  -------------------------------------------------------------------
    %   Create 3-D map for Fisher Score
    
    display('Creating 3D map for feature....Channel X Frequency X Time');
    
    Process.Data.Temp.Map3D.SignalSize      = Process.Data.Main.Information.SignalSize(2:length(Process.Data.Main.Information.SignalSize));
    Process.Data.Temp.Map3D.Map             = zeros(prod(Process.Data.Temp.Map3D.SignalSize),3);
    
    progressbar;
    for Index = 1:prod(Process.Data.Temp.Map3D.SignalSize)
        Process.Data.Temp.Map3D.Map(Index,:) = vec2matMap(Index,Process.Data.Temp.Map3D.SignalSize);
        progressbar(Index/prod(Process.Data.Temp.Map3D.SignalSize));
    end
    
    Process.Data.Main.Information.Map3D = Process.Data.Temp.Map3D.Map;
    
    %   -------------------------------------------------------------------
    %   Create EEG structure
    display(strcat('Saving dataset <',num2str(File),'>'));    
    Save        =  Process.Data.Main;
    Process     = rmfield(Process,'Data');
    save(Process.File.Dataset{1,2}{1}{File},'-struct','Save','Signal','Information');
    
end
display('Finish all process!!!');
end

