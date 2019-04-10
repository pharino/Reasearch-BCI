function varargout = Create_EEG_Structure(varargin)
% CREATE_EEG_STRUCTURE MATLAB code for Create_EEG_Structure.fig
%      CREATE_EEG_STRUCTURE, by itself, creates a new CREATE_EEG_STRUCTURE or raises the existing
%      singleton*.
%
%      H = CREATE_EEG_STRUCTURE returns the handle to a new CREATE_EEG_STRUCTURE or the handle to
%      the existing singleton*.
%
%      CREATE_EEG_STRUCTURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATE_EEG_STRUCTURE.M with the given input arguments.
%
%      CREATE_EEG_STRUCTURE('Property','Value',...) creates a new CREATE_EEG_STRUCTURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Create_EEG_Structure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Create_EEG_Structure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Create_EEG_Structure

% Last Modified by GUIDE v2.5 03-Jun-2012 17:16:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Create_EEG_Structure_OpeningFcn, ...
                   'gui_OutputFcn',  @Create_EEG_Structure_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Create_EEG_Structure is made visible.
function Create_EEG_Structure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Create_EEG_Structure (see VARARGIN)

% Choose default command line output for Create_EEG_Structure
handles.output = hObject;

create_menu(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Create_EEG_Structure wait for user response (see UIRESUME)
% uiwait(handles.figure_EEG_Structure);


% --- Outputs from this function are returned to the command line.
function varargout = Create_EEG_Structure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function create_menu(hObject, eventdata, handles) 
%   Copy handles 
handles = guidata(hObject);
%   File menu
handles.menu_file   = uimenu(...
    'Parent',gcf,...
    'HandleVisibility','callback',...
    'label','File');
handles.file_load   = uimenu(...
    'Parent',handles.menu_file,...
    'Label','Load EEG',...
    'HandleVisibility','callback', ...
    'Callback', @file_loadCallback);
handles.file_save   = uimenu(...
    'Parent',handles.menu_file,...
    'Label','Save data',...
    'HandleVisibility','callback', ...
    'Callback', @file_SaveCallback);
handles.file_exit   = uimenu(...
    'Parent',handles.menu_file,...
    'Label','Exit',...
    'HandleVisibility','callback', ...
    'Callback', @file_ExitCallback);
%   Process menu
handles.menu_process   = uimenu(...
    'Parent',gcf,...
    'HandleVisibility','callback',...
    'label','Process');
handles.file_load   = uimenu(...
    'Parent',handles.menu_process,...
    'Label','Create EEG structure',...
    'HandleVisibility','callback', ...
    'Callback', @file_create_structureCallback);

%   Save handles
guidata(hObject,handles);

function update_table_summary(hObject, eventdata, handles) 
%   Copy handles 
handles = guidata(hObject);
table   = {}

%   Save handles
guidata(hObject,handles);


% --- Executes on button press in checkbox_calib.
function checkbox_calib_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_calib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_calib


% --- Executes on button press in checkbox_eval.
function checkbox_eval_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_eval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_eval


% --- Executes on selection change in popupmenu_eeg_source.
function popupmenu_eeg_source_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_eeg_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_eeg_source contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_eeg_source


% --- Executes during object creation, after setting all properties.
function popupmenu_eeg_source_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_eeg_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_session.
function popupmenu_session_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_session contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_session


% --- Executes during object creation, after setting all properties.
function popupmenu_session_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
