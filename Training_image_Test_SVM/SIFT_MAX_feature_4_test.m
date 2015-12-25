function [SIFT_feature_1,SIFT_feature_2] = SIFT_MAX_feature_4_test(image_name,mat_name,siftSize)%该函数是读入图像和坐标点来得到同时满足极大值和标记的对应坐标所有LBP特征

%加载图像以及坐标
    I=imread(image_name);
    imx = size(I,1);
    imy = size(I,2);
    I_coor=zeros(imx,imy);
    load(mat_name);%得到的是new_coor_after文件
    mat_name_after = [];
    for i=1:size(new_coor_after,1)
        if new_coor_after(i,3)==1
            mat_name_after = [mat_name_after;new_coor_after(i,1:2)];%得到的"mat_name_after"是去除了标记“0”的两列数据
            row = new_coor_after(i,1);
            col = new_coor_after(i,2);
            I_coor(row,col)=1;
        end
    end
%把I_coor进行膨胀
    se_coor = strel('square', 5);
    I_coor = imdilate(I_coor,se_coor);
     
%对图像进行预处理并得到局部极大值
    se = strel('square', 2);%目前最成功的在ppt里，值是“3”（针对fp1.bmp)
    Ie = imerode(I, se);
    Iobr = imreconstruct(Ie, I);
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    max = imregionalmax(Iobrcbr);
    
%% 判断该坐标是否也同时符合局部极大值
    max_coor = zeros(imx,imy);%存储是pore点的二值图
    un_coor = zeros(imx,imy);%存储不是pore点的二值图
    pore_coor = [];
    un_pore_coor = [];
    for i=1:imx
        for j=1:imy
            if I_coor(i,j)==1 && max(i,j)==1%是极大值，同时是之前标记的
                max_coor(i,j) = 1;
                pore_coor = [pore_coor;[i,j]];
            elseif I_coor(i,j)==0 && max(i,j)==1%是极大值，但是不是之前标记的
                un_pore_coor = [un_pore_coor;[i,j]];
                un_coor(i,j) = 1;
            end
        end
    end
    %figure;imshow(gray2rgb(I,max_coor,un_coor));

%% 用滑动窗口筛选去除多余的点
    pore_coor_after = [];
    un_pore_coor_after = [];
    im = max_coor;
    im(un_coor==1)=1;
    scale = 8;
    for i=1:2:imx
        for j=1:2:imy
            if (i-scale/2+1)>=1 && (j-scale/2+1)>=1 && (i+scale/2)<=imx && (j+scale/2)<=imy
                temp = im((i-scale/2+1):(i+scale/2),(j-scale/2+1):(j+scale/2));
                if length(find(temp~=0))>=12
                    im((i-scale/2+1):(i+scale/2),(j-scale/2+1):(j+scale/2)) = 0;
                end
            end
        end
    end
    se = strel('square', 2);%为了节省计算量
    im = imerode(im,se);
    for m=1:size(pore_coor,1)
        if im(pore_coor(m,1),pore_coor(m,2))==1%根据滑块筛选pore_coor
            pore_coor_after = [pore_coor_after;pore_coor(m,:)];
        else
            max_coor(pore_coor(m,1),pore_coor(m,2))=0;
        end
    end
    for n=1:size(un_pore_coor,1)
        if im(un_pore_coor(n,1),un_pore_coor(n,2))==1%根据滑块筛选un_pore_coor
            un_pore_coor_after = [un_pore_coor_after;un_pore_coor(n,:)];
        else
            un_coor(un_pore_coor(n,1),un_pore_coor(n,2))=0;
        end
    end 

    pore_coor = pore_coor_after;
    un_pore_coor = un_pore_coor_after;
 
    
%% 这一大块是用来处理是un_pore_coor的(LBP_feature_2)
        SIFT_feature_2 = [];
        SIFT_feature_2 = [SIFT_feature_2;sift_feature_extr(I,un_pore_coor,siftSize)];
     
%% 这一大块是用来处理是pore_coor的(LBP_feature_1)
        SIFT_feature_1 = [];
        SIFT_feature_1 = [SIFT_feature_1;sift_feature_extr(I,pore_coor,siftSize)];
        
end