function [ Mask ] = GUITraining( Treepath,Picpath)
%根据图片（Picpath）和训练好的决策树（Treepath），对图像进行分类，生成黑白二值图的掩膜mask文件
%Pic为图片所在的路径+文件名
%Tree为决策树文件.mat所在的路径+文件名
load(Treepath,'Tree')%加载决策树
Pic.target=imread(Picpath);%加载图像
Pic.Target=pic2mat(Pic.target,0);%M-N-3的三维图像矩阵转为（M*N）-3的二维决策树分类矩阵
[m,n,~]=size(Pic.target);
Classified=predict(Tree,Pic.Target.output);%决策树应用，生成矢量矩阵（0,1组成的double型）
%row=find(Classified==0);
%Mask=true(size(Pic.target,1),size(Pic.target,2));
mask=reshape(Classified,m,n);%把一维矢量矩阵转为和图像一样的二维矩阵（double）
Mask=im2bw(mask);%把2维矩阵（double）换成mask掩膜文件（logical）
%S=size(row,1);
%for i=1:S
    %Mask(Pic.Target.index(row(i),1),Pic.Target.index(row(i),2))=false;
%end
%Picture=maskcover(Pic.target,Mask);
%image(uint8(Picture),'Parent',handles.axes1)

%==去噪工作==
Mask = bwmorph(Mask,'open');%开运算是先腐蚀后膨胀的过程，可以消除图像上细小的噪声，并平滑物体边界。
%闭运算时先膨胀后腐蚀的过程，可以填充物体内细小的空洞，并平滑物体边界。
Mask = bwmorph(Mask,'clean'); %'clean'：去除图像中孤立的亮点，比如， 一个像素点，其周围像素的像素值全为0
end

