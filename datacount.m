function [ coverage ] = datacount( mask )
%输入mask掩膜（即分类之后的黑白二值图）文件，计算植被覆盖度
if iscell(mask)%如果是一个并行包里面，用户自己添加了很多张照片，计算每一张照片的盖度
    T=size(mask,1);
    coverage=ones(T,1);
    for t=1:T
        num0=size(find(mask{t,1}==1),1);%计算植被像素（1）的个数
        num_all=size(mask{t,1},1)*size(mask{t,1},2);%计算所有像素个数
        coverage(t,1)=num0/num_all;%计算盖度
    end
else%如果是GB级的遥感影像，则一张遥感影像单独为一个并行包，只要计算一个盖度即可
    num0=size(find(mask==1),1);
    num_all=size(mask,1)*size(mask,2);
    coverage=num0/num_all;
end

end

