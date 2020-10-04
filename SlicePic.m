function [Slice,Name_tif,path_save,pic,a,b,c,d,X,Y]=SlicePic( filename,pathname,width,height,File,Path)
%====================�и�ͼ��======================
%ͼƬѡȡ
%[filename,pathname]=uigetfile('*.tif','ѡȡҪ��Ƭ��ͼƬ');
path=[pathname filename];
%ͼ���ȡ
pic=imread(path);
%�½���ŷ�Ƭ��ͼ���ļ���
path_save=[Path File(1:end-4) '.proj\' filename(1:end-4) datestr(now,'yyyymmddHHMMSS')];
if ~exist(path_save,'dir')
    mkdir(path_save);
    %mkdir([path_save '\' filename(1:end-4)])
else
    answer=questdlg([filename '��������ͼƬ���Ƿ�ΪͬһͼƬ��'],'����','��','��','��');
    if strcmp(answer,'��')
        cmd_rmdir(path_save);
        mkdir(path_save);
        %mkdir([path_save '\' filename(1:end-4)])
    else
        path_save=[path_save '=_='];
        mkdir(path_save);
    end
end
%��ȡͼ���С
size_x=size(pic,2);
size_y=size(pic,1);
%��ȡ�и����
%size_slice=inputdlg({'������������','�������������'});
%X=str2double(size_slice{1,1});
%Y=str2double(size_slice{2,1});
X=ceil(width/2000);Y=ceil(height/2000);
%����и���������֣������и��ļ���
if ~isnan(X) && ~isnan(Y)
    num_x=floor(size_x/X);
    num_y=floor(size_y/Y);
    %����������и�����㣨matlabĬ����Ϊ1��
    Slice_X=zeros(X,2);
    for i=1:X
        Slice_X(i,1)=(i-1)*num_x+1;
        Slice_X(i,2)=i*num_x;
    end
    Slice_X(X,2)=size_x;
    %���������и������
    Slice_Y=zeros(Y,2);
    for i=1:Y
        Slice_Y(i,1)=(i-1)*num_y+1;
        Slice_Y(i,2)=i*num_y;
    end
    Slice_Y(Y,2)=size_y;
    %�и���ܱ�
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
    warndlg('��Ƭ�������ò��Ϸ����޷�������һ����')
    return
end
%ͼ��ָ�
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