function Acquisition_V1()
%   Acquisition V1:
%   Include 
%   Input:
%       BCI competition III, dataset IVa : aa, al, av, aw, ay
%       Path handle file: D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\2012\Conference\ICCAS 2012\Simulation
%       -   File : Raw EEG.txt
%       -   True label: True label.txt
%   Output:
%       -   File : Structed EEG.txt

%%  Process handels control file
%       Dataset control file
Process.Path        = 'D:\CHUM Pharino Master 2011-2013\Research Paper\Matlab code\Signal processing\Acquisition';
Process.Name{1}     = 'Acquisition V1-Raw EEG.txt';        % Input name
Process.Name{2}     = 'Acquisition V1-Structured EEG.txt'; % Outputfile
Process.Name{3}     = 'Acquisition V1-True labels.txt';        % True label

%       Control file
for i = 1:length(Process.Name)
    Process.FullName{i} = fullfile(Process.Path, Process.Name{i});
end
%       dataset file
for i = 1:length(Process.FullName)
    fid                     = fopen(Process.FullName{i});
    Process.DatasetName{i}  = textscan(fid,'%s','delimiter','\n');
    fclose(fid);
end

%%  Acquire singal and save
for i = 1:length(Process.DatasetName{1,1}{1})    
    display(['Processing data set <',num2str(i),'>']);
    %   Load dataset
    Process.Data.Input    = load(Process.DatasetName{1,1}{1}{i});
    
    %   Get EEG information from dataset
    nfo     = Process.Data.Input.nfo;
    mrk     = Process.Data.Input.mrk;
    
    %   Load true labels of dataset
    if isempty(Process.DatasetName{1,3}{1}{i})
        mrk.y   = Process.Data.Input.mrk.y;
        
    else
        label   = load(Process.DatasetName{1,3}{1}{i});
        mrk.y   = label.true_y;
    end
        
    %   Transform from integer to double
    Process.Data.Output.Signal  = getEEG_signal(Process.Data.Input.cnt,'BCI3');   
    Process.Data.Output.Information    = getEEG_info(mrk,nfo,'BCI3');
    
    %   Create EEG structure
    EEG     =  Process.Data.Output;
    Process = rmfield(Process,'Data');
    %   Save Data
    display(['--> Saving data set <',num2str(i),'>']);
    save(Process.DatasetName{1,2}{1}{i},'-struct','EEG','Signal','Information');    
    
end
end

