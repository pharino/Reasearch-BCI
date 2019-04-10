function [ output_args ] = BCI3DataIVa_TrueLabel( input_args )
%%  Description:
%       BCI3DataIVa_TrueLabel: this function include the true label of
%       output class into the dataset

%%  Process handels control file
%       Dataset control file
Process.Path        = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Acquisition';
Process.Name{1}     = 'BCI3DataIVa_TrueLabel_Data.txt';         % Input name
Process.Name{2}     = 'BCI3DataIVa_TrueLabel_Label.txt';        % Outputfile
Process.Name{3}     = 'BCI3DataIVa_TrueLabel_Output.txt';       % True label

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

for i = 1:length(Process.DatasetName{1,1}{1})    
    
end

end

