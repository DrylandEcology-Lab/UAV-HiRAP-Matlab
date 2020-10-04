function [ image_output ] = maskcover( image,mask )
%应用掩膜文件，去除背景彩色像素，转为黑色RGB=[0,0,0]，保留植物彩色像素
%[输出图像（double类型）]=maskcover[图像，掩膜]
%图像为M*N*I（I一般为3）的图像，double和unit8都行，掩膜为M*N的由0,1组成的矩阵
image_output=double(image);
I=size(image,3);
for i=1:I
    image_output(:,:,i)=image_output(:,:,i).*mask;%掩膜为0或1，相乘0则去除，1则保留
end
end

