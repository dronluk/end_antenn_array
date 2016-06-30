function varargout = Interface(varargin)
% INTERFACE MATLAB code for Interface.fig
%      INTERFACE, by itself, creates a new INTERFACE or raises the existing
%      singleton*.
%
%      H = INTERFACE returns the handle to a new INTERFACE or the handle to
%      the existing singleton*.
%
%      INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE.M with the given input arguments.
%
%      INTERFACE('Property','Value',...) creates a new INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interface

% Last Modified by GUIDE v2.5 19-Jun-2016 17:58:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interface_OpeningFcn, ...
                   'gui_OutputFcn',  @Interface_OutputFcn, ...
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


% --- Executes just before Interface is made visible.
function Interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Interface (see VARARGIN)

% Choose default command line output for Interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
j=sqrt(-1);
step = 1000;%Кол.итераций
mu = 1/10000000000;%Шаг сходимости
Antenn=4;%кол.антенн
N = 1000; %длинна выборки
%k = 20; %количество отводов STAP
sv=1;%номер спутника для модели сигнала
%quant_jam=1; %количество помех
%number_jam=2;%1-Узкополосная 2-Широкополосная 3-ЛЧМ
az=get(handles.edit1,'String');
az=str2double(az);
zen=get(handles.edit2,'String');
zen=str2double(zen);
quant_jam=get(handles.edit3,'String');
quant_jam=str2double(quant_jam);%Количество помех
A=get(handles.edit4,'String');
A=str2double(A);%Амплитуда помехи
Imput_Signal=get(handles.popupmenu1,'Value');%Номер сигнала на входе
Number_Metod=get(handles.popupmenu2,'Value');%Номер метода подавления
number_jam=get(handles.popupmenu3,'Value');%%1-Узкополосная 2-Широкополосная 3-ЛЧМ
k=get(handles.edit5,'String');
k=str2double(k);%Количество задержек
switch Imput_Signal
    case 1%Модель сигнала
        data=Model_Signal(sv,quant_jam,number_jam,az,zen,A);
        for m=1:4
        data(:,m) = data(:,m) - mean(data(:,m));
        end
        data = data';
        clear data1 fileID;
        signal=data;%Без Гилберта
    case 2%Файл с помехой
        fileID = fopen('wide_75dBm_#2_4_5_gn32.txt');%чтение из файла
        data1 = textscan(fileID, '%10.1f   %10.1f   %10.1f   %10.1f', 3000000);
        fclose(fileID);
        data=cell2mat(data1);
        for m=1:4
        data(:,m) = data(:,m) - mean(data(:,m));
        end
        data = data';
        clear data1 fileID;
        signal=My_Hilbert_Filter(data,Antenn);%Гилберт
    case 3 %Файл без помехи
        path='';
        fileID = fopen([path 'no_jamm.txt']);
        data1 = textscan(fileID, '%10.1f   %10.1f   %10.1f   %10.1f', 1000000);
        fclose(fileID);
        data=cell2mat(data1);
        for m=1:4
        data(:,m) = data(:,m) - mean(data(:,m));
        end
        data = data';
        clear data1 fileID;
        signal=My_Hilbert_Filter(data,Antenn);%Гилберт      
end
 
        
% path='';

Inter=signal(:,1:N);
d=Inter(1,:);% Эталонный сигнал выборки
d2=signal(1,:);
%U=[];
%U(1,1:length(signal(1,:)))=signal(1,:);
%U(2:3,1:length(signal(1,:)))=signal(3:4,:);
U=signal(2:4,:);
%отводы(задержки)
U_tap =[];
for i=0:k
    U_tap = [U_tap; circshift(U',i)' ];
end;
%--------
Uinter = U_tap(:,1:N); % Периферийные антенны выборки
W=ones(length(Uinter(:,1)), 1);   %коэффицент

switch Number_Metod
    case 1
    [e,W,Y]=SMI_metod(d,Uinter);%SMI метод
     Y2=W'*U_tap;
     e2=d2-Y2; 
    case 2
    [e,W,Y,coef_filtr,SKO]=LMS_metod(d,Uinter,mu,step);%LMS метод
     Y2=W'*U_tap;
     e2=d2-Y2; 
    case 3
     [e,W,Y,coef_filtr,SKO]=RLS_metod(d,Uinter);%RLS метод
     Y2=W'*U_tap;
     e2=d2-Y2;
%     p=5;
%     lambda  = 0.99999; 
%      P0       = eye(p);     % inverse correlation matrix
%     ha = adaptfilt.rls(p,lambda,P0);
%     [y_,e2] = filter(ha,U(1,:),d2);
    case 4
     e2=signal(1,:);%Без адаптивного фильтра    
end
%   old_str=get(handles.listbox1,'String');
%   new_str = strvcat(old_str,'СКО до подавителя:');
%   set(handles.listbox1,'String',new_str);
%   old_str=get(handles.listbox1,'String');
%   new_str = strvcat(old_str,num2str(std(signal(1,:))));
%   set(handles.listbox1,'String',new_str);
%   old_str=get(handles.listbox1,'String');
%   new_str = strvcat(old_str,'СКО после:');
%   set(handles.listbox1,'String',new_str);
%   old_str=get(handles.listbox1,'String');
%   new_str = strvcat(old_str,num2str(std(e2)));
%   set(handles.listbox1,'String',new_str);
  
  old_str=get(handles.listbox1,'String');
  new_str = strvcat(old_str,'СКО до подавителя:',num2str(std(signal(1,:))),'СКО после:',num2str(std(e2)));
  set(handles.listbox1,'String',new_str);
 
  fprintf('СКО до подавителя: %f \n',std(signal(1,:)));
 fprintf('СКО после: %f \n',std(e2));

%set(handles.listbox1,'Value',std(signal(1,:)));
 [svnum,SNR]=Korrelator(e2,Imput_Signal,hObject, eventdata, handles);
 k=1; tmp_SNR=[];
 for i=1:length(SNR)
     if(SNR(i)>0)
         tmp_SNR(k)=SNR(i);
         k=k+1;
     end
 end
old_str=get(handles.listbox1,'String');
new_str = strvcat(old_str,'SV# ',num2str(svnum(:)'),'SNR:',num2str(tmp_SNR(:)'));
set(handles.listbox1,'String',new_str);
e2=e2';
save -ascii rezult.txt e2;

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
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
