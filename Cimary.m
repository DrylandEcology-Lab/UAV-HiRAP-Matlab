function varargout = Cimary(varargin)
% CIMARY MATLAB code for Cimary.fig
%      CIMARY, by itself, creates a new CIMARY or raises the existing
%      singleton*.
%
%      H = CIMARY returns the handle to a new CIMARY or the handle to
%      the existing singleton*.
%
%      CIMARY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CIMARY.M with the given input arguments.
%
%      CIMARY('Property','Value',...) creates a new CIMARY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Cimary_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Cimary_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Cimary

% Last Modified by GUIDE v2.5 16-Jun-2016 13:27:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Cimary_OpeningFcn, ...
    'gui_OutputFcn',  @Cimary_OutputFcn, ...
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


% --- Executes just before Cimary is made visible.
function Cimary_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Cimary (see VARARGIN)

% Choose default command line output for Cimary
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Cimary wait for user response (see UIRESUME)
% uiwait(handles.Cimary);

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.

%------------------------�������ķ�Ӧ-----------------------------
function Cimary_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Cimary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global List
%======����û������ֶ�ѡ�㹦��======
if strcmp(get(handles.PicCtrlPan,'visible'),'on')
    %===����û�����ˡ�ӥ�۷Ŵ�===
    if get(handles.EagleEye,'value')==1
        %��ȡԤ�����ı߽�
        XLim=get(handles.axes1,'XLim');
        YLim=get(handles.axes1,'YLim');
        pos=get(handles.axes1,'currentpoint');%����������λ��
        %------����������λ��λ��Ԥ�����֮��------
        if (pos(1,1)>XLim(1)) && (pos(1,1)<XLim(2)) && (pos(1,2)>YLim(1)) && (pos(1,2)<YLim(2))
            if strcmp(get(gcf,'selectiontype'),'normal')%����ǵ���
                par=get(handles.ParListBox,'value');
                %���Ŀǰѡ����Сͼ����
                if List{par,3}==1
                    pos=get(handles.axes1,'currentpoint');
                    setappdata(hObject,'isPressed',true);%���ݸ�������ƶ����������û��������������ʼ�Ŵ�
                    set(hObject,'Userdata',pos(1,[1,2]));%���������ʼ������
                %���ѡ���˴�ͼ����
                else
                    setappdata(hObject,'isPressed',true);%���ݸ�������ƶ����������û��������������ʼ�Ŵ�
                end
            end
        end
    end
    %======��ȡ��ͼ���ı߽�����λ��======
    XLim2=get(handles.axes2,'XLim');
    YLim2=get(handles.axes2,'YLim');
    pos2=get(handles.axes2,'currentpoint');
    %======�������ڻ�ͼ���֮��======
    if (pos2(1,1)>XLim2(1)) && (pos2(1,1)<XLim2(2)) && (pos2(1,2)>YLim2(1)) && (pos2(1,2)<YLim2(2))
        %------����û�˫����꣬��������еĹ켣------
        if strcmp(get(gcf,'selectiontype'),'open')
            delete(findobj('type','line','parent',handles.axes2))
            set(handles.Confirm,'enable','off')
        else
            set(handles.text1,'Userdata',1)%���ݸ�������ƶ����������û���ʼ������
            set(handles.axes2,'Userdata',pos2(1,[1,2]))
        end
    end
end

% --- Executes on mouse motion over figure - except title and menu.

%--------------------------����ƶ��ķ�Ӧ-------------------------------
function Cimary_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to Cimary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename Pathname List picpos f
%======����û������ֶ�ѡ�㹦��======
if strcmp(get(handles.PicCtrlPan,'visible'),'on')
    %===����û�����ˡ�ӥ�۷Ŵ�===
    if get(handles.EagleEye,'value')==1
        %------��������Ԥ�������------
        XLim=get(handles.axes1,'XLim');
        YLim=get(handles.axes1,'YLim');
        pos=get(handles.axes1,'currentpoint');
        if (pos(1,1)>XLim(1)) && (pos(1,1)<XLim(2)) && (pos(1,2)>YLim(1)) && (pos(1,2)<YLim(2))
            load([Pathname Filename],'PicListBox*')
            par=get(handles.ParListBox,'value');
            %------���Ԥ�������Сͼ���飨��������Ŵ�------
            if List{par,3}==1
                set(handles.Cimary,'pointer','cross')
                isPressed=getappdata(hObject,'isPressed');
                if isPressed%����û�֮ǰ�Ѿ����������
                    delete(findobj('type','line','parent',handles.axes1))
                    pos=get(handles.axes1,'currentpoint');
                    pos1=get(hObject,'Userdata');
                    x0=pos1(1,1);y0=pos1(1,2);x1=pos(1,1);y1=pos(1,2);
                    Xi=min(x0,x1);Xa=max(x0,x1);Yi=min(y0,y1);Ya=max(y0,y1);
                    x=[Xi,Xa,Xa,Xi,Xi];
                    y=[Yi,Yi,Ya,Ya,Yi];
                    hold on
                    plot(x,y,'r','linewidth',4)%���ƾ���
                    hold off
                    set(handles.axes2,'Userdata',[Xi,Yi,Xa,Ya])%���ݾ��ζ�������
                end
            %------���Ԥ������Ǵ�ͼ���飨����������Ŵ󣬰��кõ�Сͼ�Ŵ���ʾ������------    
            else
                set(handles.Cimary,'pointer','hand')%�������״Ϊ���ͣ������������Сͼ�ľ�������
                isPressed=getappdata(hObject,'isPressed');
                if isPressed
                    a=(picpos(:,1)<pos(1,1));
                    b=(picpos(:,2)>pos(1,1));
                    c=(picpos(:,3)<pos(1,2));
                    d=(picpos(:,4)>pos(1,2));
                    e=a.*b.*c.*d;
                    f=find(e==1);
                    matrix_pos=picpos(f,:);
                    y=[matrix_pos(1,3),matrix_pos(1,4),matrix_pos(1,4),matrix_pos(1,3),matrix_pos(1,3)];
                    x=[matrix_pos(1,2),matrix_pos(1,2),matrix_pos(1,1),matrix_pos(1,1),matrix_pos(1,2)];
                    delete(findobj('type','line','parent',handles.axes1))
                    hold on
                    plot(x,y,'r','linewidth',4)
                    hold off
                    set(handles.axes2,'Userdata',matrix_pos)
                end
            end
        %======�����겻��Ԥ������ϣ���ôָ��ͱ��Ĭ��======    
        else
            set(handles.Cimary,'pointer','default')
        end
    end
    XLim2=get(handles.axes2,'XLim');
    YLim2=get(handles.axes2,'YLim');
    pos_now=get(handles.axes2,'currentpoint');
    %======�������ڻ�ͼ�����======
    if (pos_now(1,1)>XLim2(1)) && (pos_now(1,1)<XLim2(2)) && (pos_now(1,2)>YLim2(1)) && (pos_now(1,2)<YLim2(2))
        pos_mouse0=get(handles.axes2,'Userdata');
        isPressed=get(handles.text1,'Userdata');
        %------���֮ǰ�а������------
        if isPressed==1
            if strcmp(get(gcf,'selectiontype'),'normal')
                color='g';%�������ɫ
            end
            if strcmp(get(gcf,'selectiontype'),'alt')
                color='b';%�Ҽ�����ɫ
            end
            line([pos_mouse0(1);pos_now(1,1)],[pos_mouse0(2),pos_now(1,2)],'linewidth',3,'color',color)
            set(handles.axes2,'Userdata',pos_now(1,[1,2]))
            blue_0=findobj('type','line','parent',handles.axes2,'-and','Color','blue','parent',handles.axes2);
            green_1=findobj('type','line','parent',handles.axes2,'-and','Color','green','parent',handles.axes2);
            size0=size(blue_0,1);
            size1=size(green_1,1);
            %�����ɫ��ɫ��ī�����У���ô�ͼ���ѡȡȷ�ϰ�ť
            if size0*size1>0
                set(handles.Confirm,'enable','on')
            end
        end
    end
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.

%--------------------------���̧��ķ�Ӧ--------------------------------
function Cimary_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to Cimary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List axes2pic f
if strcmp(get(handles.PicCtrlPan,'visible'),'on')
    if get(handles.EagleEye,'value')==1
        XLim=get(handles.axes1,'XLim');
        YLim=get(handles.axes1,'YLim');
        pos=get(handles.axes1,'currentpoint');
        if (pos(1,1)>XLim(1)) && (pos(1,1)<XLim(2)) && (pos(1,2)>YLim(1)) && (pos(1,2)<YLim(2))
            setappdata(hObject,'isPressed',false)
            B=get(handles.axes2,'Userdata');
            if ~isempty(B)
                B=floor(B);
                load([Pathname Filename])
                par=get(handles.ParListBox,'value');
                pic=get(handles.PicListBox,'value');
                set(handles.ZoomIn,'enable','on')
                if List{par,3}==1
                    eval(['temp=' List{par,2} ';'])
                    pathname=temp{pic,2};
                    filename=temp{pic,1};
                    img=imread([pathname filename]);
                    axes2pic=img(B(2):B(4),B(1):B(3),1:3);
                    axes(handles.axes2)
                    imshow(axes2pic)
                else
                    eval(['temp=' List{par,2} ';'])
                    pathname=temp{f+1,2};
                    filename=temp{f+1,1};
                    axes2pic=imread([pathname filename]);
                    axes(handles.axes2)
                    imshow(axes2pic)
                end
            end
        end
    end
    XLim2=get(handles.axes2,'XLim');
    YLim2=get(handles.axes2,'YLim');
    pos_now=get(handles.axes2,'currentpoint');
    if (pos_now(1,1)>XLim2(1)) && (pos_now(1,1)<XLim2(2)) && (pos_now(1,2)>YLim2(1)) && (pos_now(1,2)<YLim2(2))
        set(handles.text1,'Userdata',0)
    end
end

% --- Executes when user attempts to close Cimary.
function Cimary_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Cimary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: deletepar(hObject) closes the figure
if exist('C:\Logs\CAFLang.mat','file')
    button=questdlg('Are you sure you want to quit��','Exit','Yes','No','Yes');
    if strcmp(button,'Yes')
        delete(hObject);
    end;
else
    button=questdlg('��ȷ���˳���','�˳�����','ȷ��','ȡ��','ȷ��');
    if strcmp(button,'ȷ��')
        delete(hObject);
    end;
end


% --- Outputs from this function are returned to the command line.
function varargout = Cimary_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame')
javaFrame=get(hObject,'JavaFrame'); %warning on
set(javaFrame,'Maximized',1)
if ~exist('C:\Logs','dir')
    mkdir('C:\Logs');
end
if exist('C:\Logs\CAFLang.mat','file')
    English_Callback(hObject, eventdata, handles)
end
set(javaFrame,'FigureIcon',javax.swing.ImageIcon('.\�ֿ�ԺԺ��.png'))

% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%-----------------------------�½���Ŀ--------------------------------
function FileNew_Callback(hObject, eventdata, handles)
% hObject    handle to FileNew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename Pathname List
if exist('C:\Logs\CAFLang.mat','file')%�����л�
    [filename,pathname]=uiputfile('CAF.mat','Please select the project folder and project name');
else
    [filename,pathname]=uiputfile('CAF.mat','��ѡ����Ŀ����ļ��м���Ŀ��');
end
if ~isnumeric(filename)%�����������ȷ���ļ�����·��
    Filename=filename;
    Pathname=pathname;
    Howcanoe='I Love Cimary';
    PicListNum=1;
    List=cell(1,4);
    List{1,4}=NewParStruct;
    save([Pathname Filename],'Filename','Pathname','Howcanoe','List','PicListNum')
    %������һ���İ�ť���ļ�
    set(handles.Cimary,'Name',Filename(1:end-4))
    set(handles.ParListBox,'string',{''})
    set(handles.PicListBox,'string',{''})
    set(handles.ParListBox,'value',1)
    set(handles.PicListBox,'value',1)
    set(handles.PicListBox,'visible','on')
    cla(handles.axes1)
    cla(handles.axes2)
    OnOff%����
    path=[Pathname Filename(1:end-4) '.proj'];
    h1=findobj(handles.axes3,'visible','off');
    set(h1,'visible','on');
    mywaitbar(0,'Please Wait...',handles.axes3,handles.Cimary);
    pause(0.1)
    mywaitbar(0.5,'Please Wait...',handles.axes3,handles.Cimary);
    pause(0.1)
    mywaitbar(1,'Please Wait...',handles.axes3,handles.Cimary);
    if exist(path,'dir')~=0
        cmd_rmdir_long
    end
    mkdir(path);
end


% ---------------------------����Ŀ------------------------------
function FileOpen_Callback(hObject, eventdata, handles)
% hObject    handle to FileOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename Pathname List
if exist('C:\Logs\CAFLang.mat','file')%�����л�
    [filename,pathname]=uigetfile('*.mat','Please select the project file');
else
    [filename,pathname]=uigetfile('*.mat','��ѡ����Ŀ�ļ�');
end
if ~isnumeric(filename)%���·����ȷ
    Filename=filename;
    Pathname=pathname;
    load([Pathname Filename])
    if exist('Howcanoe','var') && strcmp(Howcanoe,'I Love Cimary')%�����cimary��Ŀ�ļ�
        if exist([Pathname Filename(1:end-4) '.proj'],'dir')
            h1=findobj(handles.axes3,'visible','off');
            set(h1,'visible','on');
            mywaitbar(0,'Please Wait...',handles.axes3,handles.Cimary);
            set(handles.Cimary,'name',Filename(1:end-4))
            set(handles.ParListBox,'value',1)
            set(handles.ParListBox,'value',1)
            if isempty(List{1,1})%��ԭĬ��
                set(handles.ParListBox,'string',{''})
                set(handles.PicListBox,'string',{''})
                set(handles.ParListBox,'value',1)
                set(handles.PicListBox,'value',1)
            else
                set(handles.ParListBox,'string',List(:,1))
                mywaitbar(0.5,'Please Wait...',handles.axes3,handles.Cimary);
                if isempty(List{1,2})
                    set(handles.PicListBox,'string',{''})
                else
                    eval(['set(handles.PicListBox,''string'',' List{1,2} '(:,1))'])
                    if eval(['~isempty(' List{1,2} '{1,2})'])
                        eval(['preview=imread([' List{1,2} '{1,2} ' List{1,2} '{1,1}]);'])
                        imshow(preview,'Parent',handles.axes1);
                        axes(handles.axes1)
                        axis off
                    end
                end
            end
            OnOff
            ParListBox_Callback(hObject, eventdata, handles)
        else
            if exist('C:\Logs\CAFLang.mat','file')
                warndlg('.proj is corrupted or does not exist, can not load data')
            else
                warndlg('.proj��Ŀ�����𻵻򲻴��ڣ��޷���������')
            end
        end
        mywaitbar(1,'Please Wait...',handles.axes3,handles.Cimary);
        if exist('C:\Logs\CAFLang.mat','file')
            set(handles.WaitBarPan,'title','Done')
        else
            set(handles.WaitBarPan,'title','�����')
        end
    else
        if exist('C:\Logs\CAFLang.mat','file')
            warndlg('Non-project file��','Warning')
        else
            warndlg('����Ŀ�ļ���','����')
        end
    end
end

% --------------------------------------------------------------------
function Pic_Callback(hObject, eventdata, handles)
% hObject    handle to Pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% -----------------------------���ͼ��-----------------------------
function PicRead_Callback(hObject, eventdata, handles)
% hObject    handle to PicRead (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ��name��Ϊ���и�ͼƬ��������slice��Ϊ�и�ͼƬ����
global Filename Pathname List Text
if exist('C:\Logs\CAFLang.mat','file')%�����л�
    [Text.f3,Text.p3]=uigetfile({'*.tif;*.png;*.jpg;*.tiff'},'Please select a picture to classifing.','multiselect','on');
else
    [Text.f3,Text.p3]=uigetfile({'*.tif;*.png;*.jpg;*.tiff'},'��ѡȡҪ�����ͼƬ','multiselect','on');
end
if ~isnumeric(Text.p3)%���·����ȷ
    load([Pathname Filename],'PicList*')
    set(handles.WaitBarPan,'title','ͼƬ������')
    par=get(handles.ParListBox,'value');
    %======���һ��ѡȡ�˶���ͼƬ======
    if iscell(Text.f3)%Text.fΪͼƬ���ļ��������ѡ���Ƕ�ѡ����ô���ĸ�ʽ��cell������ǵ�ѡ�����ĸ�ʽ����char
        S=size(Text.f3,2);
        info=cell(S,1);
        msg=zeros(S,1);
        for i=1:S
            info{i,1}= imfinfo([Text.p3 Text.f3{1,i}]);
            %���ͼƬ������ѹ����ͼƬ��ǳ���
            if info{i,1}.Height*info{i,1}.Width>4000000 || info{i,1}.FileSize>1024*1024*100
                msg(i)=1;
            end
        end
        selectall=find(msg==1);%��¼����ͼƬ��������������Ķ�ѡ��ʾ���Ȱ���ѡ�У������û�ֱ�Ӱ�ȷ��
        index=Text.f3(msg==1);%��¼����ͼƬ���ļ���
        %--------������ڴ�ͼƬ����ʾҪ��Ҫ�и�Լ����û�ѡ��Ҫ�и��ͼƬ---------
        if size(index,2)>0%�����ļ�������index�����ݣ������ڹ���ͼƬ
            if exist('C:\Logs\CAFLang.mat','file')%�����л�
                [sel,ok]=listdlg('Liststring',index,'name','��ʾ','Promptstring',...
                'Thees images are too large, will be sliced in order to improve the calculation speed',selectall','listsize',[400 250]);
            else
            [sel,ok]=listdlg('Liststring',index,'name','��ʾ','Promptstring',...
                '����ͼƬ������󣬽����з�Ƭ��������߼����ٶ�','okstring',...
                'ȷ��','cancelstring','ȡ��','InitialValue',selectall','listsize',[400 250]);
            end
            if ok==0%�������ȡ��
                name=index';%��֮ǰ��ȡ�������и�ͼƬ����index��ԭ�����и��ļ�����name����
            else%���ȷ�������ѡ�е�ͼƬ������¼����
                slice=index(sel)';%�и��ļ���silce=��ͼƬ��
                index(:,sel)=[];%��������ɾ������ͼƬ��
                name=index';%��ʣ�µ�ͼƬ���ൽ���и�ͼƬ����name����
                if size(name,1)==0%������е�ͼƬ��Ҫ�ָ�
                    clear name%��ղ��и�ͼƬ����name
                end
            end
        %-----------��������ڴ�ͼƬ----------    
        else
            name=Text.f3';%���и��ļ����͵��ڵ���������ļ���
        end
    %======���ֻѡȡ��һ��ͼƬƬ=======   
    else
        info=imfinfo([Text.p3 Text.f3]);
        %------���ͼƬ����------
        if info.Height*info.Width>4000000 || info.FileSize>1024*1024*100
            if exist('C:\Logs\CAFLang.mat','file')%����ת��
                [~,ok]=listdlg('Liststring',Text.f3,'name','��ʾ','Promptstring',...
                    'Thees images are too large, will be sliced in order to improve the calculation speed','okstring',...
                    'ȷ��','cancelstring','ȡ��','listsize',[400 250]);
            else
                [~,ok]=listdlg('Liststring',Text.f3,'name','��ʾ','Promptstring',...
                    '����ͼƬ������󣬽����з�Ƭ��������߼����ٶ�','okstring',...
                    'ȷ��','cancelstring','ȡ��','listsize',[400 250]);
            end
            if ok==0%�������ȡ��
                name=Text.f3;%���и��ļ������ǵ�����ļ���
            else%�������ȷ��
                slice=cellstr(Text.f3);%�и��ļ������ǵ�����ļ���
            end
        %------���ͼƬ����------    
        else
            name=Text.f3;%���и��ļ������ǵ�����ļ���
        end
    end
    clear i index msg ok S i sel selectall%��ɨ�ɾ������ڸ���һ��
    %======������ڲ��и��ͼƬ�����������ЩͼƬ���õ��б���======
    if exist('name','var')
        whichpar=get(handles.ParListBox,'Value');
        piclistname=List{whichpar,2};
        eval(['temp=' piclistname ';'])
        if isempty(temp{1,1})
            if iscell(name)
                temp=name;
                temp(:,2)=cellstr(Text.p3);
            else
                temp=[cellstr(name),cellstr(Text.p3)];
            end
        else
            if iscell(name)
                name(:,2)=cellstr(Text.p3);
                temp=[temp;name];
            else
                temp=[temp;[cellstr(name),cellstr(Text.p3)]];
            end
        end
        eval([piclistname '=temp;'])
        eval(['set(handles.PicListBox,''string'',' piclistname '(:,1))'])
        set(handles.PicListBox,'value',1)
        List{par,4}.Tree=1;
    end
    %======��������и��ļ�����======
    if exist('slice','var')
        %��mywaitbar��
        h1=findobj(handles.axes3,'visible','off');
        set(h1,'visible','on');
        mywaitbar(0,'Please Wait...',handles.axes3,handles.Cimary);
        %��mywaitbar��
        S=size(slice,1);%ȷ��ѭ������
        for i=1:S
            num=size(List,1);
            if iscell(info)
                Info=info{i};
            else
                Info=info;
            end
            List{num+1,1}=['��ͼ����' num2str(PicListNum) ' ' slice{i,1}];
            List{num+1,2}=['PicListBox' num2str(PicListNum)];
            List{num+1,3}=0;
            List{num+1,4}=NewParStruct;
            eval([List{num+1,2} '=cell(1,2);'])
            List{num+1,4}.Tree=1;
            List{num+1,4}.Pic=1;
            List{num+1,4}.PicRead=1;            
            %======��������������ʼ�и�ͼƬ������������======
            T=(i-1)/S+0.25/S;
            set(handles.WaitBarPan,'title',['��' num2str(i) '��ͼ��ϴ������ĵȴ�'])
            mywaitbar(T,'',handles.axes3,handles.Cimary);
            [Slice.axes,Slice.name,Slice.path,pic,a,b,c,d,X,Y]=SlicePic(slice{i,1},Text.p3,Info.Width,Info.Height,Filename,Pathname);
            set(handles.WaitBarPan,'title',['���ڷ�Ƭ��' num2str(i) '��ͼ��'])
            for k=1:X*Y
                pic_draw=pic(c(k):d(k),a(k):b(k),:);
                imwrite(pic_draw,[Slice.path '\' Slice.name{k,1}],'tif')
                mywaitbar(T+0.75*k/(X*Y*S),'',handles.axes3,handles.Cimary);
            end
            pic=[];
            pic_draw=[];
            %======�������������и�ͼ������������������======
            Slice.path=[Slice.path '\'];
            eval([List{num+1,2} '{1,1}=''preview.tif'';' List{num+1,2} '{1,2}=''' Slice.path ''';'])
            add=Slice.name;
            add(:,2)=cellstr([Slice.path]);
            eval([List{num+1,2} '=[' List{num+1,2} ';add];'])
            eval([List{num+1,2} '{1,4}=''' [Text.p3 slice{i,1}] ''';'])
            eval([List{num+1,2} '{1,3}=Slice.axes;'])
            PicListNum=PicListNum+1;
        end
        eval([List{num+1,2} '{1,3}=[Slice.axes];'])
        set(handles.WaitBarPan,'title','�������')
        clear Slice pic pic_draw a b c d X Y
        set(handles.ParListBox,'string',List(:,1))
        set(handles.ParListBox,'value',size(List,1))
    end
    List{par,4}.Output=0;
    List{par,4}.Calcu=0;
    save([Pathname Filename],'-append','Pic*','List')
    OnOff
    ParListBox_Callback(hObject, eventdata, handles)
    PicListBox_Callback(hObject, eventdata, handles)
end

% ----------------------ͼ��ȥ�루���ڿ�����^_^��-----------------------
function PicNoise_Callback(hObject, eventdata, handles)
% hObject    handle to PicNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Tree_Callback(hObject, eventdata, handles)
% hObject    handle to Tree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------�������ģ��---------------------------
function TreeOpen_Callback(hObject, eventdata, handles)
% hObject    handle to TreeOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
par=get(handles.ParListBox,'value');%���Ŀǰѡ�еڼ����ļ���
if size(List,2)==5%����Ѿ����ھ�������ѯ���û�Ҫ��Ҫ�滻
    if ~isempty(List{par,5})
        if exist('C:\Logs\CAFLang.mat','file')
            answer=questdlg('Existed Classification model, replace��','��ʾ','��Y','��N','��Y');
        else
            answer=questdlg('�Ѵ��ڷ���ģ�ͣ��滻��','��ʾ','��Y','��N','��Y');
        end
        if strcmp(answer,'��N')
            return
        end
    end
end
if exist('C:\Logs\CAFLang.mat','file')%�����л�
    [filename,pathname]=uigetfile('*.mat','Select the Classification model');
else
    [filename,pathname]=uigetfile('*.mat','ѡȡ����ģ��');
end
if ~isnumeric(pathname)%���·����ȷ�����������
    tree=[pathname filename];
    load(tree)
    if exist('Kind','var') && strcmp(Kind,'����ģ���ļ�')
        msgbox('����ģ�͵������','��ʾ')
        treename=['����ģ��-' List{par,1} '.mat'];
        treepath=[Pathname Filename(1:end-4) '.proj\'];
        List{par,5}=[treepath treename];
        save([treepath treename],'Tree','Kind')
        List{par,4}.TreeApply=1;
        OnOff
        save([Pathname Filename],'-append','List')
    else
        if exist('C:\Logs\CAFLang.mat','file')
            warndlg('Non Classification model file��')
        else
            warndlg('�Ƿ���ģ���ļ���','����')
        end
    end
end


% --------------------------------------------------------------------
function TreeTraining_Callback(hObject, eventdata, handles)
% hObject    handle to TreeTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function TreeProd_Callback(hObject, eventdata, handles)
% hObject    handle to TreeProd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function TreeApply_Callback(hObject, eventdata, handles)
% hObject    handle to TreeApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ------------------------ֻ���൱ǰ����-----------------------------
function TreeApplyOne_Callback(hObject, eventdata, handles)
% hObject    handle to TreeApplyOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
tic
load([Pathname Filename],'PicListBox*')
h1=findobj(handles.axes3,'visible','off');%��ȡ����1�Ŀ��ӻ����
set(h1,'visible','on');%���þ��Ϊ�ɼ�
mywaitbar(0,'',handles.axes3,handles.Cimary);
%���ѡ���˵ڼ����ļ��к͵ڼ���ͼƬ
par=get(handles.ParListBox,'value');%par����ߵ��ļ�����
pic=get(handles.PicListBox,'value');%pic���ұߵ�ͼƬ��
eval(['temp=' List{par,2} ';'])%��ȡ���ļ��еĴ������
num=size(temp,1);%ȷ�����ļ����е�ͼƬ��
Treepath=List{par,5};
Mask=cell(num,1);
Picpath=cell(num,1);
set(handles.WaitBarPan,'title','�����У����Ժ�...')
set(handles.ParListBox,'enable','off')
for i=1:num
    Picpath{i,1}=[temp{i,2} temp{i,1}];
    mywaitbar(0.2*i/num,'',handles.axes3,handles.Cimary);
end
%======���ͼƬ����С��10������ôû��Ҫ������======
if num<=10 %List{par,3}
    for i=1:num
        mask= GUITraining(Treepath,Picpath{i,1});
        Mask{i,1}=mask;
        mask=[];
        mywaitbar(0.2+0.2*i/num,'',handles.axes3,handles.Cimary);
    end
%======���ͼƬ��������10������ô����������======    
else
    parfor i=1:num%���м���
        mask= GUITraining(Treepath,Picpath{i,1});
        Mask{i,1}=mask;
        mask=[];
    end
end
T=toc;
mywaitbar(0.4,'',handles.axes3,handles.Cimary);
%======�鿴���ļ�����������࣬����Ǵ�ͼ���飬��ѡ���˴�ͼƬ======
if List{par,3}==0
    eval(['Loca=' List{par,2} '{1,3};'])
    mask=false(Loca(end,4),Loca(end,2));%������Ĥ
    %��ÿһ��СͼƬƴ��һ����Ϊ��ͼƬ����Ĥ
    for i=1:num-1
        mask(Loca(i,3):Loca(i,4),Loca(i,1):Loca(i,2))=Mask{i+1,1};
        mywaitbar(0.4+0.6*i/(num-1),'',handles.axes3,handles.Cimary);
    end
    %���㸲�Ƕ�
    [coverage]=datacount(mask);
    %������
    varname=['R_' List{par,2}];
    varpath=[Pathname Filename(1:end-4) '.proj\'];
    eval([varname '.mask=mask;'])
    eval([varname '.coverage=coverage;'])
    if exist([varpath 'result.mat'],'file')==0
        save([varpath 'result.mat'],varname)
    else
        save([varpath 'result.mat'],'-append',varname)
    end
%======�鿴���ļ�����������࣬�����Сͼ����======
else
    varname=['R_' List{par,2}];
    varpath=[Pathname Filename(1:end-4) '.proj\'];
    %���㸲�Ƕ�
    [coverage]=datacount(Mask);
    %������
    eval([varname '.mask=Mask;'])
    eval([varname '.coverage=coverage;'])
    if exist([varpath 'result.mat'],'file')==0
        save([varpath 'result.mat'],varname)
    else
        save([varpath 'result.mat'],'-append',varname)
    end
    mywaitbar(1,'',handles.axes3,handles.Cimary);
end
set(handles.ParListBox,'enable','on')
save([Pathname Filename],'-append','PicListBox*')
clear Mask mask temp R_PicListBox* PicListBox*
set(handles.WaitBarPan,'title',['������ɣ���ʱ' num2str(T) '��'])
List{par,4}.Calcu=1;
List{par,4}.DataPan=1;
List{par,4}.Output=1;
save([Pathname Filename],'-append','List')
OnOff
R_name=['R_' List{par,2}];
eval(['load([Pathname Filename(1:end-4) ''.proj/result.mat''],''' R_name ''')'])
if List{par,3}==1
    eval(['mask_show=' R_name '.mask{pic,1};']);
else
    eval(['mask_show=' R_name '.mask;']);
end
%imagesc(mask_show,'Parent',handles.axes2);
imshow(mask_show,'Parent',handles.axes2);
axes(handles.axes2)
axis off


% --------------------------������������---------------------------
function TreeApplyAll_Callback(hObject, eventdata, handles)
% hObject    handle to TreeApplyAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
load([Pathname Filename],'PicListBox*')
[cyclesize,iscycle]=size(List);
%������ھ�����������з���
if iscycle==5%��Ϊ������λ�ڵ����У���û�о�����ʱ��iscycleֻ��4�У��з�
    t0=clock;%��ʱ��ʼ
    Name_select=List(:,1);
    Line_select=zeros(cyclesize,1);
    Num_select=0;
    for i=1:cyclesize
        if find(List{i,4}.TreeApply==1)==1%Ѱ�Ҿ��о�����������
            Line_select(i,1)=1;%��¼���о�������
            Num_select=Num_select+1;
        end
    end
    Name_select(Line_select==1,:)=[];%�Ѿ��о��������ų������������û�û�о������ĺ�������
    if size(Name_select)>0
        if exist('C:\Logs\CAFLang.mat','file')
            [~,~]=listdlg('Liststring',Name_select,'name','��ʾ','Promptstring',...
                'The following picture does not have a Classification model, it will be skipped','listsize',[400 250]);
        else
            [~,~]=listdlg('Liststring',Name_select,'name','��ʾ','Promptstring',...
                '����ͼƬû�з���ģ�ͣ������������ģ�ͷ���','okstring',...
                'ȷ��','cancelstring','ȡ��','listsize',[400 250]);
        end
    end
    CalcuLine=find(Line_select==1);%��Ҫ�������������
    realsize=size(CalcuLine,1);%��Ҫ�������������
    h1=findobj(handles.axes3,'visible','off');%��ȡ����1�Ŀ��ӻ����
    set(h1,'visible','on');%���þ��Ϊ�ɼ�
    mywaitbar(0,'',handles.axes3,handles.Cimary);
    set(handles.ParListBox,'enable','off')%�����ʱ��Ҫ���û��ҵ㣬��������
    T=0;
    %======ѭ������ÿһ�����飬����Ĵ���͡����㵱ǰ���顿�Ĵ�����ȫһ��======
    for j=1:realsize
        mywaitbar((j-1)/realsize,'',handles.axes3,handles.Cimary);
        par=CalcuLine(j,1);
        eval(['temp=' List{par,2} ';'])
        num=size(temp,1);
        Treepath=List{par,5};
        Mask=cell(num,1);
        Picpath=cell(num,1);
        set(handles.WaitBarPan,'title',['��������[' List{par,1}(1:6) '] ��һ������ʱ' num2str(T) '��'])
        for i=1:num
            Picpath{i,1}=[temp{i,2} temp{i,1}];
            mywaitbar((j-1)/realsize+0.2*((j-1)/realsize)*(i/num),'',handles.axes3,handles.Cimary);
        end
        tic
        set(handles.ParListBox,'enable','off')
        if num<=10 %List{par,3}
            for i=1:num
                mask= GUITraining(Treepath,Picpath{i,1});
                Mask{i,1}=mask;
                mask=[];
                mywaitbar(1.2*(j-1)/realsize+0.2*((j-1)/realsize)*(i/num),'',handles.axes3,handles.Cimary);
            end
        else
            parfor i=1:num
                mask= GUITraining(Treepath,Picpath{i,1});
                Mask{i,1}=mask;
                mask=[];
            end
        end
        T=toc;
        %set(handles.WaitBarPan,'title',[List{par,1}(1:6) '��ʱ' num2str(T) '��'])
        mywaitbar((j-1)/realsize+0.4*((j-1)/realsize),'',handles.axes3,handles.Cimary);
        if List{par,3}==0
            eval(['Loca=' List{par,2} '{1,3};'])
            mask=false(Loca(end,4),Loca(end,2));
            for i=1:num-1
                mask(Loca(i,3):Loca(i,4),Loca(i,1):Loca(i,2))=Mask{i+1,1};
                mywaitbar(1.4*((j-1)/realsize)+0.6*((j-1)/realsize)*(i/(num-1)),'',handles.axes3,handles.Cimary);
            end
            [coverage]=datacount(mask);
            varname=['R_' List{par,2}];
            varpath=[Pathname Filename(1:end-4) '.proj\'];
            eval([varname '.mask=mask;'])
            eval([varname '.coverage=coverage;'])
            if exist([varpath 'result.mat'],'file')==0
                save([varpath 'result.mat'],varname)
            else
                save([varpath 'result.mat'],'-append',varname)
            end
        else
            varname=['R_' List{par,2}];
            varpath=[Pathname Filename(1:end-4) '.proj\'];
            [coverage]=datacount(Mask);
            eval([varname '.mask=Mask;'])
            eval([varname '.coverage=coverage;'])
            if exist([varpath 'result.mat'],'file')==0
                save([varpath 'result.mat'],varname)
            else
                save([varpath 'result.mat'],'-append',varname)
            end
        end
        set(handles.ParListBox,'enable','on')
        save([Pathname Filename],'-append','PicListBox*')
        mywaitbar(j/realsize,'',handles.axes3,handles.Cimary);
        clear Mask mask temp R_PicListBox*
        List{par,4}.Calcu=1;
        List{par,4}.DataPan=1;
        List{par,4}.Output=1;
        save([Pathname Filename],'-append','List')
    end
    Time=etime(clock,t0);
    set(handles.WaitBarPan,'title',['�������,����ʱ' num2str(Time) '��'])
    clear PicListBox*
    OnOff
    ParListBox_Callback(hObject, eventdata, handles)
    Calcu_Coverage_Callback(hObject, eventdata, handles)
end


% --------------------------����ѵ��ͼƬ-----------------------------
function TreeTrainPic_Callback(hObject, eventdata, handles)
% hObject    handle to TreeTrainPic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
Size=size(List,2);%�ж��ǲ����Ѿ����ڷ���ģ���ˣ�����ģ�ʹ����ڵ����У�
par=get(handles.ParListBox,'value');
%======������ڷ���ģ��======
if Size==5
    if ~isempty(List{par,5})
        if exist('C:\Logs\CAFLang.mat','file')%�����л�
            answer=questdlg('Existed Classification model, replace��','��ʾ','��Y','��N','��Y');
        else
            answer=questdlg('�Ѵ��ڷ���ģ�ͣ�����ѵ����','��ʾ','��Y','��N','��Y');
        end
        if strcmp(answer,'��N')
            return%���������ѵ�����������ֹ
        end
    end
end
if exist('C:\Logs\CAFLang.mat','file')%�����л�
    uiwait(warndlg('First select��foreground�� image��then��background�� image','��ܰ��ʾ'));
else
    uiwait(warndlg('����ѡ��ǰ����ͼƬ��Ȼ����ѡ�񡾱�����ͼƬ','��ܰ��ʾ'));
end
%ѡ��ѵ��ͼƬ
if exist('C:\Logs\CAFLang.mat','file')
    [Text.f1,Text.p1]=uigetfile({'*.tif;*.png;*.jpg;*.tiff'},'Select��foreground��image');
    [Text.f2,Text.p2]=uigetfile({'*.tif;*.png;*.jpg;*.tiff'},'Select��background��image');
else
    [Text.f1,Text.p1]=uigetfile({'*.tif;*.png;*.jpg;*.tiff'},'��ѡȡ��ǰ����ͼƬ');
    [Text.f2,Text.p2]=uigetfile({'*.tif;*.png;*.jpg;*.tiff'},'��ѡȡ��������ͼƬ');
end
%���ѡȡ��ͼƬ���㣬�������ֹ
if isnumeric(Text.f1) || isnumeric(Text.f2)
    if exist('C:\Logs\CAFLang.mat','file')
        warndlg('Did not choose enough training images','��ʾ')
    else
        warndlg('δѡ���㹻ѵ���زģ��������','��ʾ')
    end
    return
end
Pic.veg=imread([Text.p1 Text.f1]);
Pic.back=imread([Text.p2 Text.f2]);
%ͼƬת���ɷ�����ѵ����ʽ�ļ�
Pic.Back=pic2mat(Pic.back,1,0);%����
Pic.Veg=pic2mat(Pic.veg,1,1');%ǰ��
%���ɱ�׼�ľ�����ѵ���ļ�
TreeSource.X=[Pic.Back.output;Pic.Veg.output];
TreeSource.Y=[Pic.Back.class;Pic.Veg.class];
%������ѵ��
Tree=fitctree(TreeSource.X,TreeSource.Y,'predictornames',{'R' 'G' 'B' 'H' 'S' 'V' 'L' 'A*' 'B*' 'X' 'Y' 'Z'});
%axes(handles.axes1);
if exist('C:\Logs\CAFLang.mat','file')
    msgbox('Done')
else
    msgbox('����ģ��ѵ�����','��ʾ')
end
treename=['����ģ��-' List{par,1} '.mat'];
treepath=[Pathname Filename(1:end-4) '.proj\'];
List{par,5}=[treepath treename];
Kind='����ģ���ļ�';
%���������
save([treepath treename],'Tree','Kind')
List{par,4}.TreeApply=1;
OnOff
save([Pathname Filename],'-append','List')


% ------------------------ͼ��ѡ��ѵ��----------------------------
function TreeTrainSelect_Callback(hObject, eventdata, handles)
% hObject    handle to TreeTrainSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global List
Size=size(List,2);%�ж��ǲ����Ѿ����ڷ���ģ���ˣ�����ģ�ʹ����ڵ����У�
par=get(handles.ParListBox,'value');
if Size==5%������ڷ���ģ��
    if ~isempty(List{par,5})
        if exist('C:\Logs\CAFLang.mat','file')
            answer=questdlg('Existed Classification model, replace��','��ʾ','��Y','��N','��Y');
        else
            answer=questdlg('�Ѵ��ڷ���ģ�ͣ�����ѵ����','��ʾ','��Y','��N','��Y');
        end
        if strcmp(answer,'��N')
            return
        end
    end
end
set(handles.Cimary,'pointer','arrow')
set(handles.ParListBox,'enable','off')
set(handles.PicCtrlPan,'visible','on')%�����ֶ�ѡ�㹦��
set(handles.axes2,'box','on')
set(handles.EagleEye,'value',0)
set(handles.Confirm,'enable','off')
set(handles.TreeTrainConfirm,'enable','off')
set(handles.Pic,'enable','off')
set(handles.Tree,'enable','off')
%���ͼƬ������Ԥ��������ʾͼƬ
PicListBox_Callback(hObject, eventdata, handles)
if exist('C:\Logs\CAFLang.mat','file')
    str='<html><div align="center"><b>Instructions</b></div><br><hr>��Left�� Select foreground</hr></br><br>��right�� Select Background</br><br>��Dblclick�� Clear trail</br></html>';
else
    str='<html><div align="center"><b>����˵��</b></div><br><hr>������� ѡȡǰ��ɫ</hr></br><br>���Ҽ��� ѡȡ����ɫ</br><br>��˫���� �����ѡ��</br></html>';
end
set(handles.text1,'string',str)

%List{par,4}.TreeApply=1;
%OnOff
%save([Pathname Filename],'-append','List')


% --- Executes on selection change in ParListBox.
function ParListBox_Callback(hObject, eventdata, handles)
% hObject    handle to ParListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ParListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ParListBox
global Filename Pathname List
a=get(handles.ParListBox,'string');
if ~strcmp(a{1,1},'')
    load([Pathname Filename],'PicListBox*')
    par=get(handles.ParListBox,'value');
    set(handles.PicListBox,'value',1)
    eval(['temp=' List{par,2} ';'])
    OnOff
    eval(['set(handles.PicListBox,''string'',' List{par,2} '(:,1))'])
    if isempty(temp{1,1})
        cla(handles.axes1)
    else
        eval(['preview=imread([' List{par,2} '{1,2} ' List{par,2} '{1,1}]);'])
        %imshow(preview,'Parent',handles.axes1);
        imshow(preview,'Parent',handles.axes1);
        axes(handles.axes1)
        axis off
    end
    if strcmp(get(handles.Calcu,'enable'),'on')
        R_name=['R_' List{par,2}];
        eval(['load([Pathname Filename(1:end-4) ''.proj/result.mat''],''' R_name ''')'])
        if List{par,3}==1
            eval(['mask_show=' R_name '.mask{1,1};']);
        else
            eval(['mask_show=' R_name '.mask;']);
        end
        %imagesc(mask_show,'Parent',handles.axes2);
        Calcu_Coverage_Callback(hObject, eventdata, handles)
        imshow(mask_show,'Parent',handles.axes2);
        axes(handles.axes2)
        axis off
    else
        cla(handles.axes2)
        axes(handles.axes2)
        axis off
    end
end


% --- Executes during object creation, after setting all properties.
function ParListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ParListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function AddPar_Callback(hObject, eventdata, handles)
% hObject    handle to AddPar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename Pathname List
if exist('C:\Logs\CAFLang.mat','file')
    name=inputdlg('Input the chunk namer','Add chunk',[1 40]);
else
    name=inputdlg('��������������','��������',[1 40]);
end
if ~isempty(name)
    load([Pathname Filename],'PicListNum')
    str_name=['Сͼ����' num2str(PicListNum) ' ' char(name)];
    var_name=['PicListBox' num2str(PicListNum)];
    Size=size(List,1);
    if Size==1
        if isempty(List{1,1})
            List{1,1}=str_name;
        else
            List{2,1}=str_name;
            Size=Size+1;
        end
    else
        List{Size+1,1}=str_name;
        Size=Size+1;
    end
    set(handles.ParListBox,'string',List(:,1))
    set(handles.ParListBox,'value',Size)
    PicListNum=PicListNum+1;
    eval([var_name '=cell(1,2);'])
    List{Size,4}=NewParStruct;
    List{Size,4}.Pic=1;
    List{Size,4}.PicRead=1;
    List{Size,2}=var_name;
    List{Size,3}=1;
    OnOff
    save([Pathname Filename],'-append','Pic*','List')
    ParListBox_Callback(hObject, eventdata, handles)
end


% --------------------------------------------------------------------
function DeletePar_Callback(hObject, eventdata, handles)
% hObject    handle to DeletePar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
a=get(handles.ParListBox,'string');
if ~strcmp(a{1,1},'');
    if exist('C:\Logs\CAFLang.mat','file')
        answer=questdlg('This operation can not be restored, confirm delete��','����','ȷ��Y','ȡ��N','ȡ��N');
    else
        answer=questdlg('�˲������ɻָ���ȷ��ɾ����','����','ȷ��Y','ȡ��N','ȡ��N');
    end
    if strcmp(answer,'ȷ��Y')
        load([Pathname Filename],'PicListBox*')
        par=get(handles.ParListBox,'value');
        temp=List{par,2};  
        size_list=size(List,1);
        if List{par,3}==0;
            eval(['path=' List{par,2} '{1,2};'])
            cmd_rmdir_long
        end
        Resultname=[Pathname Filename(1:end-4) '.proj\result.mat'];
        if exist(Resultname,'file')
            load(Resultname)
            if ~exist('R_PicListBox0','var')
                R_PicListBox0='All4Cimary';
            end
            deletename=['R_' List{par,2}];
            eval(['clear ' deletename])
            save(Resultname,'R_PicListBox*')
        end
        if size(List,2)==5
            if ~isempty(List{par,5})
                delete(List{par,5})
            end
        end
        eval([temp '=[];'])
        if size_list==1
            List=cell(1,4);
            List{1,4}=NewParStruct;
            set(handles.PicListBox,'string',{''})
            cla(handles.axes1)
            cla(handles.axes2)
            set(handles.PicListBox,'value',1)
            OnOff
        else
            List(par,:)=[];
            if par~=1
                set(handles.ParListBox,'value',par-1)
            end
        end
        set(handles.ParListBox,'String',List(:,1))
        save([Pathname Filename],'-append','PicListBox*','List')
        ParListBox_Callback(hObject,eventdata,handles)
    end
end


% --------------------------------------------------------------------
function ParListCtrl_Callback(hObject, eventdata, handles)
% hObject    handle to ParListCtrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AddPic_Callback(hObject, eventdata, handles)
% hObject    handle to AddPic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PicRead_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function DeletePic_Callback(hObject, eventdata, handles)
% hObject    handle to DeletePic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename Pathname List
a=get(handles.ParListBox,'string');
if ~strcmp(a{1,1},'');
    load([Pathname Filename],'PicListBox*')
    par=get(handles.ParListBox,'value');
    pic=get(handles.PicListBox,'value');
    eval(['temp=' List{par,2} ';'])
    Size=size(temp,1);
    if Size==1
        temp=cell(1,2);
        cla(handles.axes1)
        cla(handles.axes2)
        set(handles.PicListBox,'string',{''})
    else
        temp(pic,:)=[];
        if pic~=1
            pic=pic-1;
            set(handles.PicListBox,'value',pic)
        end
        set(handles.PicListBox,'string',temp(:,1))
        eval(['preview=imread([' List{par,2} '{pic,2} ' List{par,2} '{pic,1}]);'])
        imshow(preview,'Parent',handles.axes1);
        axes(handles.axes1)
        axis off
    end
    eval([List{par,2} '=temp;'])
    save([Pathname Filename],'-append','PicListBox*','List')
end


% --------------------------------------------------------------------
function PicListCtrl_Callback(hObject, eventdata, handles)
% hObject    handle to PicListCtrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in ParListBox.

%-------------------���ͼƬ������Ԥ��������ʾͼƬ-------------------
function PicListBox_Callback(hObject, eventdata, handles)
% hObject    handle to ParListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ParListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ParListBox
global List Pathname Filename axes2pic
a=get(handles.PicListBox,'string');%���Ŀǰѡ�е�ͼƬ��
if ~strcmp(a{1,1},'')%���ͼƬ�����ǿյ�
    load([Pathname Filename],'PicListBox*')
    par=get(handles.ParListBox,'value');%��ȡ�ǵڼ����ļ���
    pic=get(handles.PicListBox,'value');%��ȡ�ǵڼ���ͼƬ
    if eval(['~isempty(' List{par,2} '{pic,2})'])%�����Ӧ���ļ��к�ͼƬ����
        cla(handles.axes1)%��վ�ͼ
        eval(['preview=imread([' List{par,2} '{pic,2} ' List{par,2} '{pic,1}]);'])%��ȡ����ͼ
        imshow(preview,'Parent',handles.axes1);%��ʾͼƬ
        axes(handles.axes1)
        axis off
        %=======����û��������ֶ�ѡ�㹦��======
        if strcmp(get(handles.PicCtrlPan,'visible'),'on')
            cla(handles.axes2)
            axes2pic=preview;
            imshow(axes2pic,'Parent',handles.axes2);
            set(handles.ZoomIn,'enable','off')
            set(handles.ZoomIn,'value',0)
            ZoomIn_Callback(hObject, eventdata, handles)%����ѡ�㸨���Ŵ���
            set(handles.EagleEye,'value',0)
        %=======����û�û�������ֶ�ѡ�㹦��======
        else
            %------���֮ǰ��������˸��ǶȵĽ������ô����ʾ�ڰ׶�ֵͼ�Լ����Ƕ���ֵ------
            if strcmp(get(handles.Calcu,'enable'),'on')
                R_name=['R_' List{par,2}];
                eval(['load([Pathname Filename(1:end-4) ''.proj/result.mat''],''' R_name ''')'])
                if List{par,3}==1
                    eval(['mask_show=' R_name '.mask{pic,1};']);
                else
                    eval(['mask_show=' R_name '.mask;']);
                end
                %imagesc(mask_show,'Parent',handles.axes2);
                Calcu_Coverage_Callback(hObject, eventdata, handles)%���Ƕ���ֵ
                imshow(mask_show,'Parent',handles.axes2);%��ʾ�ڰ׶�ֵͼ
                axes(handles.axes2)
                axis off
            end
        end
    end
end

% --- Executes during object creation, after setting all properties.
function PicListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ParListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Calcu_Callback(hObject, eventdata, handles)
% hObject    handle to Calcu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Confirm.
function Confirm_Callback(hObject, eventdata, handles)
% hObject    handle to Confirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global axes2pic
blue_0=findobj('type','line','parent',handles.axes2,'-and','Color','blue','parent',handles.axes2);
green_1=findobj('type','line','parent',handles.axes2,'-and','Color','green','parent',handles.axes2);
size0=size(blue_0,1);
X_0=zeros(size0+1,1);
Y_0=zeros(size0+1,1);
X_0(1,1)=blue_0(1).XData(1,2);
Y_0(1,1)=blue_0(1).YData(1,2);
for i=1:size0
    X_0(i+1,1)=blue_0(i).XData(1,1);
    Y_0(i+1,1)=blue_0(i).YData(1,1);
end
size1=size(green_1,1);
X_1=zeros(size1+1,1);
Y_1=zeros(size1+1,1);
X_1(1,1)=green_1(1).XData(1,2);
Y_1(1,1)=green_1(1).YData(1,2);
for i=1:size1
    X_1(i+1,1)=green_1(i).XData(1,1);
    Y_1(i+1,1)=green_1(i).YData(1,1);
end
X_0=round(X_0);
X_1=round(X_1);
Y_0=round(Y_0);
Y_1=round(Y_1);
back=zeros(size0,1,3);
for i=1:size0
    back(i,1,:)=axes2pic(Y_0(i),X_0(i),:);
end
front=zeros(size1,1,3);
for i=1:size1
    front(i,1,:)=axes2pic(Y_1(i),X_1(i),:);
end
Back=pic2mat(back,1,0);
Front=pic2mat(front,1,1);
TreeSource.X=[Back.output;Front.output];
TreeSource.Y=[Back.class;Front.class];
if exist('C:\Logs\CAFsystem.mat','file')
    load('C:\Logs\CAFsystem.mat')
    tree_name_all=get(handles.PicListBox,'string');
    tree_name_num=get(handles.PicListBox,'value');
    tree_name_date=datestr(now);
    tree_name=[tree_name_all{tree_name_num,1},' ',tree_name_date(end-7:end)];
    tree_list{tree_num,1}=tree_name;
    tree_list{tree_num,2}=TreeSource.X;
    tree_list{tree_num,3}=TreeSource.Y;
    tree_num=tree_num+1;
    save('C:\Logs\CAFsystem.mat','tree_num','tree_list')
else
    tree_name_all=get(handles.PicListBox,'string');
    tree_name_num=get(handles.PicListBox,'value');
    tree_name_date=datestr(now);
    tree_num=1;
    tree_name=[tree_name_all{tree_name_num,1},' ',tree_name_date(end-7:end)];
    tree_list{tree_num,1}=tree_name;
    tree_list{tree_num,2}=TreeSource.X;
    tree_list{tree_num,3}=TreeSource.Y;
    tree_num=tree_num+1;
    save('C:\Logs\CAFsystem.mat','tree_num','tree_list')
end
set(handles.TreeTrainConfirm,'enable','on')
if exist('C:\Logs\CAFLang.mat','file')
    msgbox('Select points done��please training dicision tree or select other points','��ʾ')
else
    msgbox('ѵ����ѡ����ϣ�����з���ģ��ѵ�����߼���ѡȡ���ͼ���ϵĵ�','��ʾ')
end
delete(findobj('type','line','parent',handles.axes2))


% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ParListBox,'enable','on')
set(handles.ZoomIn,'enable','off')
set(handles.ZoomIn,'value',0)
ZoomIn_Callback(hObject, eventdata, handles)
set(handles.axes2,'box','off')
cla(handles.axes2)
axes(handles.axes2)
axis off
set(handles.PicCtrlPan,'visible','off')
set(handles.Pic,'enable','on')
set(handles.Tree,'enable','on')
delete(findobj('type','line','parent',handles.axes1))

% --- Executes on button press in EagleEye.
function EagleEye_Callback(hObject, eventdata, handles)
% hObject    handle to EagleEye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of EagleEye
global Filename Pathname List WBM_row WBM_col picpos axes2pic
if get(handles.EagleEye,'value')==0
    PicListBox_Callback(hObject, eventdata, handles)
    set(handles.ZoomIn,'enable','off')
    set(handles.ZoomIn,'value',0)
    ZoomIn_Callback(hObject, eventdata, handles)
else
    par=get(handles.ParListBox,'value');
    if List{par,3}==0
        load([Pathname Filename],'PicListBox*')
        eval(['picpos=' List{par,2} '{1,3};'])
        [WBM_row,WBM_col,~]=size(axes2pic);
        picpos=[picpos(:,1:2).*(WBM_col/picpos(end,2)),picpos(:,3:4).*(WBM_row/picpos(end,4))];
    end
end


% --- Executes on button press in TreeTrainConfirm.
function TreeTrainConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to TreeTrainConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename Pathname List
if exist('C:\Logs\CAFsystem.mat','file')
    load('C:\Logs\CAFsystem.mat')
    n=size(tree_list,1);
    selectall=1:n;
    if exist('C:\Logs\CAFLang.mat','file')
        [sel,ok]=listdlg('Liststring',tree_list(:,1),'name','��ʾ','Promptstring',...
            'Classification model training will be carried out using the following training set','InitialValue',selectall','listsize',[400 250]);
    else
        [sel,ok]=listdlg('Liststring',tree_list(:,1),'name','��ʾ','Promptstring',...
            '���������µ�ѵ�������з���ģ��ѵ��','okstring',...
            'ȷ��','cancelstring','ȡ��','InitialValue',selectall','listsize',[400 250]);
    end
    if ok==1
        tree_train=tree_list(sel,2:3);
        TreeSource.X=cell2mat(tree_train(:,1));
        TreeSource.Y=cell2mat(tree_train(:,2));
        Tree=fitctree(TreeSource.X,TreeSource.Y,'predictornames',{'R' 'G' 'B' 'H' 'S' 'V' 'L' 'A*' 'B*' 'X' 'Y' 'Z'});
        par=get(handles.ParListBox,'value');
        treename=['����ģ��-' List{par,1} '.mat'];
        treepath=[Pathname Filename(1:end-4) '.proj\'];
        List{par,5}=[treepath treename];
        Kind='����ģ���ļ�';
        save([treepath treename],'Tree','Kind')
        List{par,4}.TreeApply=1;
        OnOff
        save([Pathname Filename],'-append','List')
        delete('C:\Logs\CAFsystem.mat')
        set(handles.ParListBox,'enable','on')
        cla(handles.axes2)
        axes(handles.axes2)
        axis off
        set(handles.PicCtrlPan,'visible','off')
        set(handles.ZoomIn,'enable','off')
        set(handles.ZoomIn,'value',0)
        ZoomIn_Callback(hObject, eventdata, handles)
        uiwait(msgbox('����ģ��ѵ�����','��ʾ'))
        delete(findobj('type','line','parent',handles.axes1))
    end
end

% --- Executes on button press in ZoomIn.
function ZoomIn_Callback(hObject, eventdata, handles)
% hObject    handle to ZoomIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ZoomIn
val=get(handles.ZoomIn,'value');
if val
    h = zoom;
    setAxesZoomMotion(h,handles.axes2,'both');%horizontal��vertical���Ŵ�
    zoom on
    setAllowAxesZoom(h,handles.axes1,false);
    setAllowAxesZoom(h,handles.axes3,false);
    set(h,'direction','in');
    if exist('C:\Logs\CAFLang.mat','file')
        set(handles.ZoomIn,'string','Select points')
    else
        set(handles.ZoomIn,'string','����ѡ��')
    end
else
    zoom off
    if exist('C:\Logs\CAFLang.mat','file')
        set(handles.ZoomIn,'string','Assistant amplification')
    else
        set(handles.ZoomIn,'string','ѡ�㸨���Ŵ�')
    end
end


% -------------------------����ֲ�����Ƕ�-----------------------------
function Calcu_Coverage_Callback(hObject, eventdata, handles)
% hObject    handle to Calcu_Coverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
par=get(handles.ParListBox,'value');
resultname=List{par,2};
pic=get(handles.PicListBox,'value');
name=['R_' resultname];
load([Pathname Filename],resultname)
load([Pathname Filename(1:end-4) '.proj/result.mat'],name)
eval(['answer=' name '.coverage(pic,1);'])
if exist('C:\Logs\CAFLang.mat','file')%�����л�
    %msgbox(['The coverage of foreground is' num2str(answer*100) '%'],'���')
    set(handles.Cover,'string',[num2str(answer*100) '%'])
else
    %msgbox(['��ͼƬ��ǰ���Ƕ���' num2str(answer*100) '%'],'���')
    set(handles.Cover,'string',[num2str(answer*100) '%'])
end


% --------------------------------------------------------------------
function Output_Callback(hObject, eventdata, handles)
% hObject    handle to Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% -----------------------��ֵͼ����------------------------------
function Output_2_Callback(hObject, eventdata, handles)
% hObject    handle to Output_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
if exist('C:\Logs\CAFLang.mat','file')%����ת��
    [filename, pathname]=uiputfile('*.tif','Please select the save path of two value garph');
else
    [filename, pathname]=uiputfile('*.tif','��ѡ���ֵͼ����·��');
end
%======����û�����ȡ��======
if isnumeric(pathname)
    if exist('C:\Logs\CAFLang.mat','file')%����ת��
        warndlg('Canceled��')
    else
        warndlg('δѡ��·����','��ʾ')
    end
%======����û�ѡ���˺Ϸ���·����======   
else
    par=get(handles.ParListBox,'value');
    resultname=List{par,2};
    pic=get(handles.PicListBox,'value');
    name=['R_' resultname];
    load([Pathname Filename],resultname)
    load([Pathname Filename(1:end-4) '.proj/result.mat'],name)
    eval(['mask=' name '.mask;'])
    if iscell(mask)
        pic_out=mask{pic,1};
    else
        pic_out=mask;
    end
    imwrite(pic_out,[pathname filename],'tif')
    msgbox(['��ֵͼ�ɹ�������' pathname '��'],'�ɹ�')
end

% ---------------------------����ǰ��ͼ-------------------------------
function Output_front_Callback(hObject, eventdata, handles)
% hObject    handle to Output_front (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
if exist('C:\Logs\CAFLang.mat','file')
    [filename, pathname]=uiputfile('*.tif','Please select the save path of foreground garph');
else
    [filename, pathname]=uiputfile('*.tif','��ѡ��ǰ��ͼ����·��');
end
if isnumeric(pathname)
    if exist('C:\Logs\CAFLang.mat','file')
        warndlg('Canceled��')
    else
        warndlg('δѡ��·����','��ʾ')
    end
else
    set(handles.WaitBarPan,'title','��д��...���Ժ�')
    par=get(handles.ParListBox,'value');
    resultname=List{par,2};
    pic=get(handles.PicListBox,'value');
    name=['R_' resultname];
    load([Pathname Filename],resultname)
    load([Pathname Filename(1:end-4) '.proj/result.mat'],name)
    eval(['mask=' name '.mask;'])
    if iscell(mask)
        pic_out=mask{pic,1};
        eval(['pic_path=[' resultname '{pic,2} ' resultname '{pic,1}];'])
        pic_yuantu=double(imread(pic_path));
        pic_output(:,:,1)=pic_yuantu(:,:,1).*pic_out;
        pic_output(:,:,2)=pic_yuantu(:,:,2).*pic_out;
        pic_output(:,:,3)=pic_yuantu(:,:,3).*pic_out;
    else
        pic_out=mask;
        eval(['pic_path=' resultname '{pic,4};'])
        pic_yuantu=double(imread(pic_path));
        pic_output(:,:,1)=pic_yuantu(:,:,1).*pic_out;
        pic_output(:,:,2)=pic_yuantu(:,:,2).*pic_out;
        pic_output(:,:,3)=pic_yuantu(:,:,3).*pic_out;
    end
    pic_output=uint8(pic_output);
    imwrite(pic_output,[pathname filename],'tif')
    msgbox(['ǰ��ͼ�ɹ�������' pathname '��'],'�ɹ�')
    set(handles.WaitBarPan,'title','�������')
end



% -----------------------------�����ǶȽ��----------------------------
function Output_calcu_Callback(hObject, eventdata, handles)
% hObject    handle to Output_calcu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
if exist('C:\Logs\CAFLang.mat','file')
    [filename, pathname]=uiputfile('*.xls','Please select the save path of Excel');
else
    [filename, pathname]=uiputfile('*.xls','��ѡ����excel����·��');
end
if isnumeric(pathname)
    if exist('C:\Logs\CAFLang.mat','file')
        warndlg('Canceled��')
    else
        warndlg('δѡ��·����','��ʾ')
    end
else
    set(handles.WaitBarPan,'title','��д��...���Ժ�')
    load([Pathname Filename(1:end-4) '.proj/result.mat'])
    load([Pathname Filename],'PicListBox*')
    T=size(List,1);
    for t=1:T
        B1='ǰ���Ƕ�';
        if exist(['R_' List{t,2}],'var')
            eval(['coverage=R_' List{t,2} '.coverage;'])
            if List{t,3}==0
                A2=List{t,1}(8:end);
                M=[{''},{B1};{A2},{coverage}];
            else
                eval(['A2=' List{t,2} '(:,1);'])
                m=size(coverage,1);
                M=[{''},{B1};A2,num2cell(coverage)];
            end
        else
            continue
        end
        xlswrite([pathname filename],M,List{t,1})
    end
    msgbox(['����ɹ�������' pathname '��'],'�ɹ�')
    set(handles.WaitBarPan,'title','�������')
end


% --------------------------------------------------------------------
function Language_Callback(hObject, eventdata, handles)
% hObject    handle to Language (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% -----------------------�л���Ӣ��ģʽ------------------------------
function English_Callback(hObject, eventdata, handles)
% hObject    handle to English (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Language='English';
save('C:\Logs\CAFLang.mat','Language')

set(handles.File,'Label','File')
    set(handles.FileNew,'Label','New project')
    set(handles.FileOpen,'Label','Open project')
set(handles.Pic,'Label','Image')
    set(handles.PicRead,'Label','Add image')
    %set(handles.PicClass,'Label','Image classification')
    set(handles.PicNoise,'Label','Image denoising')
set(handles.Tree,'Label','Classification model')
    set(handles.TreeProd,'Label','Classification model generation')
        set(handles.TreeTraining,'Label','Classification model training')
            set(handles.TreeTrainPic,'Label','Load training pictures')
            set(handles.TreeTrainSelect,'Label','Manual selection')
        set(handles.TreeOpen,'Label','Classification model load')
    set(handles.TreeApply,'Label','Classification model application')
        set(handles.TreeApplyOne,'Label','Current chunk classification')
        set(handles.TreeApplyAll,'Label','All chunks classification')
set(handles.Calcu,'Label','Calculation')
    set(handles.Calcu_Coverage,'Label','Foreground coverage')
set(handles.Output,'Label','Output')
    set(handles.Output_2,'Label','Output two valued graph')
    set(handles.Output_front,'Label','Output foreground graph')
    set(handles.Output_calcu,'Label','Output calculated results')
    
set(handles.AddPar,'Label','Add a chunk')
set(handles.DeletePar,'Label','Delete the chunk')
set(handles.AddPic,'Label','Add a image')
set(handles.DeletePic,'Label','Delete the image')

set(handles.WorkPan,'title','Workspace Panel')
set(handles.PicCtrlPan,'title','Images Contrl Panel')
set(handles.DataPan,'title','Data Calculation Panel')
set(handles.WaitBarPan,'title','Waitbar Panel')
set(handles.EagleEye,'string','Eagle Eye Enlarge')
set(handles.text4,'string','Hold the left to drag')
set(handles.Cancel,'string','Cancel')
set(handles.Confirm,'string','Select training set')
set(handles.text6,'string','Coverage')
set(handles.TreeTrainConfirm,'string','Build model')

str='<html><div align="center"><b>Instructions</b></div><br><hr>��Left�� Select foreground</hr></br><br>��right�� Select Background</br><br>��Dblclick�� Clear trail</br></html>';
set(handles.text1,'string',str)

% -------------------------�л�������-----------------------------
function SimpChinese_Callback(hObject, eventdata, handles)
% hObject    handle to SimpChinese (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete('C:\Logs\CAFLang.mat')

set(handles.File,'Label','�ļ�')
    set(handles.FileNew,'Label','�½���Ŀ')
    set(handles.FileOpen,'Label','����Ŀ')
set(handles.Pic,'Label','ͼ��')
    set(handles.PicRead,'Label','���ͼ��')
    %set(handles.PicClass,'Label','ͼ�����')
    set(handles.PicNoise,'Label','ͼ��ȥ��')
set(handles.Tree,'Label','����ģ��')
    set(handles.TreeProd,'Label','����������')
        set(handles.TreeTraining,'Label','ѵ��')
            set(handles.TreeTrainPic,'Label','����ѵ��ͼƬ')
            set(handles.TreeTrainSelect,'Label','ͼ���ֶ�ѡ��')
        set(handles.TreeOpen,'Label','�������ģ��')
    set(handles.TreeApply,'Label','����ģ��Ӧ��')
        set(handles.TreeApplyOne,'Label','���൱ǰ����')
        set(handles.TreeApplyAll,'Label','������������')
set(handles.Calcu,'Label','���ݼ���')
    set(handles.Calcu_Coverage,'Label','ǰ���Ƕ�')
set(handles.Output,'Label','����')
    set(handles.Output_2,'Label','��ֵͼ����')
    set(handles.Output_front,'Label','ǰ��ͼ����')
    set(handles.Output_calcu,'Label','����������')
    
set(handles.AddPar,'Label','�������')
set(handles.DeletePar,'Label','ɾ������')
set(handles.AddPic,'Label','���ͼƬ')
set(handles.DeletePic,'Label','ɾ��ͼƬ')

set(handles.WorkPan,'title','������')
set(handles.PicCtrlPan,'title','ͼ��������')
set(handles.DataPan,'title','���ݼ������')
set(handles.WaitBarPan,'title','�������')
set(handles.EagleEye,'string','ӥ�۷Ŵ�')
set(handles.text4,'string','��ס����϶�')
set(handles.Cancel,'string','ȡ��')
set(handles.Confirm,'string','ѡ��ѵ����')
set(handles.text6,'string','ͼ��Ƕ�')
set(handles.TreeTrainConfirm,'string','ѵ������ģ��')

str='<html><div align="center"><b>����˵��</b></div><br><hr>������� ѡȡǰ��ɫ</hr></br><br>���Ҽ��� ѡȡ����ɫ</br><br>��˫���� �����ѡ��</br></html>';
set(handles.text1,'string',str)



function Cover_Callback(hObject, eventdata, handles)
% hObject    handle to Cover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cover as text
%        str2double(get(hObject,'String')) returns contents of Cover as a double


% --- Executes during object creation, after setting all properties.
function Cover_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
