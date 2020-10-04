function [Slice,Name_tif,path_save,pic,a,b,c,d,X,Y]=SlicePic( filename,pathname,width,height,File,Path)
%====================切割图像======================
%图片选取
%[filename,pathname]=uigetfile('*.tif','选取要分片的图片');
path=[pathname filename];
%图像读取
pic=imread(path);
%新建存放分片后图像文件夹
path_save=[Path File(1:end-4) '.proj\' filename(1:end-4) datestr(now,'yyyymmddHHMMSS')];
if ~exist(path_save,'dir')
    mkdir(path_save);
    %mkdir([path_save '\' filename(1:end-4)])
else
    answer=questdlg([filename '存在重名图片，是否为同一图片？'],'警告','是','否','是');
    if strcmp(answer,'是')
        cmd_rmdir(path_save);
        mkdir(path_save);
        %mkdir([path_save '\' filename(1:end-4)])
    else
        path_save=[path_save '=_='];
        mkdir(path_save);
    end
end
%获取图像大小
size_x=size(pic,2);
size_y=size(pic,1);
%获取切割份数
%size_slice=inputdlg({'请输入横向份数','请输入纵向份数'});
%X=str2double(size_slice{1,1});
%Y=str2double(size_slice{2,1});
X=ceil(width/2000);Y=ceil(height/2000);
%如果切割份数是数字，进行切割点的计算
if ~isnan(X) && ~isnan(Y)
    num_x=floor(size_x/X);
    num_y=floor(size_y/Y);
    %计算纵向的切割坐标点（matlab默认列为1）
    Slice_X=zeros(X,2);
    for i=1:X
        Slice_X(i,1)=(i-1)*num_x+1;
        Slice_X(i,2)=i*num_x;
    end
    Slice_X(X,2)=size_x;
    %计算横向的切割坐标点
    Slice_Y=zeros(Y,2);
    for i=1:Y
        Slice_Y(i,1)=(i-1)*num_y+1;
        Slice_Y(i,2)=i*num_y;
    end
    Slice_Y(Y,2)=size_y;
    %切割点总表
    Slice=zeros(X*Y,4);
    Name=cell(X*Y,1);
    Name_tif=cell(X*Y,1);
    for i=1:X
        for j=1:Y
            Slice((i-1)*Y+j,1:2)=Slice_X(i,:);
            Slice((i-1)*Y+j,3:4)=Slice_Y(j,:);
            %[x0,x1,y0,y1]
            Name{(i-1)*Y+j,1}=[num2str(j) '_' num2str(i)];
            Name_tif{(i-1)*Y+j,1}=[num2str(j) '_' num2str(i) filename(end-3:end)];
        end
    end
else
    warndlg('切片数量设置不合法，无法进行下一步！')
    return
end
%图像分割
a=Slice(:,1);
b=Slice(:,2);
c=Slice(:,3);
d=Slice(:,4);
%for k=1:X*Y
    %pic_draw=pic(a(k):b(k),c(k):d(k),:);
    %imwrite(pic_draw,[path_save '\' Name{k,1} '.tif'],'tif')
%end
preview=imresize(pic,sqrt(1000000/(height*width)));
preview=preview(:,:,1:3);
imwrite(preview,[path_save '\preview.tif'],'tif');