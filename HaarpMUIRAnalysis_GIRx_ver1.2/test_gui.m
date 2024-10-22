function varargout = test_gui(varargin)
%TEST_GUI M-file for test_gui.fig
%      TEST_GUI, by itself, creates a new TEST_GUI or raises the existing
%      singleton*.
%
%      H = TEST_GUI returns the handle to a new TEST_GUI or the handle to
%      the existing singleton*.
%
%      TEST_GUI('Property','Value',...) creates a new TEST_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to test_gui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      TEST_GUI('CALLBACK') and TEST_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in TEST_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_gui

% Last Modified by GUIDE v2.5 30-Jun-2009 23:35:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @test_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before test_gui is made visible.
function test_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for test_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% %% Pushbutton to confirm data directories
% 
% % --- Executes on button press in pushbutton_select_SRIRx.
% function pushbutton_select_SRIRx_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton_select_SRIRx (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% % --- Executes on button press in pushbutton_select_GIRx.
% function pushbutton_select_GIRx_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton_select_GIRx (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% % --- Executes on button press in pushbutton_select_save.
% function pushbutton_select_save_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton_select_save (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)


%% Editable text line for data directories

function edit_SRIRx_Callback(hObject, eventdata, handles)
% hObject    handle to edit_SRIRx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_SRIRx as text
%        str2double(get(hObject,'String')) returns contents of edit_SRIRx as a double
%      set(hObject, 'String', handles.dirChar_SRIRx);

% --- Executes during object creation, after setting all properties.
function edit_SRIRx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_SRIRx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_GIRx_Callback(hObject, eventdata, handles)
% hObject    handle to edit_GIRx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_GIRx as text
%        str2double(get(hObject,'String')) returns contents of edit_GIRx as a double
    

% --- Executes during object creation, after setting all properties.
function edit_GIRx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_GIRx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%     set(hObject, 'String', 'a')
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_save_Callback(hObject, eventdata, handles)
% hObject    handle to edit_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_save as text
%        str2double(get(hObject,'String')) returns contents of edit_save as a double


% --- Executes during object creation, after setting all properties.
function edit_save_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Pushbutton for directory select drop down menu

% --- Executes on button press in pushbutton_getdir_SRIRx.
function pushbutton_getdir_SRIRx_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_getdir_SRIRx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.dirChar_SRIRx = uigetdir;
    if ~handles.dirChar_SRIRx
        handles.dirChar_SRIRx = ['Enter directory for SRI reciever data'];
    end
    
    % Update handles structure
    guidata(hObject, handles);
    set(handles.edit_SRIRx, 'String', handles.dirChar_SRIRx);
    

% --- Executes on button press in pushbutton_getdir_GIRx.
function pushbutton_getdir_GIRx_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_getdir_GIRx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.dirChar_GIRx = uigetdir;
    
    if ~handles.dirChar_GIRx
        handles.dirChar_GIRx = ['Enter directory for GI reciever data'];
    end
    
    % Update handles structure
    guidata(hObject, handles);
    set(handles.edit_GIRx, 'String', handles.dirChar_GIRx);

% --- Executes on button press in pushbutton_getdir_save.
function pushbutton_getdir_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_getdir_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.dirChar_save = uigetdir;
    
    if ~handles.dirChar_save
        handles.dirChar_save = ['Enter directory to save plots'];
    end
    % Update handles structure
    guidata(hObject, handles);
    set(handles.edit_save, 'String', handles.dirChar_save);

%% Menu for file format
% --- Executes on selection change in popupmenu_fileformat.
function popupmenu_fileformat_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_fileformat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_fileformat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_fileformat


% --- Executes during object creation, after setting all properties.
function popupmenu_fileformat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_fileformat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    handles.figSaveExt;


%% Experiment and file numbers
% % --- Executes on selection change in popupmenu_expnum.
% function popupmenu_expnum_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu_expnum (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = get(hObject,'String') returns popupmenu_expnum contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu_expnum
% 
% 
% % --- Executes during object creation, after setting all properties.
% function popupmenu_expnum_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenu_expnum (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% % --- Executes on selection change in popupmenu_file_num.
% function popupmenu_file_num_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu_file_num (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = get(hObject,'String') returns popupmenu_file_num contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu_file_num
% 
% 
% % --- Executes during object creation, after setting all properties.
% function popupmenu_file_num_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenu_file_num (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


