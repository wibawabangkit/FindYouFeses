function varargout = FindYouFeses(varargin)
% FINDYOUFESES MATLAB code for FindYouFeses.fig
%      FINDYOUFESES, by itself, creates a new FINDYOUFESES or raises the existing
%      singleton*.
%
%      H = FINDYOUFESES returns the handle to a new FINDYOUFESES or the handle to
%      the existing singleton*.
%
%      FINDYOUFESES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINDYOUFESES.M with the given input arguments.
%
%      FINDYOUFESES('Property','Value',...) creates a new FINDYOUFESES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FindYouFeses_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FindYouFeses_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FindYouFeses

% Last Modified by GUIDE v2.5 20-Jun-2021 19:14:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FindYouFeses_OpeningFcn, ...
                   'gui_OutputFcn',  @FindYouFeses_OutputFcn, ...
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


% --- Executes just before FindYouFeses is made visible.
function FindYouFeses_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FindYouFeses (see VARARGIN)

% Choose default command line output for FindYouFeses
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FindYouFeses wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FindYouFeses_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.png';'*.jpeg';'*.jpg';'*.*'});
citra = imread([pathname, filename]);
axes(handles.axes4);
imshow(citra);

% membuat objek global
handles.citraInput = citra;
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%-----------------------------------------------------------------------
%ekstraksi RGB
citra = handles.citraInput;
R = citra (:,:,1);
G = citra (:,:,2);
B = citra (:,:,3);

%invers dari masing2 komponen
mR = 1/(mean(mean(R)));
mG = 1/(mean(mean(G)));
mB = 1/(mean(mean(B)));

%mencari nilai invers maksimal
maxRGB = max(max(mR, mG), mB);

%menghitung faktor skala
mR = mR/maxRGB;
mG = mG/maxRGB;
mB = mB/maxRGB;

%melakukan penskalaan nilai pixel
out = uint8(zeros(size(citra)));
out (:,:,1) = R*mR;
out (:,:,2) = G*mG;
out (:,:,3) = B*mB;

axes(handles.axes3);
imshow(out);

% membuat objek global
handles.citraInput = out;
guidata(hObject, handles);
%figure, imshow(out)


%-----------------------------------------------------------------------
%konversi citra RGB menjadi citra YCbCr
citra = handles.citraInput;
img_ycbcr = rgb2ycbcr (citra);
Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);

%-----------------------------------------------------------------------

%deteksi warna feses
[r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);

%ambil nilai pixel pada hasil deteksi (rekontruksi nilai pixel hasil
%deteksi
numind = size (r,1);
bin = false (size(citra,1), size(citra,2));
for i = 1:numind
    bin (r(i), c(i), v(i)) = 1;
end


axes(handles.axes1);
imshow(bin);

% membuat objek global
handles.citraInput = bin;
guidata(hObject, handles);
%figure, imshow(out)

%---------------------------------------------------------------------
bin = handles.citraInput;
%melakukan morfologi untuk menyeleksi hasil segmentasi dengan nilai
%trashhold
bin = imfill(bin, 'holes'); 
bin = bwareaopen(bin, 100);
%-----------------------------------------------------------------------

%menampilkan citra rgb hasil segmentasi
R (~bin) = 0;
G (~bin) = 0;
B (~bin) = 0;
RGB = cat(3, R,G,B);
axes(handles.axes2);
imshow(RGB);

% membuat objek global
handles.citraInput = RGB;
guidata(hObject, handles);


Red = sum (sum(R))/sum(sum(bin));
Green = sum (sum(G))/sum(sum(bin));
Blue = sum (sum(B))/sum(sum(bin));


ciri_uji = [Red,Green,Blue];
set(handles.edit1, 'string', num2str(Red));
set(handles.edit2, 'string', num2str(Green));
set(handles.edit3, 'string', num2str(Blue));
hasil = Red+Green+Blue;
if (hasil < 318.136)
    set(handles.edit5, 'string','Kesehatannya Normal');
    set(handles.text12, 'string','Jaga Terus Kesehatan Anak Anda ^_^');
elseif (hasil > 318.136 && hasil < 689.870)
    set(handles.edit5, 'string','Kesehatannya Tidak Normal');
    set(handles.text12, 'string','Segera Bawa Ke Puskesmas Terdekat');
else
    set(handles.edit5, 'string','Kesehatannya Tidak Dapat Diklasifikasi');
    set(handles.text12, 'string','Warna Feses Tidak Sesuai Klasifikasi');
end
handles.ciri_uji = ciri_uji;   
guidata(hObject, handles);



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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
cla reset
set(gca, 'XTick', [])
set(gca, 'YTick', [])
axes(handles.axes2)
cla reset
set(gca, 'XTick', [])
set(gca, 'YTick', [])
axes(handles.axes3)
cla reset
set(gca, 'XTick', [])
set(gca, 'YTick', [])
axes(handles.axes4)
cla reset
set(gca, 'XTick', [])
set(gca, 'YTick', [])
set(handles.edit1, 'string', [])
set(handles.edit2, 'string', [])
set(handles.edit3, 'string', [])
set(handles.edit5, 'string', [])
set(handles.text12, 'string', [])
