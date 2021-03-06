function varargout = Newgui(varargin)
% NEWGUI M-file for Newgui.fig
%      NEWGUI, by itself, creates a new NEWGUI or raises the existing
%      singleton*.
%
%      H = NEWGUI returns the handle to a new NEWGUI or the handle to
%      the existing singleton*.
%
%      NEWGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWGUI.M with the given input arguments.
%
%      NEWGUI('Property','Value',...) creates a new NEWGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Newgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Newgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help Newgui
% Last Modified by GUIDE v2.5 26-Feb-2011 13:28:55
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Newgui_OpeningFcn, ...
                   'gui_OutputFcn',  @Newgui_OutputFcn, ...
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

% --- Executes just before Newgui is made visible.
function Newgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Newgui (see VARARGIN)
% Choose default command line output for Newgui
handles.output = hObject;
a = ones(256,256);
axes(handles.axes1);
imshow(a);
axes(handles.axes2);
imshow(a);
axes(handles.axes3);
imshow(a);
axes(handles.axes4);
imshow(a);

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes Newgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = Newgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in idwt.
function idwt_Callback(hObject, eventdata, handles)
% hObject    handle to idwt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%  LL3 = handles.LL3 ;
 res_image = handles.res_image ;
LH1 =  handles.LH;
 HL1 = handles.HL;
 HH1 = handles.HH;
 Enh_im = idwt2(res_image,LH1,HL1,HH1,'haar');
 axes(handles.axes4);
 imshow(Enh_im,[]);
 
% --- Executes on button press in svd.
function svd_Callback(hObject, eventdata, handles)
% hObject    handle to svd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 LL1 =  handles.LL1;
 LL = handles.LL;
 [U S V] = svd(LL);
 [U1 S1 V1] = svd(LL1);
 S11 = max(max(S));
 S12 = max(max(S1));
 Z = S12/S11;
 S3 = Z*S*255;
 LL3 = U*S3*V';
%  LL4 = histeq(LL3);
%  figure(32);imshow(LL4,[]); 
 h = waitbar(0,'Please wait...');
threshold = 20;

% --- Executes on button press in dwt.
function dwt_Callback(hObject, eventdata, handles)
% hObject    handle to dwt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
k=handles.k;
a1=handles.a1;
%a=imread(filename);
[LL LH HL HH]=dwt2(a1,'haar');
dec1=[...
        LL,LH;
    HL,HH...
    ];
%  figure;
axes(handles.axes3);
 imshow(uint8(dec1));title('First level decomposition for Input image');
 handles.dec1=dec1;
 handles.LL=LL;
 handles.LH=LH;
 handles.HL=HL;
 handles.HH=HH;
% % % % For enhnaced image 
 [LL1 LH1 HL1 HH1]=dwt2(k,'haar');
dec2=[...
        LL1,LH1;
    HL1,HH1...
    ];
%  figure;
axes(handles.axes4); 
imshow(uint8(dec2));title('First level decomposition for GHE image');
 handles.dec2=dec2;
 handles.LL1=LL1;
 handles.LH1=LH1;
 handles.HL1=HL1;
 handles.HH1=HH1; 
 guidata(hObject, handles);

% --- Executes on button press in GHe.
function GHe_Callback(hObject, eventdata, handles)
% hObject    handle to GHe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% % s2 = log(a1);
% % figure(22);imshow(s2,[]);
% 
% % % % % Adaptive histogram equaliztion
a1=handles.a;
[r c p]=size(a1);
if p==3;
    a1=rgb2gray(a1);
else
        %a=double(a);
end    
size_img = size(a1);
a2 = double(a1);
[u s v] = svd(a2);
% % svds(a1);
s_max = max(max(s));
N_max = max(max(a2));
equ_val = N_max/s_max;
S_new =equ_val*s*1.5;
ghe_im = u*S_new*v';
figure(22);
imshow(ghe_im,[]);
% % % % %Adaptive histogram equaliztion
global_res = histeq(a1);
res_image = a1;
threshold = 20;
h = waitbar(0,'Please wait...');

% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.jpg;*.png;*.bmp','pick an image file');%%%% To select file
if isequal(filename,0) | isequal(pathname,0)
    warndlg('user pressed cancel');
else
    a=imread(filename);
    a = imresize(a,[256 256]);
    axes(handles.axes1);
    imshow(a);
end
handles.a=a;
guidata(hObject, handles);