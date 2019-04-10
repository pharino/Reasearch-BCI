function [ output_args ] = eeg_load_cnt( input_args )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  FUNCTION
%   eeg_load_cnt: input EEG in (*.cnt) format and convert into usable
%   structure file.
%   This function require EEG lab. function, add EEG lab.  to path before
%   running this function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  GUI for browsing file
% Send starting message to screen
display('>> Start convert EEG data from CNT file to MAT file');

% Open file selection menu
eeg_load_cnt.message = {'Select Neuroscan EEG file',...
    'Select electrode position file '};
eeg_load_cnt.filetype = {'*.cnt','*.txt'};
for i = 1:length(eeg_load_cnt.message)
    if i > 1
        path = eeg_load_cnt.path{1};
    else
        path = cd();
    end
    [eeg_load_cnt.file{i},...
        eeg_load_cnt.path{i},...
        eeg_load_cnt.type{i}] = uigetfile(eeg_load_cnt.filetype{i},...
        eeg_load_cnt.message{i},...
        path);
    eeg_load_cnt.fullfile{i} = fullfile(eeg_load_cnt.path{i},...
        eeg_load_cnt.file{i});
end


%% Load electrode position data
%   Initialize variables.
filename = eeg_load_cnt.fullfile{2};
delimiter = '\t';

%   Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%[^\n\r]';

%   Open the text file.
fileID = fopen(filename,'r');

%   Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);

%   Close the text file.
fclose(fileID);

%   Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%   Create output variable
Information.ElectrodePosition= [dataArray{1:end-1}];
%   Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;

%% Converting data using EEGLAB
display('>> Converting CNT data using EEG Lab.');
%   Open EEG lab
eeglab();

% Load cnt file to EEGLAB with pop up function of EEG lab
EEG = pop_loadcnt(eeg_load_cnt.fullfile{1},...
    'dataformat','int16'); % 16bits data format
close all;% close all EEG lab figure

%%  Select keeping electrodes: reduce unwanted electrodes
display('>> User selecting electrode');
%   Logical defining selecting electrode
electrode_select = true(EEG.nbchan,1);
%   Create cell matrix for GUI table data
for i = 1:EEG.nbchan
    electrode_Data{i,1} = true;
    electrode_Data{i,2} = EEG.chanlocs(1,i).labels;
end

%   Figure for electrode selection
figure_electrode = figure(...% Figure for selecting electrodes
    'MenuBar','none', ...
    'Toolbar','none', ...
    'HandleVisibility','callback', ...
    'Name', 'Electrode selection', ...
    'NumberTitle','off', ...
    'Position',[500,200,300,600],...
    'Resize','off',...
    'Color', get(0, 'defaultuicontrolbackgroundcolor'));

%   Create table for select electrodes name
columnformat = {'logical','char'};

table_electrode = uitable(figure_electrode,...
    'Units','pixels',...
    'Position',[10,50,280,530],...
    'ColumnName',{'Logic', 'Electrode name'},...
    'ColumnWidth',{80,150},...
    'ColumnFormat',columnformat ,...
    'RowName',[],...
    'ColumnEditable',[true, false],...
    'Data',electrode_Data,...
    'Rowname','numbered');

%   Execute table button
pushbutton_electrode_done = uicontrol(figure_electrode,...% pushbutton
    'Style','pushbutton',...
    'String','Done',...
    'Units','pixels',...
    'Position',[10,10,280,30],...
    'Callback',@pushbutton_electrode_done_CallbackFcn);

%   Wait for user to select electrode
display('>> Waiting for user to select required electrodes');
uiwait(figure_electrode);

%   Selecting electrode with it position coordinate
Information.ElectrodePosition = Information.ElectrodePosition(...
    electrode_select(1:length(Information.ElectrodePosition)),:);

%%  Table selecting experiment marker
display('>> User select marker and define class lable');
%   Get all marker sample and marker type
for i = 1:length(EEG.event)
    Information.marker_sample(i)= EEG.event(1, i).latency;
    eeg_load_cnt.marker_type(i) = EEG.event(1, i).type;
end
%   Find different type of marker
eeg_load_cnt.marker_unique = unique(eeg_load_cnt.marker_type);
eeg_load_cnt.marker_select = [];
for i = 1:length(eeg_load_cnt.marker_unique);
    table_marker_data{i,1} = true;
    table_marker_data{i,2} = eeg_load_cnt.marker_unique(i);
    table_marker_data{i,3} = i;
    table_marker_data{i,4} = num2str(eeg_load_cnt.marker_unique(i));
end

%   Create table for selecting marker and change new name
figure_table_marker = figure(...       % the main GUI figure
    'MenuBar','none', ...
    'Toolbar','none', ...
    'HandleVisibility','callback', ...
    'Name', 'Marker selection', ...
    'NumberTitle','off', ...
    'Position',[500,300,400,300],...
    'Resize','off',...
    'Color', get(0, 'defaultuicontrolbackgroundcolor'));

%   Table for marker
columnformat = {'logical','numeric','numeric','char'};
table_marker = uitable(figure_table_marker,...
    'Data',table_marker_data,...
    'Units','pixels',...
    'Position',[10,50,380,240],...
    'ColumnName',{'Available', 'Old label','New label',' Real class'},...
    'ColumnWidth',{70,70,70,168},...
    'ColumnFormat',columnformat ,...
    'RowName',[],...
    'ColumnEditable',[true, false,true, true]);

%   Execute table button
pushbutton_marker_done     = uicontrol(figure_table_marker ,...   % Groupbutton parent
    'Style','pushbutton',...
    'String','Done',...
    'Units','pixels',...
    'Position',[10,10,380,30],...
    'Callback',@pushbutton_marker_done_CallbackFcn);

%   Wait for user to select electrode
display('>> Waiting for user to select required markers');
uiwait(figure_table_marker);

%   Callback functin return 'eeg_load_cnt.marker_select', find the marker
%   based on the selected ones. 
temp2 = false(length(eeg_load_cnt.marker_type),1);
for i = 1:length(eeg_load_cnt.marker_select)
    temp1 = [];
    temp1 = (eeg_load_cnt.marker_type == eeg_load_cnt.marker_select(i));
    for j = 1:length(temp1)        
        temp2(j) = temp2(j) || temp1(j); 
    end    
end
%   Select class label for output pattern
Information.class_output    = eeg_load_cnt.marker_type(temp2);
%   Change class label to new label
for i = 1:length(Information.class_output)
    flag = false;
    for j = 1:length(eeg_load_cnt.marker_new)
        if Information.class_output(i) == eeg_load_cnt.marker_select(j)
            Information.class_output(i) = eeg_load_cnt.marker_new(j);
            flag = true;
        end
        if flag == true
            break;
        end
    end    
end
%   Sample of the marker
Information.marker_sample   = Information.marker_sample(temp2);
%   True class label pattern
Information.class_label = eeg_load_cnt.label;
%   Data sampling rate
Information.fs = EEG.srate;

%% Convert EEG data to double precision with current eletrode number
display('>> Copying EEG data');
Signal = double(EEG.data(electrode_select,:));

%%  Saving EEG data
display('>> User insert file name for saving');
[filename, pathname] = uiputfile({'*.mat'},...
    'Save EEG data',...
    eeg_load_cnt.fullfile{1}(1:end-4));

if isequal(filename,0) || isequal(pathname,0)
    disp('User selected Cancel')
else
    display('>> Saving data in progress! Be patient');
    if strcmp(filename(end-3:end), '.mat')% string has empty at the end
        savedir = fullfile(pathname,filename);
    else
        savedir = fullfile(pathname,[filename,'.mat']);
    end
    save(savedir,'Signal','Information');
end
close all;
clear all;
display('>> Finish saving all data');

%%  Callback function
%   Push button for electrode selection
    function pushbutton_electrode_done_CallbackFcn(hObject, eventdata)
        electrode_Data = get(table_electrode,'Data');
        count = 0;
        for c = 1:length(electrode_Data)
            if electrode_Data{c,1} == true
                count = count + 1;
                Information.ElectrodeName{count,1} = electrode_Data{c,2};
            end
            electrode_select(c) = electrode_Data{c,1};
        end
        uiresume(gcbf);
        close(figure_electrode);        
    end

%   Push button for marker selection   
    function pushbutton_marker_done_CallbackFcn(hObject, eventdata)
        table_marker_data = get(table_marker,'Data');
        count = 0;
        class = size(table_marker_data);
        for c = 1:class(1)            
            if table_marker_data{c,1} == true
                count = count + 1;
                eeg_load_cnt.marker_select(count) = table_marker_data{c,2};
                eeg_load_cnt.marker_new(count) = table_marker_data{c,3};
                eeg_load_cnt.label{count} = table_marker_data{c,4};
            end
        end
        uiresume(gcbf);
        close(figure_table_marker);
    end
end


