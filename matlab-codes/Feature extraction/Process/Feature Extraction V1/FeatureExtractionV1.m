function FeatureExtractionV1(varargin)
%%  -----------------------------------------------------------------------
%   FeatureExtractionV2
%   Dataset:
%       BCI competition III, dataset IVa : aa, al, av, aw, ay

%   Processing: calculating band power feature of all channels
%   -   Load dataset
%   -   Create 10- random fold cross validation
%   -   Reselecting epoch time
%   -   Caculate the band power and log band power
%   -   Save data to file

%   Path handle file: D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Feature extraction\Process\Feature Extraction V1
%   -   Input file:
%       -   Feature Extraction V1-Input.txt
%   -   Output file:
%       -   Feature Extraction V1-Output.txt



%%  -----------------------------------------------------------------------
%   Process handels control file
%       Dataset control file
Process.File.Path        = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Feature extraction\Process\Feature Extraction V1';
Process.File.Name{1}     = 'Feature Extraction V1-Input.txt';       % Input file
Process.File.Name{2}     = 'Feature Extraction V1-Output.txt';      % Output file

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
    %   Selecting epoch time
    Process.Data.Temp.TimeSample.SelectEpoch    = [0 4];
    if min(Process.Data.Main.Information.TimeSample.Epoch == Process.Data.Temp.TimeSample.SelectEpoch)
        
        display('Select epoch time...');
        Process.Data.Temp.TimeSample.CurrentEpoch   = Process.Data.Main.Information.Time.Epoch;
        Process.Data.Temp.TimeSample.Sample         = (1/Process.Data.Main.Information.fs)*(0:Process.Data.Main.Information.SignalSize.Train(4)-1) +...
            repmat(Process.Data.Temp.TimeSample.CurrentEpoch(1),1,Process.Data.Main.Information.SignalSize.Train(4));
        
        Process.Data.Temp.TimeSample.TimeLimit    = [...
            max(find(Process.Data.Temp.TimeSample.Sample <= Process.Data.Temp.TimeSample.SelectEpoch(1))),...
            min(find(Process.Data.Temp.TimeSample.Sample >= Process.Data.Temp.TimeSample.SelectEpoch(2)))];
        
        Process.Data.Main.Signal.Train = Process.Data.Main.Signal.Train(:,:,:,Process.Data.Temp.TimeSample.TimeLimit(1):Process.Data.Temp.TimeSample.TimeLimit(2));
        Process.Data.Main.Signal.Test  = Process.Data.Main.Signal.Test(:,:,:,Process.Data.Temp.TimeSample.TimeLimit(1):Process.Data.Temp.TimeSample.TimeLimit(2));
        
        
        Process.Data.Main.Information.TimeSample.Epoch     = Process.Data.Temp.TimeSample.SelectEpoch;
        Process.Data.Main.Information.TimeSample.Sample    = Process.Data.Temp.TimeSample.Sample;
        
        Process.Data.Main.Information.SignalSize.Train  = size(Process.Data.Main.Signal.Train);
        Process.Data.Main.Information.SignalSize.Test   = size(Process.Data.Main.Signal.Test);
    end
    
    %%  -------------------------------------------------------------------
    %   Calculate band power
    display('Caculating band power...')
    %       Squaring the signal
    Process.Data.Main.Signal.Train = Process.Data.Main.Signal.Train.^2;
    Process.Data.Main.Signal.Test  = Process.Data.Main.Signal.Test.^2;
    
    %       log-power signal
    Process.Data.Main.Signal.Train = 10.*log(Process.Data.Main.Signal.Train);
    Process.Data.Main.Signal.Test  = 10.*log(Process.Data.Main.Signal.Test);
    
    %       Average over time sample
    Process.Data.Main.Signal.Train = mean(Process.Data.Main.Signal.Train, 4);
    Process.Data.Main.Signal.Test  = mean(Process.Data.Main.Signal.Test, 4);
    
    %%  -------------------------------------------------------------------
    %   Save Data
    display('Saving data...');
    Save        =  Process.Data.Main;
    Process     = rmfield(Process,'Data');
    save(Process.File.Dataset{1,2}{1}{File},'-struct','Save','Signal','Information');
    
end

display('Finish all process!!!');
end

