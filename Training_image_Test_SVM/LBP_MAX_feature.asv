function LBP_feature = LBP_MAX_feature(image_name,mat_name,lbpSize)%该函数是读入图像和坐标点来得到同时满足极大值和标记的对应坐标所有LBP特征

    %加载图像以及坐标
    I=imread(image_name);
    load(mat_name);%得到的是new_coor_after文件
    mat_name_after = [];
    for i=1:size(new_coor_after,1)
        if new_coor_after(i,3)==1
            mat_name_after = [mat_name_after;new_coor_after(i,1:2)];%得到的"mat_name_after"是去除了标记“0”的两列数据
        end
    end
    num_pores = size(mat_name_after,1);%点的个数
    
    %对图像进行预处理并得到局部极大值
    se = strel('square', 2);%目前最成功的在ppt里，值是“3”（针对fp1.bmp)
    Ie = imerode(I, se);
    Iobr = imreconstruct(Ie, I);
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    max = imregionalmax(Iobrcbr);
    
    %判断该坐标是否也同时符合局部极大值
    max_coor_flag=0;
    for i=size(mat_name_after,1)%%%%%%!!!!!!!!!!!!!!!!!!!!!!可能出错，错误是过了图像边界！！！
        row = mat_name_after(i,1);
        col = mat_name_after(i,2);
        for i=(row-1):(row+1)
            for j=(col-1):(col+1)
                if max(i,j)==1
                    

    !!!!!!!!!!!!!!!!!num_pores
    [rang_x,rang_y]=size(I);
    mapping=getmapping(8,'ri');
    module_lbp=cell(num_pores,1);
    m=[];
    n=[];
    module_matrix=[];
    for i=1:num_pores  
        m = mat_name_after(i,1);%m是y n是x
        n = mat_name_after(i,2);
        if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%这一步排除了边界点
            module_matrix=I(m-lbpSize:m+lbpSize,n-lbpSize:n+lbpSize); %提取矩阵模块
            module_lbp{i}=lbp(module_matrix,1,8,mapping,'hist');
        end

    end
    LBP_feature = cell2mat(module_lbp);


end