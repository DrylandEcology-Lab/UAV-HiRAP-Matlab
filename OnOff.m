%设置选项卡的激活情况，防止用户误点
i=get(handles.ParListBox,'value');
if List{i,3}==0
    set(handles.PicListBox,'visible','off')
    set(handles.PicRead,'enable','off')
end
if List{i,3}==1
    set(handles.PicListBox,'visible','on')
    set(handles.PicRead,'enable','on')
end
onoff=List{i,4};
if onoff.Pic==0
    set(handles.Pic,'enable','off')
else
    set(handles.Pic,'enable','on')
end
if onoff.WorkPan==0
    set(handles.WorkPan,'visible','off')
    set(handles.WaitBarPan,'visible','off')
else
    set(handles.WorkPan,'visible','on')
    set(handles.WaitBarPan,'visible','on')
end
%if onoff.PicRead==0
   % set(handles.PicRead,'enable','off')
%else
    %set(handles.PicRead,'enable','on')
%end
if onoff.PicNoise==0
    set(handles.PicNoise,'enable','off')
else
    set(handles.PicNoise,'enable','on')
end
if onoff.Tree==0
    set(handles.Tree,'enable','off')
else
    set(handles.Tree,'enable','on')
end
if onoff.TreeApply==0
    set(handles.TreeApply,'enable','off')
else
    set(handles.TreeApply,'enable','on')
end
if onoff.PicCtrlPan==0
    set(handles.PicCtrlPan,'visible','off')
else
    set(handles.PicCtrlPan,'visible','on')
end
if onoff.Calcu==0
    set(handles.Calcu,'enable','off')
else
    set(handles.Calcu,'enable','on')
end
if onoff.DataPan==0
    set(handles.DataPan,'visible','off')
else
    set(handles.DataPan,'visible','on')
end
if onoff.Output==0
    set(handles.Output,'enable','off')
else
    set(handles.Output,'enable','on')
end