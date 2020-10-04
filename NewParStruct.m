function [out]=NewParStruct
%新建项目时，把之前已经激活的选项给关闭，防止用户误点
out.Pic=0;
%out.PicRead=0;
out.WorkPan=1;
out.PicNoise=0;
out.Tree=0;
%out.TreeOpen=1;
out.TreeApply=0;
out.PicCtrlPan=0;
out.Calcu=0;
out.DataPan=0;
out.Output=0;
end