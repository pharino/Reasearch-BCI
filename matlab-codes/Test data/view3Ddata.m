function varargout = view3Ddata(varargin)
% VIEW3DDATA MATLAB code for view3Ddata.fig
%      VIEW3DDATA, by itself, creates a new VIEW3DDATA or raises the existing
%      singleton*.
%
%      H = VIEW3DDATA returns the handle to a new VIEW3DDATA or the handle to
%      the existing singleton*.
%
%      VIEW3DDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEW3DDATA.M with the given input arguments.
%
%      VIEW3DDATA('Property','Value',...) creates a new VIEW3DDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before view3Ddata_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to view3Ddata_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help view3Ddata

% Last Modified by GUIDE v2.5 07-Jun-2012 15:30:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @view3Ddata_OpeningFcn, ...
                   'gui_OutputFcn',  @view3Ddata_OutputFcn, ...
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


%% Init
function view3Ddata_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for view3Ddata
handles.output = hObject;

% Initalize some counters
handles.flags.dataloaded = 0;
handles.flags.dragging = 0;
handles.xslicenum = 1;
handles.yslicenum = 1;
handles.zslicenum = 1;
handles.scrollax = 1;
handles.amin = 1;
handles.amax = 256;
handles.alphavec = linspace(0,1,256);

% Update handles structure
guidata(hObject, handles);

%% Output (unused)
function varargout = view3Ddata_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%% Load Routine
function push_load_Callback(hObject, eventdata, handles)
% Load up a .mat file with pre-defined variable names;
%  matrix = 3D matrix (real values) for plotting.
%  nscale = scale (vector) for axis n.
%  nname = name (string) for axis n.
[FileName,PathName,FilterIndex] = uigetfile('*.mat','SelectFiles','MultiSelect','Off');
% Checks done in this order!!
if ~iscell(FileName) && (length(FileName) == 1) && (FileName == 0) % User canceled
    return;
else
    load([PathName,FileName]);
end
% Store our shiny new data
handles.matrix = matrix;
handles.xsca = xsca;
handles.ysca = ysca;
handles.zsca = zsca;
handles.nxpt = length(xsca);
handles.nypt = length(ysca);
handles.nzpt = length(zsca);
handles.xname = xname;
handles.yname = yname;
handles.zname = zname;
handles.cmin = min(reshape(matrix,1,numel(matrix)));
handles.cmax = max(reshape(matrix,1,numel(matrix)));
handles.flags.dataloaded = 1;

% Set slider steps
set(handles.slider_xy,'SliderStep',[1/handles.nzpt,0.1]);
set(handles.slider_xz,'SliderStep',[1/handles.nypt,0.1]);
set(handles.slider_yz,'SliderStep',[1/handles.nxpt,0.1]);

% Reset flags
handles.flags.dragging = 0;
handles.xslicenum = 1;
handles.yslicenum = 1;
handles.zslicenum = 1;

% Update plots
cla(handles.axes_3d);
cla(handles.axes_alphamap);
cla(handles.axes_xy_slice);
cla(handles.axes_xz_slice);
cla(handles.axes_yz_slice);
% Update the alphamap
updateAlphaview(handles);
% Make the 3D plot
view(handles.axes_3d,3);
update3Dview(handles);
% And update the 2D plots
update2Dview(handles);

% Update handles structure
guidata(hObject, handles);

%% Update plot functions
%% -- updateAlphaview
function updateAlphaview(handles)
cla(handles.axes_alphamap);
% Remake the alphavec vector
alphavec = zeros(1,256);
slopeind = handles.amin:handles.amax;
alphavec(slopeind) = linspace(0,1,numel(slopeind));
alphavec(handles.amax:end) = 1;
handles.alphavec = alphavec;

% Take the histogram and plot it, overlay the
values = reshape(handles.matrix,1,numel(handles.matrix));
hold(handles.axes_alphamap,'on');
hist(handles.axes_alphamap,values,256);
[hN,hX] = hist(handles.axes_alphamap,values,256);
xplot = linspace(min(values),max(values),256);
plot(handles.axes_alphamap,xplot,handles.alphavec*max(hN),'LineWidth',2);
axis(handles.axes_alphamap,'tight');
% Draw the bars for the low and high cutoffs
[xaxsize] = get(handles.axes_alphamap,'xlim');
[yaxsize] = get(handles.axes_alphamap,'ylim');
plot(handles.axes_alphamap,[1,1]*handles.amin/256*xaxsize(2)+xaxsize(1),yaxsize,'r','LineWidth',2)
plot(handles.axes_alphamap,[1,1]*handles.amax/256*xaxsize(2)+xaxsize(1),yaxsize,'g','LineWidth',2)
% Label everything
xlabel(handles.axes_alphamap,'Intensity');
ylabel(handles.axes_alphamap,'Counts');
title(handles.axes_alphamap,sprintf('Alpha Map (%2.2e : %2.2e)',hX(handles.amin),hX(handles.amax)));

%% -- update3Dview
function update3Dview(handles)
plotMatrixAlpha(handles.axes_3d,handles.matrix,handles.alphavec,handles.xsca,handles.ysca,handles.zsca);
colormap hot;
xlabel(handles.axes_3d,handles.xname);
ylabel(handles.axes_3d,handles.yname);
zlabel(handles.axes_3d,handles.zname);
colorbar('peer',handles.axes_3d);

%% -- update2Dview
function update2Dview(handles)
useglobalmm = get(handles.check_globalmaxmin,'Value');

axes(handles.axes_xy_slice);
imagesc(handles.xsca,handles.ysca,squeeze(handles.matrix(:,:,handles.zslicenum))');
if useglobalmm
    caxis([handles.cmin,handles.cmax]);
end
xlabel(handles.axes_xy_slice,handles.xname);
ylabel(handles.axes_xy_slice,handles.yname);
title(handles.axes_xy_slice,sprintf('XY Image (Z = %d, %2.2f)',...
    handles.zslicenum,handles.zsca(handles.zslicenum)));

axes(handles.axes_xz_slice);
imagesc(handles.xsca,handles.zsca,squeeze(handles.matrix(:,handles.yslicenum,:))');
if useglobalmm
    caxis([handles.cmin,handles.cmax]);
end
xlabel(handles.axes_xz_slice,handles.xname);
ylabel(handles.axes_xz_slice,handles.zname);
title(handles.axes_xz_slice,sprintf('XZ Image (Y = %d, %2.2f)',...
    handles.yslicenum,handles.ysca(handles.yslicenum)));

axes(handles.axes_yz_slice);
imagesc(handles.ysca,handles.zsca,squeeze(handles.matrix(handles.xslicenum,:,:))');
if useglobalmm
    caxis([handles.cmin,handles.cmax]);
end
xlabel(handles.axes_yz_slice,handles.yname);
ylabel(handles.axes_yz_slice,handles.zname);
title(handles.axes_yz_slice,sprintf('YZ Image (X = %d, %2.2f)',...
    handles.xslicenum,handles.xsca(handles.xslicenum)));


%% Mouse Scroll
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% Get which axis the click occured in
% And perform the requisite function

%fprintf('%s\n',get(get(hObject,'CurrentAxes'),'Tag'));
switch get(get(hObject,'CurrentAxes'),'Tag')
    otherwise
        % If the tag is empty, check the children
        get(get(get(hObject,'CurrentAxes'),'Children'),'Tag')
        switch get(get(get(hObject,'CurrentAxes'),'Children'),'Tag');
            case 'axes_xy_image'
                fprintf('xy-image wheel\n');
            case 'axes_xz_image'
                fprintf('xy-image wheel\n');
            case 'axes_yz_image'
                fprintf('xy-image wheel\n');
            otherwise
        end
end

%% Mouse Click / Drag
%% --ButtonDown
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
if handles.flags.dataloaded
    switch get(get(hObject,'CurrentAxes'),'Tag')
        case 'axes_alphamap'
            clickpts = get(get(hObject,'CurrentAxes'),'CurrentPoint');
            [xaxsize] = get(handles.axes_alphamap,'xlim');
            cindex = round(256*(clickpts(1,1)-xaxsize(1))/xaxsize(2));
            
            if abs(cindex-handles.amin) < abs(cindex-handles.amax)
                handles.amin = cindex;
                handles.flags.dragging = 1;
            else
                handles.amax = cindex;
                handles.flags.dragging = 2;
            end
            
            % Update handles
            guidata(hObject, handles);
            % And update the plot
            updateAlphaview(handles);
    end
    % Update handles structure
    guidata(hObject, handles);
end

%% --ButtonMotion
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% Drag the active bar around if availble
if handles.flags.dragging ~= 0
    clickpts = get(get(hObject,'CurrentAxes'),'CurrentPoint');
    [xaxsize] = get(handles.axes_alphamap,'xlim');
    cindex = round(256*(clickpts(1,1)-xaxsize(1))/xaxsize(2));
    if handles.flags.dragging == 1
        if handles.amin > 1
            handles.amin = cindex;
        else
            handles.amin = 1;
        end
    elseif handles.flags.dragging == 2
        if handles.amax < 256;
            handles.amax = cindex;
        else
            handles.amax = 256;
        end
    end
    
    % Update handles structure
    guidata(hObject, handles);
    % Update the alphamap
    updateAlphaview(handles);
end

%% -- ButtonUp
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
if handles.flags.dataloaded
    % Discard any flags telling use we're active
    if handles.flags.dragging ~=0
        handles.flags.dragging = 0;
        % and update the 3D view
        update3Dview(handles);
    end
    % Update handles structure
    guidata(hObject, handles);
end

%% Slider Callbacks
%% -- Slider xy
function slider_xy_Callback(hObject, eventdata, handles)
handles.zslicenum = round(get(handles.slider_xy,'value')*handles.nzpt);
% Update handles structure
guidata(hObject, handles);
% Update the 2D plot
update2Dview(handles);

%% -- Slider xz
function slider_xz_Callback(hObject, eventdata, handles)
handles.yslicenum = round(get(handles.slider_xz,'value')*handles.nypt);
% Update handles structure
guidata(hObject, handles);
% Update the 2D plot
update2Dview(handles);

%% -- Slider yz
function slider_yz_Callback(hObject, eventdata, handles)
handles.xslicenum = round(get(handles.slider_yz,'value')*handles.nxpt);
% Update handles structure
guidata(hObject, handles);
% Update the 2D plot
update2Dview(handles);

%% 2D Plot Options
%% -- Use Global Max/Min
function check_globalmaxmin_Callback(hObject, eventdata, handles)
% Update handles structure
guidata(hObject, handles);
% Update the 2D plot
update2Dview(handles);

%% -- Analyze Data
function push_analyze_Callback(hObject, eventdata, handles)
% Prototype analyze function goes here
% xyimage = squeeze(handles.matrix(:,:,handles.zslicenum))';
% xzimage = squeeze(handles.matrix(:,handles.zslicenum,:))';
% yzimage = squeeze(handles.matrix(handles.zslicenum,:,:))';
% analyze(xyimage,xzimage,yzimage,handles.xsca,handles.ysca,handles.zsca);


%% Unused Autogenerated Code
function slider_xy_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider_xz_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider_yz_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


