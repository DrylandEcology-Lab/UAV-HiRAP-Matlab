function [Output] = pic2mat( Input,Kind,class_name)
%M-N-3����άͼ�����תΪ��M*N��-3�Ķ�ά�������������
%[���]=pic2mat(����ͼ��ͼ�����࣬��������)
%����ĸ�ʽΪM*N*3��ͼ�����
%��KindΪ1ʱ�������ͼƬ��ѵ���õ�ͼƬ����Ҫɾ����Ч�Ŀհ������Լӿ�ѵ���ٶ�
%��KindΪ0ʱ�������ͼƬ�Ƿ����õ�ͼƬ�������е����ص㶼Ҫ���ǽ������з��࣬�����������ļ��Ա���������Mask
%Ϊ����ߺ��������ٶȣ�class_name��������������ʾ
Input=Input(:,:,1:3);
[m,n,~]=size(Input);
Input_hsv=rgb2hsv(Input);
Input_lab=rgb2lab(Input);
Input_xyz=rgb2xyz(Input);
Input=double(Input);
%x=size(Input,2);
%y=size(Input,1);
%Output.index=zeros(x*y,2);
rgb=reshape(Input,m*n,3);
hsv=reshape(Input_hsv,m*n,3);
lab=reshape(Input_lab,m*n,3);
xyz=reshape(Input_xyz,m*n,3);
Output.output=[rgb hsv lab xyz];
%for i=1:x
    %for j=1:y
        %Output.output((i-1)*y+j,1)=Input(i,j,1);
        %Output.output((i-1)*y+j,2)=Input(i,j,2);
        %Output.output((i-1)*y+j,3)=Input(i,j,3);
        %Output.output((i-1)*y+j,4)=Input_hsv(i,j,1);
        %Output.output((i-1)*y+j,5)=Input_hsv(i,j,2);
        %Output.output((i-1)*y+j,6)=Input_hsv(i,j,3);
        %Output.output((i-1)*y+j,7)=Input_lab(i,j,1);
        %Output.output((i-1)*y+j,8)=Input_lab(i,j,2);
        %Output.output((i-1)*y+j,9)=Input_lab(i,j,3);
        %Output.output((i-1)*y+j,10)=Input_xyz(i,j,1);
        %Output.output((i-1)*y+j,11)=Input_xyz(i,j,2);
        %Output.output((i-1)*y+j,12)=Input_xyz(i,j,3);
        %Output.output((i-1)*y+j,1:12)=a;
        %Output.index((i-1)*y+j,1)=j;
        %Output.index((i-1)*y+j,2)=i;
    %end
%end
if Kind==1
    Delete=sum(Output.output,2);
    A= Delete==0;
    Output.output(A,:)=[];
    %Output=rmfield(Output,'index');
end
if nargin==3
    if isnumeric(class_name)
        Output.class=inf(size(Output.output,1),1);
        Output.class(1:end,1)=class_name;
    else
        Output.class=cell(size(Output.output,1),1);
        Output.class(1:end,1)={class_name};
    end
end
end