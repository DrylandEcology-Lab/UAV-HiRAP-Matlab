function [ image_output ] = maskcover( image,mask )
%Ӧ����Ĥ�ļ���ȥ��������ɫ���أ�תΪ��ɫRGB=[0,0,0]������ֲ���ɫ����
%[���ͼ��double���ͣ�]=maskcover[ͼ����Ĥ]
%ͼ��ΪM*N*I��Iһ��Ϊ3����ͼ��double��unit8���У���ĤΪM*N����0,1��ɵľ���
image_output=double(image);
I=size(image,3);
for i=1:I
    image_output(:,:,i)=image_output(:,:,i).*mask;%��ĤΪ0��1�����0��ȥ����1����
end
end

