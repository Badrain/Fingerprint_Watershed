%close all
%clear
%clc
function hist_output=LBP_C(image_input)

image=image_input;
mapping=myself_mapping(8);% ��ȡ��ת�������ģʽ
%image=imread('5.bmp');
%figure
%imshow(image)
%figure
image=double(image);% Ϊ����߾��ȣ�����˫����ģʽ
[y_image,x_image]=size(image); % ��ȡ����ͼ��Ĵ�С
% y_result=y_image-2;
% x_result=x_image-2;
a=zeros(y_image,x_image);% ������ʱ�洢�ȽϵĽ��
result=zeros(y_image,x_image);% ���ڱ�����
% ��������ͼ���LBP����
% ˳ʱ�룬��(3,3)��ʼ
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
        % ��ʱ�룬�ӣ�2��1����ʼ
        %result(i,j)=a(i-1,j+1)*2.^2+...
        %            a(i  ,j+1)*2.^3+...
        %            a(i+1,j+1)*2.^4+...
        %            a(i+1,j  )*2.^5+...
        %            a(i+1,j-1)*2.^6+...
        %            a(i  ,j-1)*2.^7+...
        %            a(i-1,j-1)*2.^0+...
        %            a(i-1,j  )*2.^1;
        % ˳ʱ�룬�ӣ�1��2����ʼ
        %result(i,j)=a(i-1,j+1)*2.^6+...
        %            a(i  ,j+1)*2.^5+...
        %           a(i+1,j+1)*2.^4+...
        %            a(i+1,j  )*2.^3+...
        %            a(i+1,j-1)*2.^2+...
        %            a(i  ,j-1)*2.^1+...
        %           a(i-1,j-1)*2.^0+...
        %            a(i-1,j  )*2.^7;
        % ˳ʱ�룬�ӣ�1��1����ʼ
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
        % ˳ʱ�룬��(3,3)��ʼ
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
%result_temp=result(3:98,3:98);% Ϊ�˷���ֿ飬��ͼƬ����Ϊ96*96�Ĵ�С������ͼ��Ϊ100*100��!!!!!!!
%result=result_temp;
%imshow(uint8(result)) % ��ʾ������

% �Խ�����о��⻯���������������ȵ�����
if isstruct(mapping)
    bins = mapping.num;
    for i = 1:size(result,1)
        for j = 1:size(result,2)
            result(i,j) = mapping.table(result(i,j)+1);
        end
    end
end

% �ֿ�
% ��Ϊ4*4һ��16��!!!!!!!!!!!!!!!!!!!!!!!!!!!
k=1;
aa=cell(k);% ����Ԫ�������ڱ�����   
I_size_f=size(result);% ��ȡ������ͼƬ�Ĵ�С
%disp('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^')
%fprintf('result : %d',I_size_f);
wi=I_size_f(2)/k;% x��ķֿ鳤��
wj=I_size_f(1)/k;% y��ķֿ鳤��
%disp('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^')
%fprintf('wi:%d\n',wi);
kuai_image_f=cell(k);
image_f=cell(k);% ���ڱ�����
for i=1:k               
    for j=1:k
        %for m=1:(k+1).^2
        aa{i,j}=[((j-1)*wi+1) ((i-1)*wi+1)];% �ҵ�ÿһ��С��Ŀ�ʼ����
    end
end
for i=1:k*k
    kuai_image_f{i}=result(aa{i}(2):aa{i}(2)+wi-1,aa{i}(1):aa{i}(1)+wi-1);% ��ȡÿһС��
end

for i=1:k*k
    image_f{i}=hist(kuai_image_f{i}(:),0:(bins-1));% ��ȡÿһ��С���ֱ��ͼ��Ҳ�������������ܵ�ͼƬ��������������ΪÿһС���������������*�ֿ���Ŀ����Ϊ���õ��Ǵ��ӵķ�ʽ
end
hist_output=image_f; % ���Ϊһ��4*4��Ԫ���ṹ����������