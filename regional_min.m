%function matrix_min = regional_min( imgrad , immin ) 

%����������ɸѡȥ���ֲ���С���жԱȶȽϵ͵ĵ�
%imgrad���ݶ�ͼ
%immin�Ǿ���Matlab�Դ�imregionalmin���������õ���ͼƬ
clc;
clear;
flag = [];%���ڱ�Ǵ˵��Ƿ��Ѿ�������
coordinate_x = [];
coordinate_y = [];%���ڴ洢ÿһ�鼫С���������
data = [];%���ڴ洢ÿһ�鼫С�������������

im = imreadbw('fp1.bmp');
immin = imregionalmin(im);
immin_filted = immin;
%immin = uint8(immin);
%figure;imshow(immin);
rgb=imread('fp1.bmp');
%rgb = imread('pears.png');
I = rgb2gray(rgb);
%subplot(341);imshow(I),title('input image');
I_binary = im2bw(I,graythresh(I));       %��ͼ���ֵ��
%subplot(342);imshow(I_binary,[]), title('binary of input image)')
% I_watershed=watershed(I)%ֱ�ӷָ����ֹ��ȷָ�����
% figure, imshow(I_watershed), title('Watershed transform of original image')
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

%% �õ���Ҫ������
[ imx, imy ] = size(immin);
flag = zeros(imx,imy);
%sign = 0;%������������ͬһ��
cdtemp_x = [];
cdtemp_y = [];%ÿһ�������������
number = 1;
for i=1:imx
    for j=1:imy
        if immin(i,j)==1 && flag(i,j)==0
            cdtemp_x = [cdtemp_x,i];
            cdtemp_y = [cdtemp_y,j];
            flag(i,j) = 1;
            %ȷ��8������Ƿ��ǣ�����������
            itemp=i;
            jtemp=j;
            while(1)
                [count,itemptemp,jtemptemp,flag,cdtemp_x,cdtemp_y] = eightround(immin,itemp,jtemp,flag,cdtemp_x,cdtemp_y);
                itemp=itemptemp;
                jtemp=jtemptemp;
                if count==0%˵����һ�鼫ֵ�������
                    break;
                end
            end

            %ȷ��8�����������cdtemp����д��������ľ���
            coordinate_x = [coordinate_x;mean(cdtemp_x),length(cdtemp_x)];
            coordinate_y = [coordinate_y;mean(cdtemp_y),length(cdtemp_y)];
            cdtemp_x = [];
            cdtemp_y = [];
        elseif immin(i,j)==1 && flag(i,j)==1
                continue;
        end
    end
end
            



%% �õ���������
coordinate_x = round(coordinate_x);%������������һ�����������꣬�ڶ����Ǹ���������ص���
coordinate_y = round(coordinate_y);

%% ����ɸѡ
%���߳�����radius����
[coor_length , ~] = size(coordinate_x);
radius = [];
for i=1:coor_length
    r = sqrt(coordinate_x(i,2));
    r = ceil(r);
    if mod(r,2)==0
        r=r/2+2;
    else
        r=r-1;
        r=r/2+2;
    end
    radius = [radius,r];
end

%% difference����
data_error = zeros(coor_length);%��������쳣
temp_value = [];%������ʱ�洢ÿ���diffֵ
value = zeros(coor_length,1);%�����洢diffƽ��ֵ
for i=1:coor_length
    r = radius(i);
    x = coordinate_x(i,1);
    y = coordinate_y(i,1);
    if (x-r)<=0 || (y-r)<=0 || (x+r)>=imx || (y+r)>=imy
        data_error(i)=1;
        continue;
    else
        for j=(x-r):(x+r)%ѭ�������
            for k=(y-r):(y+r)
                if flag(j,k)==1%�ų�flag�еĵ�
                    continue;
                elseif (im(j,k)-im(x,y))==0%����˵㻹�Ǿֲ���Сֵ��һ���֣�������
                    continue;
                end
                temp_value = [temp_value,(im(j,k)-im(x,y))];%gradmag(j,k)];
            end
        end
        value(i) = mean(temp_value);
    end
end


%% ɸѡ���ϵļ�С��
fgm_filted = zeros(imx, imy);
flag = zeros(imx,imy);
%sign = 0;%������������ͬһ��
cdtemp_x = [];
cdtemp_y = [];%ÿһ�������������
number = 1;
count_loop_for_value = 0;
for i=1:imx
    for j=1:imy
        if immin(i,j)==1 && flag(i,j)==0
            cdtemp_x = [cdtemp_x,i];
            cdtemp_y = [cdtemp_y,j];
            flag(i,j) = 1;
            %ȷ��8������Ƿ��ǣ�����������
            itemp=i;
            jtemp=j;
            while(1)
                [count,itemptemp,jtemptemp,flag,cdtemp_x,cdtemp_y] = eightround(immin,itemp,jtemp,flag,cdtemp_x,cdtemp_y);
                itemp=itemptemp;
                jtemp=jtemptemp;
                if count==0%˵����һ�鼫ֵ�������
                    break;
                end
            end

            %ȷ��8�����������cdtemp����д��������ľ���
            count_loop_for_value = count_loop_for_value + 1;
            if value(count_loop_for_value)<0.0690
                for c=1:length(cdtemp_x)       
                        immin_filted(cdtemp_x(c),cdtemp_y(c))=0;
                end
            end
            cdtemp_x = [];
            cdtemp_y = [];
        elseif immin(i,j)==1 && flag(i,j)==1
                continue;
        end
    end
end

figure;imshow(immin_filted);