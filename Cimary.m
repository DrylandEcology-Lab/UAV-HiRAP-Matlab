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

%------------------------按下鼠标的反应-----------------------------
function Cimary_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Cimary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global List
%======如果用户打开了手动选点功能======
if strcmp(get(handles.PicCtrlPan,'visible'),'on')
    %===如果用户点击了【鹰眼放大】===
    if get(handles.EagleEye,'value')==1
        %获取预览面板的边界
        XLim=get(handles.axes1,'XLim');
        YLim=get(handles.axes1,'YLim');
        pos=get(handles.axes1,'currentpoint');%获得鼠标所在位置
        %------如果鼠标所在位置位于预览面板之内------
        if (pos(1,1)>XLim(1)) && (pos(1,1)<XLim(2)) && (pos(1,2)>YLim(1)) && (pos(1,2)<YLim(2))
            if strcmp(get(gcf,'selectiontype'),'normal')%如果是单击
                par=get(handles.ParListBox,'value');
                %如果目前选中了小图区块
                if List{par,3}==1
                    pos=get(handles.axes1,'currentpoint');
                    setappdata(hObject,'isPressed',true);%传递给【鼠标移动】函数，用户按下了左键，开始放大
                    set(hObject,'Userdata',pos(1,[1,2]));%传递鼠标起始的坐标
                %如果选中了大图区块
                else
                    setappdata(hObject,'isPressed',true);%传递给【鼠标移动】函数，用户按下了左键，开始放大
                end
            end
        end
    end
    %======获取绘图面板的边界和鼠标位置======
    XLim2=get(handles.axes2,'XLim');
    YLim2=get(handles.axes2,'YLim');
    pos2=get(handles.axes2,'currentpoint');
    %======如果鼠标在绘图面板之上======
    if (pos2(1,1)>XLim2(1)) && (pos2(1,1)<XLim2(2)) && (pos2(1,2)>YLim2(1)) && (pos2(1,2)<YLim2(2))
        %------如果用户双击鼠标，则清除所有的轨迹------
        if strcmp(get(gcf,'selectiontype'),'open')
            delete(findobj('type','line','parent',handles.axes2))
            set(handles.Confirm,'enable','off')
        else
            set(handles.text1,'Userdata',1)%传递给【鼠标移动】函数，用户开始画线了
            set(handles.axes2,'Userdata',pos2(1,[1,2]))
        end
    end
end

% --- Executes on mouse motion over figure - except title and menu.

%--------------------------鼠标移动的反应-------------------------------
function Cimary_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to Cimary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename Pathname List picpos f
%======如果用户打开了手动选点功能======
if strcmp(get(handles.PicCtrlPan,'visible'),'on')
    %===如果用户点击了【鹰眼放大】===
    if get(handles.EagleEye,'value')==1
        %------如果鼠标在预览面板上------
        XLim=get(handles.axes1,'XLim');
        YLim=get(handles.axes1,'YLim');
        pos=get(handles.axes1,'currentpoint');
        if (pos(1,1)>XLim(1)) && (pos(1,1)<XLim(2)) && (pos(1,2)>YLim(1)) && (pos(1,2)<YLim(2))
            load([Pathname Filename],'PicListBox*')
            par=get(handles.ParListBox,'value');
            %------如果预览面板是小图区块（可以任意放大）------
            if List{par,3}==1
                set(handles.Cimary,'pointer','cross')
                isPressed=getappdata(hObject,'isPressed');
                if isPressed%如果用户之前已经按下了左键
                    delete(findobj('type','line','parent',handles.axes1))
                    pos=get(handles.axes1,'currentpoint');
                    pos1=get(hObject,'Userdata');
                    x0=pos1(1,1);y0=pos1(1,2);x1=pos(1,1);y1=pos(1,2);
                    Xi=min(x0,x1);Xa=max(x0,x1);Yi=min(y0,y1);Ya=max(y0,y1);
                    x=[Xi,Xa,Xa,Xi,Xi];
                    y=[Yi,Yi,Ya,Ya,Yi];
                    hold on
                    plot(x,y,'r','linewidth',4)%绘制矩形
                    hold off
                    set(handles.axes2,'Userdata',[Xi,Yi,Xa,Ya])%传递矩形顶点坐标
                end
            %------如果预览面板是大图区块（不可以任意放大，把切好的小图放大显示出来）------    
            else
                set(handles.Cimary,'pointer','hand')%变鼠标形状为手型，画出鼠标所在小图的矩形轮廓
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
        %======如果鼠标不在预览面板上，那么指针就变成默认======    
        else
            set(handles.Cimary,'pointer','default')
        end
    end
    XLim2=get(handles.axes2,'XLim');
    YLim2=get(handles.axes2,'YLim');
    pos_now=get(handles.axes2,'currentpoint');
    %======如果鼠标在绘图面板上======
    if (pos_now(1,1)>XLim2(1)) && (pos_now(1,1)<XLim2(2)) && (pos_now(1,2)>YLim2(1)) && (pos_now(1,2)<YLim2(2))
        pos_mouse0=get(handles.axes2,'Userdata');
        isPressed=get(handles.text1,'Userdata');
        %------如果之前有按下鼠标------
        if isPressed==1
            if strcmp(get(gcf,'selectiontype'),'normal')
                color='g';%左键是绿色
            end
            if strcmp(get(gcf,'selectiontype'),'alt')
                color='b';%右键是蓝色
            end
            line([pos_mouse0(1);pos_now(1,1)],[pos_mouse0(2),pos_now(1,2)],'linewidth',3,'color',color)
            set(handles.axes2,'Userdata',pos_now(1,[1,2]))
            blue_0=findobj('type','line','parent',handles.axes2,'-and','Color','blue','parent',handles.axes2);
            green_1=findobj('type','line','parent',handles.axes2,'-and','Color','green','parent',handles.axes2);
            size0=size(blue_0,1);
            size1=size(green_1,1);
            %如果蓝色绿色出墨迹都有，那么就激活选取确认按钮
            if size0*size1>0
                set(handles.Confirm,'enable','on')
            end
        end
    end
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.

%--------------------------鼠标抬起的反应--------------------------------
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
    button=questdlg('Are you sure you want to quit？','Exit','Yes','No','Yes');
    if strcmp(button,'Yes')
        delete(hObject);
    end;
else
    button=questdlg('你确定退出吗？','退出程序','确定','取消','确定');
    if strcmp(button,'确定')
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
set(javaFrame,'FigureIcon',javax.swing.ImageIcon('.\林科院院徽.png'))

% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%-----------------------------新建项目--------------------------------
function FileNew_Callback(hObject, eventdata, handles)
% hObject    handle to FileNew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename Pathname List
if exist('C:\Logs\CAFLang.mat','file')%语言切换
    [filename,pathname]=uiputfile('CAF.mat','Please select the project folder and project name');
else
    [filename,pathname]=uiputfile('CAF.mat','请选择项目存放文件夹及项目名');
end
if ~isnumeric(filename)%如果输入了正确的文件名及路径
    Filename=filename;
    Pathname=pathname;
    Howcanoe='I Love Cimary';
    PicListNum=1;
    List=cell(1,4);
    List{1,4}=NewParStruct;
    save([Pathname Filename],'Filename','Pathname','Howcanoe','List','PicListNum')
    %激活下一步的按钮及文件
    set(handles.Cimary,'Name',Filename(1:end-4))
    set(handles.ParListBox,'string',{''})
    set(handles.PicListBox,'string',{''})
    set(handles.ParListBox,'value',1)
    set(handles.PicListBox,'value',1)
    set(handles.PicListBox,'visible','on')
    cla(handles.axes1)
    cla(handles.axes2)
    OnOff%激活
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


% ---------------------------打开项目------------------------------
function FileOpen_Callback(hObject, eventdata, handles)
% hObject    handle to FileOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename Pathname List
if exist('C:\Logs\CAFLang.mat','file')%语言切换
    [filename,pathname]=uigetfile('*.mat','Please select the project file');
else
    [filename,pathname]=uigetfile('*.mat','请选择项目文件');
end
if ~isnumeric(filename)%如果路径正确
    Filename=filename;
    Pathname=pathname;
    load([Pathname Filename])
    if exist('Howcanoe','var') && strcmp(Howcanoe,'I Love Cimary')%如果是cimary项目文件
        if exist([Pathname Filename(1:end-4) '.proj'],'dir')
            h1=findobj(handles.axes3,'visible','off');
            set(h1,'visible','on');
            mywaitbar(0,'Please Wait...',handles.axes3,handles.Cimary);
            set(handles.Cimary,'name',Filename(1:end-4))
            set(handles.ParListBox,'value',1)
            set(handles.ParListBox,'value',1)
            if isempty(List{1,1})%还原默认
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
                warndlg('.proj项目数据损坏或不存在，无法加载数据')
            end
        end
        mywaitbar(1,'Please Wait...',handles.axes3,handles.Cimary);
        if exist('C:\Logs\CAFLang.mat','file')
            set(handles.WaitBarPan,'title','Done')
        else
            set(handles.WaitBarPan,'title','打开完毕')
        end
    else
        if exist('C:\Logs\CAFLang.mat','file')
            warndlg('Non-project file！','Warning')
        else
            warndlg('非项目文件！','警告')
        end
    end
end

% --------------------------------------------------------------------
function Pic_Callback(hObject, eventdata, handles)
% hObject    handle to Pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% -----------------------------添加图像-----------------------------
function PicRead_Callback(hObject, eventdata, handles)
% hObject    handle to PicRead (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 【name】为不切割图片索引；【slice】为切割图片索引
global Filename Pathname List Text
if exist('C:\Logs\CAFLang.mat','file')%语言切换
    [Text.f3,Text.p3]=uigetfile({'*.tif;*.png;*.jpg;*.tiff'},'Please select a picture to classifing.','multiselect','on');
else
    [Text.f3,Text.p3]=uigetfile({'*.tif;*.png;*.jpg;*.tiff'},'请选取要分类的图片','multiselect','on');
end
if ~isnumeric(Text.p3)%如果路径正确
    load([Pathname Filename],'PicList*')
    set(handles.WaitBarPan,'title','图片加载中')
    par=get(handles.ParListBox,'value');
    %======如果一次选取了多张图片======
    if iscell(Text.f3)%Text.f为图片的文件名，如果选择是多选，那么他的格式是cell，如果是单选，他的格式就是char
        S=size(Text.f3,2);
        info=cell(S,1);
        msg=zeros(S,1);
        for i=1:S
            info{i,1}= imfinfo([Text.p3 Text.f3{1,i}]);
            %如果图片过大，则把过大的图片标记出来
            if info{i,1}.Height*info{i,1}.Width>4000000 || info{i,1}.FileSize>1024*1024*100
                msg(i)=1;
            end
        end
        selectall=find(msg==1);%记录过大图片的索引，在下面的多选提示中先把他选中，方便用户直接按确定
        index=Text.f3(msg==1);%记录过大图片的文件名
        %--------如果存在大图片，提示要不要切割，以及让用户选择要切割的图片---------
        if size(index,2)>0%过大文件名索引index有内容，即存在过大图片
            if exist('C:\Logs\CAFLang.mat','file')%语言切换
                [sel,ok]=listdlg('Liststring',index,'name','提示','Promptstring',...
                'Thees images are too large, will be sliced in order to improve the calculation speed',selectall','listsize',[400 250]);
            else
            [sel,ok]=listdlg('Liststring',index,'name','提示','Promptstring',...
                '以下图片体积过大，将进行分片处理以提高计算速度','okstring',...
                '确定','cancelstring','取消','InitialValue',selectall','listsize',[400 250]);
            end
            if ok==0%如果按了取消
                name=index';%把之前提取出来的切割图片索引index还原到不切割文件索引name里面
            else%如果确定，则把选中的图片索引记录下来
                slice=index(sel)';%切割文件名silce=大图片名
                index(:,sel)=[];%从索引中删除上述图片名
                name=index';%把剩下的图片归类到不切割图片索引name里面
                if size(name,1)==0%如果所有的图片都要分割
                    clear name%清空不切割图片索引name
                end
            end
        %-----------如果不存在大图片----------    
        else
            name=Text.f3';%不切割文件名就等于导入的所有文件名
        end
    %======如果只选取了一张图片片=======   
    else
        info=imfinfo([Text.p3 Text.f3]);
        %------如果图片过大------
        if info.Height*info.Width>4000000 || info.FileSize>1024*1024*100
            if exist('C:\Logs\CAFLang.mat','file')%语言转换
                [~,ok]=listdlg('Liststring',Text.f3,'name','提示','Promptstring',...
                    'Thees images are too large, will be sliced in order to improve the calculation speed','okstring',...
                    '确定','cancelstring','取消','listsize',[400 250]);
            else
                [~,ok]=listdlg('Liststring',Text.f3,'name','提示','Promptstring',...
                    '以下图片体积过大，将进行分片处理以提高计算速度','okstring',...
                    '确定','cancelstring','取消','listsize',[400 250]);
            end
            if ok==0%如果按了取消
                name=Text.f3;%不切割文件名就是导入的文件名
            else%如果按了确定
                slice=cellstr(Text.f3);%切割文件名就是导入的文件名
            end
        %------如果图片不大------    
        else
            name=Text.f3;%不切割文件名就是导入的文件名
        end
    end
    clear i index msg ok S i sel selectall%打扫干净屋子在干下一步
    %======如果存在不切割的图片索引，则把这些图片放置到列表中======
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
    %======如果存在切割文件索引======
    if exist('slice','var')
        %【mywaitbar】
        h1=findobj(handles.axes3,'visible','off');
        set(h1,'visible','on');
        mywaitbar(0,'Please Wait...',handles.axes3,handles.Cimary);
        %【mywaitbar】
        S=size(slice,1);%确定循环次数
        for i=1:S
            num=size(List,1);
            if iscell(info)
                Info=info{i};
            else
                Info=info;
            end
            List{num+1,1}=['大图区块' num2str(PicListNum) ' ' slice{i,1}];
            List{num+1,2}=['PicListBox' num2str(PicListNum)];
            List{num+1,3}=0;
            List{num+1,4}=NewParStruct;
            eval([List{num+1,2} '=cell(1,2);'])
            List{num+1,4}.Tree=1;
            List{num+1,4}.Pic=1;
            List{num+1,4}.PicRead=1;            
            %======↓↓↓↓↓↓开始切割图片↓↓↓↓↓↓======
            T=(i-1)/S+0.25/S;
            set(handles.WaitBarPan,'title',['第' num2str(i) '张图像较大，请耐心等待'])
            mywaitbar(T,'',handles.axes3,handles.Cimary);
            [Slice.axes,Slice.name,Slice.path,pic,a,b,c,d,X,Y]=SlicePic(slice{i,1},Text.p3,Info.Width,Info.Height,Filename,Pathname);
            set(handles.WaitBarPan,'title',['正在分片第' num2str(i) '张图像'])
            for k=1:X*Y
                pic_draw=pic(c(k):d(k),a(k):b(k),:);
                imwrite(pic_draw,[Slice.path '\' Slice.name{k,1}],'tif')
                mywaitbar(T+0.75*k/(X*Y*S),'',handles.axes3,handles.Cimary);
            end
            pic=[];
            pic_draw=[];
            %======↑↑↑↑↑↑切割图案结束↑↑↑↑↑↑======
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
        set(handles.WaitBarPan,'title','加载完毕')
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

% ----------------------图像去噪（还在开发中^_^）-----------------------
function PicNoise_Callback(hObject, eventdata, handles)
% hObject    handle to PicNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Tree_Callback(hObject, eventdata, handles)
% hObject    handle to Tree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------导入分类模型---------------------------
function TreeOpen_Callback(hObject, eventdata, handles)
% hObject    handle to TreeOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
par=get(handles.ParListBox,'value');%获得目前选中第几个文件夹
if size(List,2)==5%如果已经存在决策树，询问用户要不要替换
    if ~isempty(List{par,5})
        if exist('C:\Logs\CAFLang.mat','file')
            answer=questdlg('Existed Classification model, replace？','提示','是Y','否N','是Y');
        else
            answer=questdlg('已存在分类模型，替换？','提示','是Y','否N','是Y');
        end
        if strcmp(answer,'否N')
            return
        end
    end
end
if exist('C:\Logs\CAFLang.mat','file')%语言切换
    [filename,pathname]=uigetfile('*.mat','Select the Classification model');
else
    [filename,pathname]=uigetfile('*.mat','选取分类模型');
end
if ~isnumeric(pathname)%如果路径正确，则导入决策树
    tree=[pathname filename];
    load(tree)
    if exist('Kind','var') && strcmp(Kind,'分类模型文件')
        msgbox('分类模型导入完成','提示')
        treename=['分类模型-' List{par,1} '.mat'];
        treepath=[Pathname Filename(1:end-4) '.proj\'];
        List{par,5}=[treepath treename];
        save([treepath treename],'Tree','Kind')
        List{par,4}.TreeApply=1;
        OnOff
        save([Pathname Filename],'-append','List')
    else
        if exist('C:\Logs\CAFLang.mat','file')
            warndlg('Non Classification model file！')
        else
            warndlg('非分类模型文件！','警告')
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

% ------------------------只分类当前区块-----------------------------
function TreeApplyOne_Callback(hObject, eventdata, handles)
% hObject    handle to TreeApplyOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
tic
load([Pathname Filename],'PicListBox*')
h1=findobj(handles.axes3,'visible','off');%获取按键1的可视化句柄
set(h1,'visible','on');%设置句柄为可见
mywaitbar(0,'',handles.axes3,handles.Cimary);
%获得选中了第几个文件夹和第几张图片
par=get(handles.ParListBox,'value');%par是左边的文件夹名
pic=get(handles.PicListBox,'value');%pic是右边的图片名
eval(['temp=' List{par,2} ';'])%获取该文件夹的储存变量
num=size(temp,1);%确定该文件夹中的图片数
Treepath=List{par,5};
Mask=cell(num,1);
Picpath=cell(num,1);
set(handles.WaitBarPan,'title','运算中，请稍后...')
set(handles.ParListBox,'enable','off')
for i=1:num
    Picpath{i,1}=[temp{i,2} temp{i,1}];
    mywaitbar(0.2*i/num,'',handles.axes3,handles.Cimary);
end
%======如果图片数量小于10个，那么没必要开并行======
if num<=10 %List{par,3}
    for i=1:num
        mask= GUITraining(Treepath,Picpath{i,1});
        Mask{i,1}=mask;
        mask=[];
        mywaitbar(0.2+0.2*i/num,'',handles.axes3,handles.Cimary);
    end
%======如果图片数量大于10个，那么开并行提速======    
else
    parfor i=1:num%并行计算
        mask= GUITraining(Treepath,Picpath{i,1});
        Mask{i,1}=mask;
        mask=[];
    end
end
T=toc;
mywaitbar(0.4,'',handles.axes3,handles.Cimary);
%======查看该文件夹区块的种类，如果是大图区块，即选中了大图片======
if List{par,3}==0
    eval(['Loca=' List{par,2} '{1,3};'])
    mask=false(Loca(end,4),Loca(end,2));%计算掩膜
    %把每一张小图片拼在一起，作为大图片的掩膜
    for i=1:num-1
        mask(Loca(i,3):Loca(i,4),Loca(i,1):Loca(i,2))=Mask{i+1,1};
        mywaitbar(0.4+0.6*i/(num-1),'',handles.axes3,handles.Cimary);
    end
    %计算覆盖度
    [coverage]=datacount(mask);
    %保存结果
    varname=['R_' List{par,2}];
    varpath=[Pathname Filename(1:end-4) '.proj\'];
    eval([varname '.mask=mask;'])
    eval([varname '.coverage=coverage;'])
    if exist([varpath 'result.mat'],'file')==0
        save([varpath 'result.mat'],varname)
    else
        save([varpath 'result.mat'],'-append',varname)
    end
%======查看该文件夹区块的种类，如果是小图区块======
else
    varname=['R_' List{par,2}];
    varpath=[Pathname Filename(1:end-4) '.proj\'];
    %计算覆盖度
    [coverage]=datacount(Mask);
    %保存结果
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
set(handles.WaitBarPan,'title',['分类完成，用时' num2str(T) '秒'])
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


% --------------------------分类所有区块---------------------------
function TreeApplyAll_Callback(hObject, eventdata, handles)
% hObject    handle to TreeApplyAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
load([Pathname Filename],'PicListBox*')
[cyclesize,iscycle]=size(List);
%如果存在决策树，则进行分类
if iscycle==5%因为决策树位于第五列，当没有决策树时，iscycle只有4列，判否
    t0=clock;%计时开始
    Name_select=List(:,1);
    Line_select=zeros(cyclesize,1);
    Num_select=0;
    for i=1:cyclesize
        if find(List{i,4}.TreeApply==1)==1%寻找具有决策树的区块
            Line_select(i,1)=1;%记录具有决策树的
            Num_select=Num_select+1;
        end
    end
    Name_select(Line_select==1,:)=[];%把具有决策树的排除，留下提醒用户没有决策树的忽略区块
    if size(Name_select)>0
        if exist('C:\Logs\CAFLang.mat','file')
            [~,~]=listdlg('Liststring',Name_select,'name','提示','Promptstring',...
                'The following picture does not have a Classification model, it will be skipped','listsize',[400 250]);
        else
            [~,~]=listdlg('Liststring',Name_select,'name','提示','Promptstring',...
                '以下图片没有分类模型，将跳过其分类模型分类','okstring',...
                '确定','cancelstring','取消','listsize',[400 250]);
        end
    end
    CalcuLine=find(Line_select==1);%需要计算的区块索引
    realsize=size(CalcuLine,1);%需要计算的区块数量
    h1=findobj(handles.axes3,'visible','off');%获取按键1的可视化句柄
    set(h1,'visible','on');%设置句柄为可见
    mywaitbar(0,'',handles.axes3,handles.Cimary);
    set(handles.ParListBox,'enable','off')%计算的时候不要让用户乱点，锁死界面
    T=0;
    %======循环计算每一个区块，后面的代码和【计算当前区块】的代码完全一致======
    for j=1:realsize
        mywaitbar((j-1)/realsize,'',handles.axes3,handles.Cimary);
        par=CalcuLine(j,1);
        eval(['temp=' List{par,2} ';'])
        num=size(temp,1);
        Treepath=List{par,5};
        Mask=cell(num,1);
        Picpath=cell(num,1);
        set(handles.WaitBarPan,'title',['正在运算[' List{par,1}(1:6) '] 上一区块用时' num2str(T) '秒'])
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
        %set(handles.WaitBarPan,'title',[List{par,1}(1:6) '用时' num2str(T) '秒'])
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
    set(handles.WaitBarPan,'title',['计算完成,总用时' num2str(Time) '秒'])
    clear PicListBox*
    OnOff
    ParListBox_Callback(hObject, eventdata, handles)
    Calcu_Coverage_Callback(hObject, eventdata, handles)
end


% --------------------------导入训练图片-----------------------------
function TreeTrainPic_Callback(hObject, eventdata, handles)
% hObject    handle to TreeTrainPic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
Size=size(List,2);%判断是不是已经存在分类模型了（分类模型储存在第五列）
par=get(handles.ParListBox,'value');
%======如果存在分类模型======
if Size==5
    if ~isempty(List{par,5})
        if exist('C:\Logs\CAFLang.mat','file')%语言切换
            answer=questdlg('Existed Classification model, replace？','提示','是Y','否N','是Y');
        else
            answer=questdlg('已存在分类模型，重新训练？','提示','是Y','否N','是Y');
        end
        if strcmp(answer,'否N')
            return%如果不重新训练，则程序终止
        end
    end
end
if exist('C:\Logs\CAFLang.mat','file')%语言切换
    uiwait(warndlg('First select【foreground】 image，then【background】 image','温馨提示'));
else
    uiwait(warndlg('请先选择【前景】图片，然后再选择【背景】图片','温馨提示'));
end
%选择训练图片
if exist('C:\Logs\CAFLang.mat','file')
    [Text.f1,Text.p1]=uigetfile({'*.tif;*.png;*.jpg;*.tiff'},'Select【foreground】image');
    [Text.f2,Text.p2]=uigetfile({'*.tif;*.png;*.jpg;*.tiff'},'Select【background】image');
else
    [Text.f1,Text.p1]=uigetfile({'*.tif;*.png;*.jpg;*.tiff'},'请选取【前景】图片');
    [Text.f2,Text.p2]=uigetfile({'*.tif;*.png;*.jpg;*.tiff'},'请选取【背景】图片');
end
%如果选取的图片不足，则程序终止
if isnumeric(Text.f1) || isnumeric(Text.f2)
    if exist('C:\Logs\CAFLang.mat','file')
        warndlg('Did not choose enough training images','提示')
    else
        warndlg('未选择足够训练素材，程序结束','提示')
    end
    return
end
Pic.veg=imread([Text.p1 Text.f1]);
Pic.back=imread([Text.p2 Text.f2]);
%图片转换成分类树训练格式文件
Pic.Back=pic2mat(Pic.back,1,0);%背景
Pic.Veg=pic2mat(Pic.veg,1,1');%前景
%生成标准的决策树训练文件
TreeSource.X=[Pic.Back.output;Pic.Veg.output];
TreeSource.Y=[Pic.Back.class;Pic.Veg.class];
%决策树训练
Tree=fitctree(TreeSource.X,TreeSource.Y,'predictornames',{'R' 'G' 'B' 'H' 'S' 'V' 'L' 'A*' 'B*' 'X' 'Y' 'Z'});
%axes(handles.axes1);
if exist('C:\Logs\CAFLang.mat','file')
    msgbox('Done')
else
    msgbox('分类模型训练完成','提示')
end
treename=['分类模型-' List{par,1} '.mat'];
treepath=[Pathname Filename(1:end-4) '.proj\'];
List{par,5}=[treepath treename];
Kind='分类模型文件';
%保存决策树
save([treepath treename],'Tree','Kind')
List{par,4}.TreeApply=1;
OnOff
save([Pathname Filename],'-append','List')


% ------------------------图上选点训练----------------------------
function TreeTrainSelect_Callback(hObject, eventdata, handles)
% hObject    handle to TreeTrainSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global List
Size=size(List,2);%判断是不是已经存在分类模型了（分类模型储存在第五列）
par=get(handles.ParListBox,'value');
if Size==5%如果存在分类模型
    if ~isempty(List{par,5})
        if exist('C:\Logs\CAFLang.mat','file')
            answer=questdlg('Existed Classification model, replace？','提示','是Y','否N','是Y');
        else
            answer=questdlg('已存在分类模型，重新训练？','提示','是Y','否N','是Y');
        end
        if strcmp(answer,'否N')
            return
        end
    end
end
set(handles.Cimary,'pointer','arrow')
set(handles.ParListBox,'enable','off')
set(handles.PicCtrlPan,'visible','on')%开启手动选点功能
set(handles.axes2,'box','on')
set(handles.EagleEye,'value',0)
set(handles.Confirm,'enable','off')
set(handles.TreeTrainConfirm,'enable','off')
set(handles.Pic,'enable','off')
set(handles.Tree,'enable','off')
%点击图片名，在预览区上显示图片
PicListBox_Callback(hObject, eventdata, handles)
if exist('C:\Logs\CAFLang.mat','file')
    str='<html><div align="center"><b>Instructions</b></div><br><hr>【Left】 Select foreground</hr></br><br>【right】 Select Background</br><br>【Dblclick】 Clear trail</br></html>';
else
    str='<html><div align="center"><b>操作说明</b></div><br><hr>【左键】 选取前景色</hr></br><br>【右键】 选取背景色</br><br>【双击】 清除所选点</br></html>';
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
    name=inputdlg('请输入区块名称','增加区块',[1 40]);
end
if ~isempty(name)
    load([Pathname Filename],'PicListNum')
    str_name=['小图区块' num2str(PicListNum) ' ' char(name)];
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
        answer=questdlg('This operation can not be restored, confirm delete？','警告','确认Y','取消N','取消N');
    else
        answer=questdlg('此操作不可恢复，确认删除？','警告','确认Y','取消N','取消N');
    end
    if strcmp(answer,'确认Y')
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

%-------------------点击图片名，在预览区上显示图片-------------------
function PicListBox_Callback(hObject, eventdata, handles)
% hObject    handle to ParListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ParListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ParListBox
global List Pathname Filename axes2pic
a=get(handles.PicListBox,'string');%获得目前选中的图片名
if ~strcmp(a{1,1},'')%如果图片名不是空的
    load([Pathname Filename],'PicListBox*')
    par=get(handles.ParListBox,'value');%获取是第几个文件夹
    pic=get(handles.PicListBox,'value');%获取是第几张图片
    if eval(['~isempty(' List{par,2} '{pic,2})'])%如果对应的文件夹和图片存在
        cla(handles.axes1)%清空旧图
        eval(['preview=imread([' List{par,2} '{pic,2} ' List{par,2} '{pic,1}]);'])%读取缩略图
        imshow(preview,'Parent',handles.axes1);%显示图片
        axes(handles.axes1)
        axis off
        %=======如果用户启用了手动选点功能======
        if strcmp(get(handles.PicCtrlPan,'visible'),'on')
            cla(handles.axes2)
            axes2pic=preview;
            imshow(axes2pic,'Parent',handles.axes2);
            set(handles.ZoomIn,'enable','off')
            set(handles.ZoomIn,'value',0)
            ZoomIn_Callback(hObject, eventdata, handles)%调用选点辅助放大功能
            set(handles.EagleEye,'value',0)
        %=======如果用户没有启用手动选点功能======
        else
            %------如果之前计算出来了覆盖度的结果，那么就显示黑白二值图以及覆盖度数值------
            if strcmp(get(handles.Calcu,'enable'),'on')
                R_name=['R_' List{par,2}];
                eval(['load([Pathname Filename(1:end-4) ''.proj/result.mat''],''' R_name ''')'])
                if List{par,3}==1
                    eval(['mask_show=' R_name '.mask{pic,1};']);
                else
                    eval(['mask_show=' R_name '.mask;']);
                end
                %imagesc(mask_show,'Parent',handles.axes2);
                Calcu_Coverage_Callback(hObject, eventdata, handles)%覆盖度数值
                imshow(mask_show,'Parent',handles.axes2);%显示黑白二值图
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
    msgbox('Select points done，please training dicision tree or select other points','提示')
else
    msgbox('训练点选择完毕，请进行分类模型训练或者继续选取别的图像上的点','提示')
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
        [sel,ok]=listdlg('Liststring',tree_list(:,1),'name','提示','Promptstring',...
            'Classification model training will be carried out using the following training set','InitialValue',selectall','listsize',[400 250]);
    else
        [sel,ok]=listdlg('Liststring',tree_list(:,1),'name','提示','Promptstring',...
            '将利用以下的训练集进行分类模型训练','okstring',...
            '确定','cancelstring','取消','InitialValue',selectall','listsize',[400 250]);
    end
    if ok==1
        tree_train=tree_list(sel,2:3);
        TreeSource.X=cell2mat(tree_train(:,1));
        TreeSource.Y=cell2mat(tree_train(:,2));
        Tree=fitctree(TreeSource.X,TreeSource.Y,'predictornames',{'R' 'G' 'B' 'H' 'S' 'V' 'L' 'A*' 'B*' 'X' 'Y' 'Z'});
        par=get(handles.ParListBox,'value');
        treename=['分类模型-' List{par,1} '.mat'];
        treepath=[Pathname Filename(1:end-4) '.proj\'];
        List{par,5}=[treepath treename];
        Kind='分类模型文件';
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
        uiwait(msgbox('分类模型训练完成','提示'))
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
    setAxesZoomMotion(h,handles.axes2,'both');%horizontal和vertical都放大
    zoom on
    setAllowAxesZoom(h,handles.axes1,false);
    setAllowAxesZoom(h,handles.axes3,false);
    set(h,'direction','in');
    if exist('C:\Logs\CAFLang.mat','file')
        set(handles.ZoomIn,'string','Select points')
    else
        set(handles.ZoomIn,'string','返回选点')
    end
else
    zoom off
    if exist('C:\Logs\CAFLang.mat','file')
        set(handles.ZoomIn,'string','Assistant amplification')
    else
        set(handles.ZoomIn,'string','选点辅助放大')
    end
end


% -------------------------计算植被覆盖度-----------------------------
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
if exist('C:\Logs\CAFLang.mat','file')%语言切换
    %msgbox(['The coverage of foreground is' num2str(answer*100) '%'],'结果')
    set(handles.Cover,'string',[num2str(answer*100) '%'])
else
    %msgbox(['该图片的前景盖度是' num2str(answer*100) '%'],'结果')
    set(handles.Cover,'string',[num2str(answer*100) '%'])
end


% --------------------------------------------------------------------
function Output_Callback(hObject, eventdata, handles)
% hObject    handle to Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% -----------------------二值图导出------------------------------
function Output_2_Callback(hObject, eventdata, handles)
% hObject    handle to Output_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
if exist('C:\Logs\CAFLang.mat','file')%语言转换
    [filename, pathname]=uiputfile('*.tif','Please select the save path of two value garph');
else
    [filename, pathname]=uiputfile('*.tif','请选择二值图保存路径');
end
%======如果用户按了取消======
if isnumeric(pathname)
    if exist('C:\Logs\CAFLang.mat','file')%语言转换
        warndlg('Canceled！')
    else
        warndlg('未选择路径！','提示')
    end
%======如果用户选定了合法的路径名======   
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
    msgbox(['二值图成功导出到' pathname '中'],'成功')
end

% ---------------------------导出前景图-------------------------------
function Output_front_Callback(hObject, eventdata, handles)
% hObject    handle to Output_front (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
if exist('C:\Logs\CAFLang.mat','file')
    [filename, pathname]=uiputfile('*.tif','Please select the save path of foreground garph');
else
    [filename, pathname]=uiputfile('*.tif','请选择前景图保存路径');
end
if isnumeric(pathname)
    if exist('C:\Logs\CAFLang.mat','file')
        warndlg('Canceled！')
    else
        warndlg('未选择路径！','提示')
    end
else
    set(handles.WaitBarPan,'title','读写中...请稍后')
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
    msgbox(['前景图成功导出到' pathname '中'],'成功')
    set(handles.WaitBarPan,'title','导出完成')
end



% -----------------------------导出盖度结果----------------------------
function Output_calcu_Callback(hObject, eventdata, handles)
% hObject    handle to Output_calcu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Pathname Filename List
if exist('C:\Logs\CAFLang.mat','file')
    [filename, pathname]=uiputfile('*.xls','Please select the save path of Excel');
else
    [filename, pathname]=uiputfile('*.xls','请选择结果excel保存路径');
end
if isnumeric(pathname)
    if exist('C:\Logs\CAFLang.mat','file')
        warndlg('Canceled！')
    else
        warndlg('未选择路径！','提示')
    end
else
    set(handles.WaitBarPan,'title','读写中...请稍后')
    load([Pathname Filename(1:end-4) '.proj/result.mat'])
    load([Pathname Filename],'PicListBox*')
    T=size(List,1);
    for t=1:T
        B1='前景盖度';
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
    msgbox(['结果成功导出到' pathname '中'],'成功')
    set(handles.WaitBarPan,'title','导出完成')
end


% --------------------------------------------------------------------
function Language_Callback(hObject, eventdata, handles)
% hObject    handle to Language (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% -----------------------切换到英语模式------------------------------
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

str='<html><div align="center"><b>Instructions</b></div><br><hr>【Left】 Select foreground</hr></br><br>【right】 Select Background</br><br>【Dblclick】 Clear trail</br></html>';
set(handles.text1,'string',str)

% -------------------------切换到中文-----------------------------
function SimpChinese_Callback(hObject, eventdata, handles)
% hObject    handle to SimpChinese (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete('C:\Logs\CAFLang.mat')

set(handles.File,'Label','文件')
    set(handles.FileNew,'Label','新建项目')
    set(handles.FileOpen,'Label','打开项目')
set(handles.Pic,'Label','图像')
    set(handles.PicRead,'Label','添加图像')
    %set(handles.PicClass,'Label','图像分类')
    set(handles.PicNoise,'Label','图像去噪')
set(handles.Tree,'Label','分类模型')
    set(handles.TreeProd,'Label','决策数生成')
        set(handles.TreeTraining,'Label','训练')
            set(handles.TreeTrainPic,'Label','导入训练图片')
            set(handles.TreeTrainSelect,'Label','图上手动选点')
        set(handles.TreeOpen,'Label','导入分类模型')
    set(handles.TreeApply,'Label','分类模型应用')
        set(handles.TreeApplyOne,'Label','分类当前区块')
        set(handles.TreeApplyAll,'Label','分类所有区块')
set(handles.Calcu,'Label','数据计算')
    set(handles.Calcu_Coverage,'Label','前景盖度')
set(handles.Output,'Label','导出')
    set(handles.Output_2,'Label','二值图导出')
    set(handles.Output_front,'Label','前景图导出')
    set(handles.Output_calcu,'Label','计算结果导出')
    
set(handles.AddPar,'Label','添加区块')
set(handles.DeletePar,'Label','删除区块')
set(handles.AddPic,'Label','添加图片')
set(handles.DeletePic,'Label','删除图片')

set(handles.WorkPan,'title','工作区')
set(handles.PicCtrlPan,'title','图像控制面板')
set(handles.DataPan,'title','数据计算面板')
set(handles.WaitBarPan,'title','处理进度')
set(handles.EagleEye,'string','鹰眼放大')
set(handles.text4,'string','按住左键拖动')
set(handles.Cancel,'string','取消')
set(handles.Confirm,'string','选择训练集')
set(handles.text6,'string','图像盖度')
set(handles.TreeTrainConfirm,'string','训练分类模型')

str='<html><div align="center"><b>操作说明</b></div><br><hr>【左键】 选取前景色</hr></br><br>【右键】 选取背景色</br><br>【双击】 清除所选点</br></html>';
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
