function FisherScore_plot(varargin)
%   SCTA 2012 conference: "Optimal EEG Feature Extraction based on R-square Coefficients for Motor Imagery BCI System"
%   Input:
%       BCI competition III, dataset IVa : aa, al, av, aw, ay
%       Path handle file: D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\2012\Conference\SCTA 2012\Simulation
%       -   File : PreProcessing.tx
%   Output:
%       -   File : Feature Extraction.txt

%%  Process handels control file
%       Dataset control file
Process.File.Path        = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Test data';
Process.File.Name{1}     = 'Features.txt';    % Input file

%       Control file
for i = 1:length(Process.File.Name)
    Process.File.FullName{i} = fullfile(Process.File.Path, Process.File.Name{i});
end
%       Dataset file
for i = 1:length(Process.File.FullName)
    fid                     = fopen(Process.File.FullName{i});
    Process.File.Dataset{i}  = textscan(fid,'%s','delimiter','\n');
    fclose(fid);
end

%%  Feature Extraction Process
for i = 1:length(Process.File.Dataset{1,1}{1})
    
    %   -------------------------------------------------------------------
    %%  Load dataset
    Process.Data.Input              = load(Process.File.Dataset{1,1}{1}{i});
    Process.Data.Output.Information = Process.Data.Input.Information;
    
    %   -------------------------------------------------------------------
    %%  Sort score order by descending value
    
    [Process.Data.Input.Information.FisherScore.Score Process.Data.Input.Information.FisherScore.SortIndex] = ...
        sort(Process.Data.Input.Information.FisherScore.Score, 'descend');
    %   -------------------------------------------------------------------
    
    
    
    %%  Rearrange input data-----------------------------------------------
    
    Process.Data        = rmfield(Process.Data,'Input');
    Process.Data        = rmfield(Process.Data,'Temp');
    
    %   Create EEG structure
    EEG     =  Process.Data.Output;
    Process = rmfield(Process,'Data');
    %   Save Data
    save(Process.File.Dataset{1,2}{1}{i},'-struct','EEG','Signal','Information');
    Process.Data        = rmfield(Process.Data,'Output');
end
end

