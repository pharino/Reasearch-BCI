function random_index_generator()
%%  GUI function
%   random_index_generator()
%   Get input:
%   -   M: maximum number of elements
%   -   N: number of selecing elements, N <= M
%   -   K: number of repeating random generation
%   Output: create NxK matrix of random integer value from 1 to M and save.

%%  Get processing inputs
display('>> User: input desired paramters.');
% Defualt parameter
M_str = '200';% Total number of samples
N_str = '150';% number of training set
K_str = '100';% Repeating process

% Create figure for user input
figure_inputs = figure(...
    'MenuBar','none', ...
    'Toolbar','none', ...
    'HandleVisibility','callback', ...
    'Name', 'Random index genterator', ...
    'NumberTitle','off', ...
    'Position',[600,500,500,200],...
    'Resize','off',...
    'Color', get(0, 'defaultuicontrolbackgroundcolor'));

% Table parameters
table.Position          = [10,50,480,130];
table.ColumnFormat      = {'char','char'};
table.ColumnEditable    = [false, true];
table.ColumnName        = {'Paramter','values'};
table.ColumnWidth       = {200,250};
table.Data              = {'M: maximum number of elements',M_str;...
    'N: Number of required elements',N_str;...
    'K: Number of repeatiton selection',K_str};

table.gui = uitable(figure_inputs ,...
    'Units','pixels',...
    'Position',table.Position,...
    'Data',table.Data ,...
    'ColumnName',table.ColumnName,...
    'ColumnWidth',table.ColumnWidth,...
    'ColumnFormat',table.ColumnFormat ,...
    'ColumnEditable',table.ColumnEditable,...
    'Rowname','numbered');

% Set parameters button
pushbutton_set = uicontrol(figure_inputs ,...% pushbutton
    'Style','pushbutton',...
    'String','Set parameters',...
    'Units','pixels',...
    'Position',[10,10,480,30],...
    'Callback',@pushbutton_set_CallbackFcn);

% Wait for user to update parameters
display('>> Waiting for user to select required markers');
uiwait(figure_inputs);

% User clicked on set paramters button
for i = 1:K
    randindex(:,i) = randperm(M,N);
end

%% Create saving dialog panel
display('>> User insert file name for saving');
name = strcat('Random index-',num2str(M),'-',num2str(N),'-',num2str(K),'.mat');

[filename, pathname] = uiputfile({'*.mat'},...
    'Save random index data',...
    fullfile(cd,name));

if isequal(filename,0) || isequal(pathname,0)
    disp('User selected Cancel')
else
    display('>> Saving data in progress! Be patient');
    if strcmp(filename(end-3:end), '.mat')% string has empty at the end
        savedir = fullfile(pathname,filename);
    else
        savedir = fullfile(pathname,[filename,'.mat']);
    end
    save(savedir,'randindex');
end
close all;
clear all;
display('>> Finish saving all data');

%%  Callback function
% Push button for marker selection
    function pushbutton_set_CallbackFcn(hObject, eventdata)
        % Get table data
        table.Data  = get(table.gui,'Data');
        % Update paramters
        M = str2num(table.Data{1,2});% 1s before simuli and 4s after stimuli
        N = str2num(table.Data{2,2});% 256Hz
        K = str2num(table.Data{3,2});% Passband frequencies
        uiresume(gcbf);
        close(figure_inputs);
    end

end

