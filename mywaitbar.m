function mywaitbar(x,varargin)
%把原来默认的弹出式进度条，内嵌到界面里面
%example:
%h1=findobj(handles.axes3,'visible','off');%获取按键1的可视化句柄
%set(h1,'visible','on');%设置句柄为可见
%mywaitbar(0,'Please Wait...',handles.axes3,handles.Cimary);
%TheEndTime = 600; 
%for t = 1:TheEndTime
%       mywaitbar(t/TheEndTime,[num2str(floor(t*100/TheEndTime)),'%'],handles.axes3,handles.Cimary);
%end
if nargin < 1
    error('Input arguments not valid');
end
fh = varargin{end};
set(0,'CurrentFigure',fh);
%fAxes = findobj(fh,'type','axes');
fAxes =varargin{2};
set(fh,'CurrentAxes',fAxes);
if nargin > 1
    %hTitle = get(fAxes,'title');
    %set(hTitle,'String',varargin{1});
end
fractioninput = x;
x = max(0,min(100*x,100));
if fractioninput == 0    
    cla
    xpatch = [0 x x 0];
    ypatch = [0 0 1 1];
    xline = [100 0 0 100 100];
    yline = [0 0 1 1 0];
    patch(xpatch,ypatch,'b','EdgeColor','b');
    set(fh,'UserData',fractioninput);
    l = line(xline,yline);
    set(l,'Color',get(gca,'XColor'));   
else
    p = findobj(fh,'Type','patch');
    l = findobj(fh,'Type','line');
    if (get(fh,'UserData') > fractioninput)
        set(p);
    end
    xpatch = [0 x x 0];
    set(p,'XData',xpatch);
    xline = get(l,'XData');
    if iscell(xline)
        set(l,'XData',xline{end,1});
    else
        set(l,'XData',xline);
    end
end
drawnow;
axis off