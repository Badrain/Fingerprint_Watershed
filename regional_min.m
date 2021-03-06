%function matrix_min = regional_min( imgrad , immin ) 

%函数功能是筛选去除局部极小点中对比度较低的点
%imgrad是梯度图
%immin是经过Matlab自带imregionalmin函数处理得到的图片
clc;
clear;
flag = [];%用于标记此点是否已经遍历过
coordinate_x = [];
coordinate_y = [];%用于存储每一块极小区域的坐标
data = [];%用于存储每一块极小区域的领域数据

im = imreadbw('fp1.bmp');
immin = imregionalmin(im);
immin_filted = immin;
%immin = uint8(immin);
%figure;imshow(immin);
rgb=imread('fp1.bmp');
%rgb = imread('pears.png');
I = rgb2gray(rgb);
%subplot(341);imshow(I),title('input image');
I_binary = im2bw(I,graythresh(I));       %对图像二值化
%subplot(342);imshow(I_binary,[]), title('binary of input image)')
% I_watershed=watershed(I)%直接分割会出现过度分割的情况
% figure, imshow(I_watershed), title('Watershed transform of original image')
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

%% 得到需要的坐标
[ imx, imy ] = size(immin);
flag = zeros(imx,imy);
%sign = 0;%决定现在是在同一个
cdtemp_x = [];
cdtemp_y = [];%每一块区域里的坐标
number = 1;
for i=1:imx
    for j=1:imy
        if immin(i,j)==1 && flag(i,j)==0
            cdtemp_x = [cdtemp_x,i];
            cdtemp_y = [cdtemp_y,j];
            flag(i,j) = 1;
            %确定8领域点是否标记，并记入坐标
            itemp=i;
            jtemp=j;
            while(1)
                [count,itemptemp,jtemptemp,flag,cdtemp_x,cdtemp_y] = eightround(immin,itemp,jtemp,flag,cdtemp_x,cdtemp_y);
                itemp=itemptemp;
                jtemp=jtemptemp;
                if count==0%说明这一块极值点标记完毕
                    break;
                end
            end

            %确定8领域结束，将cdtemp坐标写入总坐标的矩阵
            coordinate_x = [coordinate_x;mean(cdtemp_x),length(cdtemp_x)];
            coordinate_y = [coordinate_y;mean(cdtemp_y),length(cdtemp_y)];
            cdtemp_x = [];
            cdtemp_y = [];
        elseif immin(i,j)==1 && flag(i,j)==1
                continue;
        end
    end
end
            



%% 得到邻域数据
coordinate_x = round(coordinate_x);%两列向量，第一列是中心坐标，第二列是该区域的像素点数
coordinate_y = round(coordinate_y);

%% 进行筛选
%将边长存入radius矩阵
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

%% difference矩阵
data_error = zeros(coor_length);%用来标记异常
temp_value = [];%用来暂时存储每块的diff值
value = zeros(coor_length,1);%用来存储diff平均值
for i=1:coor_length
    r = radius(i);
    x = coordinate_x(i,1);
    y = coordinate_y(i,1);
    if (x-r)<=0 || (y-r)<=0 || (x+r)>=imx || (y+r)>=imy
        data_error(i)=1;
        continue;
    else
        for j=(x-r):(x+r)%循环大矩阵
            for k=(y-r):(y+r)
                if flag(j,k)==1%排除flag中的点
                    continue;
                elseif (im(j,k)-im(x,y))==0%如果此点还是局部最小值的一部分，则跳过
                    continue;
                end
                temp_value = [temp_value,(im(j,k)-im(x,y))];%gradmag(j,k)];
            end
        end
        value(i) = mean(temp_value);
    end
end


%% 筛选符合的极小点
fgm_filted = zeros(imx, imy);
flag = zeros(imx,imy);
%sign = 0;%决定现在是在同一个
cdtemp_x = [];
cdtemp_y = [];%每一块区域里的坐标
number = 1;
count_loop_for_value = 0;
for i=1:imx
    for j=1:imy
        if immin(i,j)==1 && flag(i,j)==0
            cdtemp_x = [cdtemp_x,i];
            cdtemp_y = [cdtemp_y,j];
            flag(i,j) = 1;
            %确定8领域点是否标记，并记入坐标
            itemp=i;
            jtemp=j;
            while(1)
                [count,itemptemp,jtemptemp,flag,cdtemp_x,cdtemp_y] = eightround(immin,itemp,jtemp,flag,cdtemp_x,cdtemp_y);
                itemp=itemptemp;
                jtemp=jtemptemp;
                if count==0%说明这一块极值点标记完毕
                    break;
                end
            end

            %确定8领域结束，将cdtemp坐标写入总坐标的矩阵
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
