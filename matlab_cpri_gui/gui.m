function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 04-Dec-2015 22:18:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function showstr_Callback(hObject, eventdata, handles)
% hObject    handle to showstr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of showstr as text
%        str2double(get(hObject,'String')) returns contents of showstr as a double


% --- Executes during object creation, after setting all properties.
function showstr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to showstr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in open.
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*','打开文件');
if filename ~= 0
    set(handles.showstr,'string',[pathname filename])
    handles.file = [pathname filename];
end
guidata(hObject,handles);
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over open.
function open_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in loadBtn.
function loadBtn_Callback(hObject, eventdata, handles)
% hObject    handle to loadBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cpri_rate = get(handles.cpriRate,'value')
asicOrFpga = get(handles.asicOrFpga,'value');

iq_jiaozhi = get(handles.iqJiaozhi,'value');
iq_jiaohuan = get(handles.iqChange,'value');
startbit = get(handles.startBitInputBox,'string')
fid = fopen(handles.file);
data = uint64(fscanf(fid,'%x'));
cpriRate2ChipBitWidth = [ 1 2 4 6 8 10 16];
cpriBitWidthPerFrame = cpriRate2ChipBitWidth(cpri_rate);

if asicOrFpga == 1  %如果是芯片
    cpriChipNumInPerCpriBasicFrame = 128;
else                %如果是fpga
    cpriChipNumInPerCpriBasicFrame = 32;
    cpriBitWidthPerFrame = cpriBitWidthPerFrame*4;
end
 
%从cpri基本帧开始的数据，两行表示一个chip的数据
cpriDataFromFrameStart = data;
%将两行的数据转为一行，用u64标示,代表一个chip的数据,同样cpri速率下fpga数据是asic数据的4倍长
cpriChipDataInRowRaw = bitshift(cpriDataFromFrameStart(2:2:end,1),32) + cpriDataFromFrameStart(1:2:end,1);
%{
此步数据一行为两个u32,代表一个chip，只有在大速率下才会用第一个u32，第二个u32表示低位
0000000000000001     #chip0
0000000000000002     #chip1
0000000000000003     #chip2
...
%}
%将采集的数据按128chip或32chip取整，即转化为正基本帧个chip数
cpriChipNum = length(cpriChipDataInRowRaw);
cpriChipNum = cpriChipNum - mod(cpriChipNum, cpriChipNumInPerCpriBasicFrame);
cpriChipDataInRow = cpriChipDataInRowRaw(1:cpriChipNum);
%将数据转换为一行为一个基本帧，对芯片来说128个chip一个基本帧，对fpga来说32个chip一个基本帧
cpriBasicFrameDataInRow = reshape(cpriChipDataInRow, cpriChipNumInPerCpriBasicFrame, cpriChipNum/cpriChipNumInPerCpriBasicFrame)'
%{
此步数据一行代有一frame,
0000000000000001   0000000000000002   0000000000000003     ...  0000000000000080 #frame0
0000000000000001   0000000000000002   0000000000000003     ...  0000000000000080 #frame1
0000000000000001   0000000000000002   0000000000000003     ...  0000000000000080 #frame2
...
%}


function data = getAxc(cpriFrame,startbit,bitlen,cpriBitWidthPerFrame)
    startChip       = startbit/cpriBitWidthPerFrame;
    firstBitsInChip = mod(startbit,cpriBitWidthPerFrame);
    startBitInChip  = firstBitsInChip - 1;
    middleChipNum   = (startbit - (startBitInChip+1))/cpriBitWidthPerFrame;
    lastChip        = startChip + middleChipNum + 1;
    lastBitsInChip  = mod((startbit - (startBitInChip+1)),cpriBitWidthPerFrame);

    firstBitM = bitshift(cpriFrame(:,startChip),-int32(firstBitsInChip));
    middleBitM = cpriFrame(:,startChip+1:startChip+middleChipNum);
    lastBitM = bitand(cpriFrame(:,lastChip),bitshift(uint32(1),lastBitsInChip)-uint32(1));
    axc = [firstBitM middleBitM lastBitM]
    [row col] = size(axc);
    data = uint32(zeros(row,col));
    for i = 1:col
       data = bitor(data,bitshift(axc(:,i), firstBitsInChip*(i>1)+cpriBitWidthPerFrame*(i-1)));
    end
 


   

% --- Executes on button press in iqJiaozhi.
function iqJiaozhi_Callback(hObject, eventdata, handles)
% hObject    handle to iqJiaozhi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of iqJiaozhi


% --- Executes on button press in iqChange.
function iqChange_Callback(hObject, eventdata, handles)
% hObject    handle to iqChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of iqChange


% --- Executes on selection change in cpriRate.
function cpriRate_Callback(hObject, eventdata, handles)
% hObject    handle to cpriRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cpriRate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cpriRate

% --- Executes during object creation, after setting all properties.
function cpriRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cpriRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in asicOrFpga.
function asicOrFpga_Callback(hObject, eventdata, handles)
 

% hObject    handle to asicOrFpga (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns asicOrFpga contents as cell array
%        contents{get(hObject,'Value')} returns selected item from asicOrFpga


% --- Executes during object creation, after setting all properties.
function asicOrFpga_CreateFcn(hObject, eventdata, handles)
% hObject    handle to asicOrFpga (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in axcNum.
function axcNum_Callback(hObject, eventdata, handles)
% hObject    handle to axcNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns axcNum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from axcNum


% --- Executes during object creation, after setting all properties.
function axcNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axcNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startBitInputBox_Callback(hObject, eventdata, handles)
% hObject    handle to startBitInputBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startBitInputBox as text
%        str2double(get(hObject,'String')) returns contents of startBitInputBox as a double


% --- Executes during object creation, after setting all properties.
function startBitInputBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startBitInputBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function axcWidthInputBox_Callback(hObject, eventdata, handles)
% hObject    handle to axcWidthInputBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of axcWidthInputBox as text
%        str2double(get(hObject,'String')) returns contents of axcWidthInputBox as a double


% --- Executes during object creation, after setting all properties.
function axcWidthInputBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axcWidthInputBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in psdBtn.
function psdBtn_Callback(hObject, eventdata, handles)
% hObject    handle to psdBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
