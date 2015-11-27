%close all
%clear
%clc
function hist_output=LBP_C(image_input)

image=image_input;
mapping=myself_mapping(8);% 获取旋转不变均匀模式
%image=imread('5.bmp');
%figure
%imshow(image)
%figure
image=double(image);% 为了提高精度，采用双精度模式
[y_image,x_image]=size(image); % 获取输入图像的大小
% y_result=y_image-2;
% x_result=x_image-2;
a=zeros(y_image,x_image);% 用于暂时存储比较的结果
result=zeros(y_image,x_image);% 用于保存结果
% 计算输入图像的LBP编码
% 顺时针，从(3,3)开始
for i=2:y_image-1
    for j=2:x_image-1
        if image(i-1,j+1)>=image(i,j)
            a(i-1,j+1)=1;
        else
            a(i-1,j+1)=0;
        end
        if image(i,j+1)>=image(i,j)
            a(i,j+1)=1;
        else
            a(i,j+1)=0;
        end
        if image(i+1,j+1)>=image(i,j)
            a(i+1,j+1)=1;
        else
            a(i+1,j+1)=0;
        end
        if image(i+1,j)>=image(i,j)
            a(i+1,j)=1;
        else
            a(i+1,j)=0;
        end
        if image(i+1,j-1)>=image(i,j)
            a(i+1,j-1)=1;
        else
            a(i+1,j-1)=0;
        end
        if image(i,j-1)>=image(i,j)
            a(i,j-1)=1;
        else
            a(i,j-1)=0;
        end
        if image(i-1,j-1)>=image(i,j)
            a(i-1,j-1)=1;
        else
            a(i-1,j-1)=0;
        end
        if image(i-1,j)>=image(i,j)
            a(i-1,j)=1;
        else
            a(i-1,j)=0;
        end
        % 逆时针，从（2，1）开始
        %result(i,j)=a(i-1,j+1)*2.^2+...
        %            a(i  ,j+1)*2.^3+...
        %            a(i+1,j+1)*2.^4+...
        %            a(i+1,j  )*2.^5+...
        %            a(i+1,j-1)*2.^6+...
        %            a(i  ,j-1)*2.^7+...
        %            a(i-1,j-1)*2.^0+...
        %            a(i-1,j  )*2.^1;
        % 顺时针，从（1，2）开始
        %result(i,j)=a(i-1,j+1)*2.^6+...
        %            a(i  ,j+1)*2.^5+...
        %           a(i+1,j+1)*2.^4+...
        %            a(i+1,j  )*2.^3+...
        %            a(i+1,j-1)*2.^2+...
        %            a(i  ,j-1)*2.^1+...
        %           a(i-1,j-1)*2.^0+...
        %            a(i-1,j  )*2.^7;
        % 顺时针，从（1，1）开始
        %result(i,j)=a(i-1,j+1)*2.^5+...
        %            a(i  ,j+1)*2.^4+...
        %            a(i+1,j+1)*2.^3+...
        %            a(i+1,j  )*2.^2+...
        %            a(i+1,j-1)*2.^1+...
        %            a(i  ,j-1)*2.^0+...
        %            a(i-1,j-1)*2.^7+...
        %            a(i-1,j  )*2.^6;
        %result(i,j)=a(i-1,j+1)*2.^1+...
        %           a(i  ,j+1)*2.^2+...
        %           a(i+1,j+1)*2.^3+...
        %           a(i+1,j  )*2.^4+...
        %           a(i+1,j-1)*2.^5+...
        %           a(i  ,j-1)*2.^6+...
        %           a(i-1,j-1)*2.^7+...
        %           a(i-1,j  )*2.^0;
        % 顺时针，从(3,3)开始
        result(i,j)=a(i-1,j+1)*2.^1+...
                    a(i  ,j+1)*2.^0+...
                    a(i+1,j+1)*2.^7+...
                    a(i+1,j  )*2.^6+...
                    a(i+1,j-1)*2.^5+...
                    a(i  ,j-1)*2.^4+...
                    a(i-1,j-1)*2.^3+...
                    a(i-1,j  )*2.^2;
    end
end
% class(result);
% size(result);
%result_temp=result(3:98,3:98);% 为了方便分块，把图片剪裁为96*96的大小（输入图像为100*100）!!!!!!!
%result=result_temp;
%imshow(uint8(result)) % 显示编码结果

% 对结果进行均衡化，起到缩短特征长度的作用
if isstruct(mapping)
    bins = mapping.num;
    for i = 1:size(result,1)
        for j = 1:size(result,2)
            result(i,j) = mapping.table(result(i,j)+1);
        end
    end
end

% 分块
% 分为4*4一共16块!!!!!!!!!!!!!!!!!!!!!!!!!!!
k=1;
aa=cell(k);% 创建元胞，用于保存结果   
I_size_f=size(result);% 获取编码后的图片的大小
%disp('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^')
%fprintf('result : %d',I_size_f);
wi=I_size_f(2)/k;% x轴的分块长度
wj=I_size_f(1)/k;% y轴的分块长度
%disp('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^')
%fprintf('wi:%d\n',wi);
kuai_image_f=cell(k);
image_f=cell(k);% 用于保存结果
for i=1:k               
    for j=1:k
        %for m=1:(k+1).^2
        aa{i,j}=[((j-1)*wi+1) ((i-1)*wi+1)];% 找到每一个小块的开始坐标
    end
end
for i=1:k*k
    kuai_image_f{i}=result(aa{i}(2):aa{i}(2)+wi-1,aa{i}(1):aa{i}(1)+wi-1);% 获取每一小块
end

for i=1:k*k
    image_f{i}=hist(kuai_image_f{i}(:),0:(bins-1));% 获取每一次小块的直方图，也即特征向量，总的图片的特征向量长度为每一小块的特征向量长度*分块数目，因为采用的是串接的方式
end
hist_output=image_f; % 结果为一个4*4的元胞结构，并作返回