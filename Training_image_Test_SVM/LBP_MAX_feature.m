function [LBP_feature_1,LBP_feature_2] = LBP_MAX_feature(image_name,mat_name,lbpSize)%该函数是读入图像和坐标点来得到同时满足极大值和标记的对应坐标所有LBP特征

%加载图像以及坐标
mode=2;%new_LBP模式
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
    
%判断该坐标是否也同时符合局部极大值
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
    
if mode==1
%这一大块是用来处理是pore_coor的(LBP_feature_1)
    num_pores = size(pore_coor,1);%计算pore_core的个数，在后面会用到。
    [rang_x,rang_y]=size(I);
    mapping=getmapping(8,'ri');
    module_lbp=cell(num_pores,1);
    m=[];
    n=[];
    module_matrix=[];
    for i=1:num_pores  
        m = pore_coor(i,1);%m是y n是x
        n = pore_coor(i,2);
        if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%这一步排除了边界点
            module_matrix=I(m-lbpSize:m+lbpSize,n-lbpSize:n+lbpSize); %提取矩阵模块
            module_lbp{i}=lbp(module_matrix,1,8,mapping,'hist');
        end
    end
    LBP_feature_1 = cell2mat(module_lbp);

    
    
%这一大块是用来处理是un_pore_coor的(LBP_feature_2)    
    num_un_pores = size(un_pore_coor,1);%计算pore_core的个数，在后面会用到。
    [rang_x,rang_y]=size(I);
    mapping=getmapping(8,'ri');
    module_lbp=cell(num_un_pores,1);
    m=[];
    n=[];
    module_matrix=[];
    for i=1:num_un_pores  
        m = un_pore_coor(i,1);%m是y n是x
        n = un_pore_coor(i,2);
        if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%这一步排除了边界点
            module_matrix=I(m-lbpSize:m+lbpSize,n-lbpSize:n+lbpSize); %提取矩阵模块
            module_lbp{i}=lbp(module_matrix,1,8,mapping,'hist');
        end
    end
    LBP_feature_2 = cell2mat(module_lbp);
    
    
elseif mode==2
    %这一大块是用来处理是un_pore_coor的(LBP_feature_2)    
        combine_feature_vector = [];
        num_un_pores = size(un_pore_coor,1);%点的个数
        [rang_x,rang_y] = size(I);
        module_lbp=cell(num_un_pores,1);
        m = [];
        n = [];
        module_matrix = [];
        for i=1:num_un_pores  
            m = un_pore_coor(i,1);%m是y n是x
            n = un_pore_coor(i,2);
            if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%这一步排除了边界点
                module_matrix = I(m-lbpSize:m+lbpSize,n-lbpSize:n+lbpSize); %提取矩阵模块
                hist_output = LBP_C(module_matrix);
                combine_feature_vector=[combine_feature_vector;combine_h_feature(hist_output)];
                %module_lbp{i} = cell2mat(hist_output);
            end
        end
        %LBP_feature = cell2mat(module_lbp);%when k=1
        LBP_feature_2 = combine_feature_vector;%when k>1
     
%这一大块是用来处理是pore_coor的(LBP_feature_1)
        combine_feature_vector = [];
      num_pores = size(pore_coor,1);%点的个数
        [rang_x,rang_y] = size(I);
        module_lbp=cell(num_pores,1);
        m = [];
        n = [];
        module_matrix = [];
        for i=1:num_pores  
            m = pore_coor(i,1);%m是y n是x
            n = pore_coor(i,2);
            if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%这一步排除了边界点
                module_matrix = I(m-lbpSize:m+lbpSize,n-lbpSize:n+lbpSize); %提取矩阵模块
                hist_output = LBP_C(module_matrix);
                combine_feature_vector=[combine_feature_vector;combine_h_feature(hist_output)];
                %module_lbp{i} = cell2mat(hist_output);
            end
        end
        %LBP_feature = cell2mat(module_lbp);%when k=1
        LBP_feature_1 = combine_feature_vector;%when k>1
   

end


end