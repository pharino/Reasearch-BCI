function Pre_Processing_V4()
%%  FUNCTION :Pre_Processing_V4:
%
%   Dataset:
%   -   URIS data: RIM-RLF(real and imagery of right hand, left hand and
%   foot movement)
%
%   Process parameters:
%   -   segment time(s): [l,h] where a is lower bound, b is upper bound
%   -   Downsampling frequency(Hz):fup targert resampling frequency
%   -   Matrix of band pass frequency: N by 2 matrix, N is number of
%       filter bands. The first column is high pass frequency, second
%       column is low pass frequency.
%
%   Processing stage:
%   -   Get process parameter,
%   -   Segementing EEG signal
%   -   Setting signle marker sample for signal
%   -   Downsampling and filter
%   -   Maintain marker sample for new signal
%
%   File hand:
%       For linux OS:
%       -   Path handle file: /media/pharino/Research Data/CHUM Pharino Master 2011-2013/Research Paper/Matlab code/Signal processing/Preprocessing/Process/Pre Processing V4
%       -   Input file: Preprocessing V3-linux-Input.txt
%       -   Output file:Preprocessing V3-linux-Output.txt

%%  Process handels control file
% Clear PC memory
close all;
clear all;

% Dataset control file for linux system
Process.File.Path       = '/media/pharino/Research Data/CHUM Pharino Master 2011-2013/Research Paper/Matlab code/Signal processing/Preprocessing/Process/Pre Processing V4';
Process.File.Name{1}    = 'Preprocessing V4-linux-Input.txt';   % Input name
Process.File.Name{2}    = 'Preprocessing V4-linux-Output.txt';  % Outputfile

% % Dataset control file for Windows system
% Process.File.Path       = 'D:\CHUM Pharino Master 2011-2013\Research Paper\Matlab code\Signal processing\Preprocessing\Process\Pre Processing V4';
% Process.File.Name{1}    = 'Preprocessing V4-Windows-Input.txt';   % Input name
% Process.File.Name{2}    = 'Preprocessing V4-Windows-Output.txt';  % Outputfile

%       Control file
for File = 1:length(Process.File.Name)
    Process.File.FullName{File} = fullfile(Process.File.Path, Process.File.Name{File});
end
%       dataset file
for File = 1:length(Process.File.FullName)
    fid                         = fopen(Process.File.FullName{File});
    Process.File.Dataset{File}  = textscan(fid,'%s','delimiter','\n');
    fclose(fid);
end

%%  Get processing inputs
% Defualt parameter
segtime = '-1,4';% 1s before simuli and 4s after stimuli
fdown   = '128';% 256Hz
passband   = '7,14; 15,22; 23,30; 7,30';% Passband frequencies

% Create figure for user input
figure_inputs = figure(...
    'MenuBar','none', ...
    'Toolbar','none', ...
    'HandleVisibility','callback', ...
    'Name', 'Preprocessing V4 parameters setting', ...
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
table.Data              = {'Time segment(S)',segtime;...
    'Down sampling frequency(Hz)',fdown;...
    'Passband(Hz)',passband};

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

%%  Apply preprocessing algorithm
for file = 1:length(Process.File.Dataset{1,1}{1})
    
    %%  Load EEG data set
    display(strcat('  > Status: Loading dataset <',num2str(file),'>'));
    display(Process.File.Dataset{1,1}{1}{file});
    
    Process.Data.Main       = load(Process.File.Dataset{1,1}{1}{file});
    Process.Data.Main.Information.SignalSize = size(Process.Data.Main.Signal);
    
    %%  Create EEG segmentation
    display(strcat('  > Status: Creating EEG segmentation time = [',num2str(segtime),']s'));
    
    Process.Data.Temp.Segmentation   = epoch_signal(segtime,...
        Process.Data.Main.Information.fs,...
        Process.Data.Main.Information.marker_sample,...
        Process.Data.Main.Signal);
    
    % Signal re-modify EEG data
    Process.Data.Main.Signal    = [];% clean old data
    Process.Data.Main.Signal    = Process.Data.Temp.Segmentation{8};% copy new data
    Process.Data.Main.Information.SignalSize = size(Process.Data.Main.Signal);% get new signal size
    Process.Data.Main.Information.marker_sample = Process.Data.Temp.Segmentation{6};
    Process.Data.Main.Information.Epoch = segtime;
    
    % Clear temporary memory
    Process.Data.Temp = rmfield(Process.Data.Temp,'Segmentation');
    
    %%  Modify data structure of BCI III data set IVa
    trigger_bci = false;% logical true if it is BCI III data
    if Process.Data.Main.Information.fs == 100
        trigger_bci = true;% it is BCI data
        % Modify electrode name
        for i = 1:length(Process.Data.Main.Information.active_channels)
            Process.Data.Main.Information.ElectrodeName{i,1} = Process.Data.Main.Information.clab{i+1,1};
            Process.Data.Main.Information.ElectrodePosition(i,1) = Process.Data.Main.Information.clab{i+1,2};
            Process.Data.Main.Information.ElectrodePosition(i,2) = Process.Data.Main.Information.clab{i+1,3};
        end
        % Remove unused fields
        Process.Data.Main.Information = rmfield(Process.Data.Main.Information,'active_channels');
        Process.Data.Main.Information = rmfield(Process.Data.Main.Information,'clab');
    end
    
    
    %%  Filter and resampling
    %   Resampling and apply FIR1 bandpass filter
    
    if trigger_bci == true;% For BCI III data set IVa, fs is 100Hz, so keep
        % fdown = 100Hz and filter ratio order to fs/2
        ftarget = Process.Data.Main.Information.fs;
        ratio = Process.Data.Main.Information.fs/2;
    else % URIS data, fs = 500Hz, downsampling to fdown
        ftarget = fdown;
        ratio = ftarget;
    end
    
    % Filtering EEG data
    bandsize = size(passband);
    for f = 1:bandsize(1)
        display(strcat('  > Status: Filtering signal for frequency band [ ', num2str(passband(f,:)),']Hz'));
        % Create FIR filter window
        Process.Data.Temp.FIR.Parameters   = fir_parameters('WindowFunction','hamming',...
            'SamplingFrequency',[Process.Data.Main.Information.fs, ftarget],...% sampling frequency and downsampling frequency
            'RatioOrder',ratio,...% filter ratio order
            'PassBand',passband(f,:),...% pass band frequency
            'Plot',0);% plot option
        
        % Extract filter parameters
        h  = Process.Data.Temp.FIR.Parameters{find(strcmp(Process.Data.Temp.FIR.Parameters,'FIR1')) + 1 };
        p  = Process.Data.Temp.FIR.Parameters{find(strcmp(Process.Data.Temp.FIR.Parameters,'P')) + 1 };
        q  = Process.Data.Temp.FIR.Parameters{find(strcmp(Process.Data.Temp.FIR.Parameters,'Q')) + 1 };
        
        for ch = 1:Process.Data.Main.Information.SignalSize(1)% EEG channel
            for tr = 1:Process.Data.Main.Information.SignalSize(3)% data sample
                %   Up sampling, filter and down sampling
                Process.Data.Temp.FIR.Input = Process.Data.Main.Signal(ch,:,tr);
                Process.Data.Temp.FIR.Input = Process.Data.Temp.FIR.Input(:);
                Process.Data.Temp.FIR.Signal(:,ch,f,tr) = upfirdn(Process.Data.Temp.FIR.Input,h,p,q);
            end
        end
    end
    
    % Signal re-modify EEG data
    Process.Data.Main.Signal    = [];% clean old data
    Process.Data.Main.Signal    = Process.Data.Temp.FIR.Signal;% copy new data
    Process.Data.Main.Information.SignalSize = size(Process.Data.Main.Signal);% get new signal size
    Process.Data.Main.Information.fs = ftarget;
    Process.Data.Main.Information.marker_sample = abs(segtime(1))*ftarget+1;
    Process.Data.Main.Information.Passband = passband;
    
    % Clear temporary memory
    Process.Data.Temp = rmfield(Process.Data.Temp,'FIR');
    
    %% Normalize class output to positive integer values
    
    Label = unique(Process.Data.Main.Information.class_output);
    
    for i = 1:length(Process.Data.Main.Information.class_output)
        for k = 1:length(Label)
            if Process.Data.Main.Information.class_output(i) == Label(k)
                Process.Data.Main.Information.class_output(i) = k;
                break;
            end
        end
    end
    
    %%  Saving EEG data
    display(strcat('  > Status: Saving data set < ', num2str(file),'>'));
    Save        =  Process.Data.Main;
    Process     = rmfield(Process,'Data');
    %   Save Data
    display(Process.File.Dataset{1,2}{1}{file});
    save(Process.File.Dataset{1,2}{1}{file},'-struct','Save','Signal','Information');
end

%%  Callback function
% Push button for marker selection
    function pushbutton_set_CallbackFcn(hObject, eventdata)
        % Get table data
        table.Data  = get(table.gui,'Data');
        % Update paramters
        segtime = str2num(table.Data{1,2});% 1s before simuli and 4s after stimuli
        fdown   = str2num(table.Data{2,2});% 256Hz
        passband   = str2num(table.Data{3,2});% Passband frequencies
        uiresume(gcbf);
        close(figure_inputs);
    end

end

