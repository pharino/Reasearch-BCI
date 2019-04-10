function [ output_args ] = BCI4I_structure( input_args )
%%  Description:
%       BCI3DataIVa_TrueLabel: this function include the true label of
%       output class into the dataset

%%  Process handels control file
%       Dataset control file
Process.Path        = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Acquisition';
Process.Name{1}     = 'BCI4I_structure Input file.txt';         % Input name
Process.Name{2}     = 'BCI4I_structure Output file.txt';        % Outputfile

%       Control file
for File = 1:length(Process.Name)
    Process.FullName{File} = fullfile(Process.Path, Process.Name{File});
end
%       dataset file
for File = 1:length(Process.FullName)
    fid                     = fopen(Process.FullName{File});
    Process.DatasetName{File}  = textscan(fid,'%s','delimiter','\n');
    fclose(fid);
end

for File = 1:length(Process.DatasetName{1,1}{1})
    
    %%  -------------------------------------------------------------------
    %   Load dataset
    display('--------------------------------------------------------------');
    display(strcat('Loading dataset <',num2str(File),'>'));
    Process.Data.Main   = load(Process.DatasetName{1,1}{1}{File});
    
    %%  -------------------------------------------------------------------
    %   Change data type
    display('Convet data type from integer to double...');
    Process.Data.Temp.Convert.Signal = getEEG_signal(Process.Data.Main.cnt,'BCI4');
    
    %%  -------------------------------------------------------------------
    %   Get EEG information from dataset
    display('Getting dataset information...');
    Process.Data.Temp.Convert.nfo           = Process.Data.Main.nfo;
    Process.Data.Temp.Convert.mrk           = Process.Data.Main.mrk;
    Process.Data.Temp.Convert.Information   = getEEG_info(Process.Data.Temp.Convert.mrk,...
        Process.Data.Temp.Convert.nfo,...
        'BCI4');
    %%  -------------------------------------------------------------------
    %   Save data
    display(strcat('Saving dataset <',num2str(File),'>'));
    Save    = Process.Data.Temp.Convert;    
    save(Process.DatasetName{1,2}{1}{File},'-struct','Save','Signal','Information');    
        
end
end

