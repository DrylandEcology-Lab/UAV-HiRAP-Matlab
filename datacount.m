function [ coverage ] = datacount( mask )
%����mask��Ĥ��������֮��ĺڰ׶�ֵͼ���ļ�������ֲ�����Ƕ�
if iscell(mask)%�����һ�����а����棬�û��Լ�����˺ܶ�����Ƭ������ÿһ����Ƭ�ĸǶ�
    T=size(mask,1);
    coverage=ones(T,1);
    for t=1:T
        num0=size(find(mask{t,1}==1),1);%����ֲ�����أ�1���ĸ���
        num_all=size(mask{t,1},1)*size(mask{t,1},2);%�����������ظ���
        coverage(t,1)=num0/num_all;%����Ƕ�
    end
else%�����GB����ң��Ӱ����һ��ң��Ӱ�񵥶�Ϊһ�����а���ֻҪ����һ���Ƕȼ���
    num0=size(find(mask==1),1);
    num_all=size(mask,1)*size(mask,2);
    coverage=num0/num_all;
end

end

