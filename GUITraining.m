function [ Mask ] = GUITraining( Treepath,Picpath)
%����ͼƬ��Picpath����ѵ���õľ�������Treepath������ͼ����з��࣬���ɺڰ׶�ֵͼ����Ĥmask�ļ�
%PicΪͼƬ���ڵ�·��+�ļ���
%TreeΪ�������ļ�.mat���ڵ�·��+�ļ���
load(Treepath,'Tree')%���ؾ�����
Pic.target=imread(Picpath);%����ͼ��
Pic.Target=pic2mat(Pic.target,0);%M-N-3����άͼ�����תΪ��M*N��-3�Ķ�ά�������������
[m,n,~]=size(Pic.target);
Classified=predict(Tree,Pic.Target.output);%������Ӧ�ã�����ʸ������0,1��ɵ�double�ͣ�
%row=find(Classified==0);
%Mask=true(size(Pic.target,1),size(Pic.target,2));
mask=reshape(Classified,m,n);%��һάʸ������תΪ��ͼ��һ���Ķ�ά����double��
Mask=im2bw(mask);%��2ά����double������mask��Ĥ�ļ���logical��
%S=size(row,1);
%for i=1:S
    %Mask(Pic.Target.index(row(i),1),Pic.Target.index(row(i),2))=false;
%end
%Picture=maskcover(Pic.target,Mask);
%image(uint8(Picture),'Parent',handles.axes1)

%==ȥ�빤��==
Mask = bwmorph(Mask,'open');%���������ȸ�ʴ�����͵Ĺ��̣���������ͼ����ϸС����������ƽ������߽硣
%������ʱ�����ͺ�ʴ�Ĺ��̣��������������ϸС�Ŀն�����ƽ������߽硣
Mask = bwmorph(Mask,'clean'); %'clean'��ȥ��ͼ���й��������㣬���磬 һ�����ص㣬����Χ���ص�����ֵȫΪ0
end

