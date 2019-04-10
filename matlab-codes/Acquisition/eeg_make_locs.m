function [ output_args ] = eeg_make_locs( varargin )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  FUNCTION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Create data choice figure to select between 2D or 3D data
%   Create dialog box for chooosing 2D data or 3D data
eml_choice = questdlg('Please select dimension of electrode coordinate',...
    'Electrode coordinate type',...
    'From Matlab file', 'From seperate file','From seperate file');
%   Handle the response
switch eml_choice
    case 'From Matlab file'
        data_type = 0;
    case 'From seperate file'
        data_type = 1;
end


%%  User input 2D electrode position coordinate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if data_type == 0
    %% Open file selection menu
    eeg_make_locs.message = 'Select EEG data file';
    
    eeg_make_locs.filetype = {'*.mat'};
    path = cd();
    [eeg_make_locs.file,...
        eeg_make_locs.path,...
        eeg_make_locs.type] = uigetfile(eeg_make_locs.filetype,...
        eeg_make_locs.message,...
        path);
    
    eeg_make_locs.fullfile= fullfile(eeg_make_locs.path,...
        eeg_make_locs.file);
    
    eeg_make_locs.Data = load(eeg_make_locs.fullfile);
    
    %   Get electrode x and y position
    for i = 1:length(eeg_make_locs.Data.Information.active_channels)
        %   X coordinate
        xy(i,1) = eeg_make_locs.Data.Information.clab{i+1,2};
        %   Y coordinate
        xy(i,2) = eeg_make_locs.Data.Information.clab{i+1,3};
    end
    
    r = sqrt(xy(:,1).^2 + xy(:,2).^2);
    theta = atan(xy(:,1)./ xy(:,2));
    theta = theta.*90;
    
    %%  User input 3D electrode position coordinate
else
    %% Open file selection menu
    eeg_make_locs.message = {'Select electrode label file',...
        'Select electrode numbering file',...
        'Select electrode position file '};
    eeg_make_locs.filetype = {'*.txt','*.txt','*.txt'};
    for i = 1:length(eeg_make_locs.message)
        if i > 1
            path = eeg_make_locs.path{1};
        else
            path = cd();
        end
        [eeg_make_locs.file{i},...
            eeg_make_locs.path{i},...
            eeg_make_locs.type{i}] = uigetfile(eeg_make_locs.filetype{i},...
            eeg_make_locs.message{i},...
            path);
        
        eeg_make_locs.fullfile{i} = fullfile(eeg_make_locs.path{i},...
            eeg_make_locs.file{i});
    end
    
    
    %% Load data file
    
    for i = 1:length(eeg_make_locs.message)
        %   Initialize variables.
        filename = eeg_make_locs.fullfile{i};
        
        switch i
            case 1% Electrode label file
                delimiter = '';
                formatSpec = '%s%[^\n\r]';
            case 2% Electrode numbering file
                delimiter = '';
                formatSpec = '%f%[^\n\r]';
            case 3% Electrode position file
                delimiter = '\t';
                formatSpec = '%f%f%f%[^\n\r]';
        end
        
        %   Open the text file.
        fileID = fopen(filename,'r');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        %   Close the text file.
        fclose(fileID);
        %   Create output variable
        eeg_make_locs.Data{i} = [dataArray{1:end-1}];
        %   Clear temporary variables
        clearvars filename delimiter formatSpec fileID dataArray ans;
        
    end
    
    %   Convert from cartesain to spheric coordinates
    [eeg_make_locs.topo.theta,...
        eeg_make_locs.topo.r] = cart2topo(eeg_make_locs.Data{3});
    
    %   Concernation data into cell matrix
    data = cat(2,num2cell(eeg_make_locs.Data{2}),...
        num2cell(eeg_make_locs.topo.theta),...
        num2cell(eeg_make_locs.topo.r),...
        eeg_make_locs.Data{1})';
            
    %%  Saving EEG data
    [filename, pathname] = uiputfile({'*.loc'},...
        'Save EEG data',...
        eeg_make_locs.file{1}(1:end-4));
    
    if isequal(filename,0) || isequal(pathname,0)
        disp('User selected Cancel')
    else
        disp(' Saving acquisition EEG data');
        if strcmp(filename(end-4:end), '.loc')
            savedir = fullfile(pathname,filename(end-4:end));
        else
            savedir = fullfile(pathname,filename);
        end
        
        fid = fopen(savedir, 'w');
        fprintf(fid, '%u\t%f\t%f\t%s\n', data{:});
        fclose(fid);
    end
    clear all;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

