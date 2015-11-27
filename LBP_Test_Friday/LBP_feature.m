function LBP_feature = LBP_feature(image_name,mat_name,lbpSize)%该函数是读入图像和坐标点来得到对应坐标所有的LBP特征

    mode = 2;

    I=imread(image_name);
    load(mat_name);%得到的是new_coor_after文件
    mat_name_after = [];
    for i=1:size(new_coor_after,1)
        if new_coor_after(i,3)==1
            mat_name_after = [mat_name_after;new_coor_after(i,1:2)];%得到的是去除了标记“0”的两列数据
        end
    end
    
    if mode==1
        num_pores = size(mat_name_after,1)%点的个数
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
    elseif mode==2
        num_pores = size(mat_name_after,1);%点的个数
        [rang_x,rang_y] = size(I);
        module_lbp=cell(num_pores,1);
        m = [];
        n = [];
        module_matrix = [];
        for i=1:num_pores  
            m = mat_name_after(i,1);%m是y n是x
            n = mat_name_after(i,2);
            if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%这一步排除了边界点
                module_matrix = I(m-lbpSize:m+lbpSize,n-lbpSize:n+lbpSize); %提取矩阵模块
                hist_output = LBP_C(module_matrix);
                %combine_feature_vector=combine_h_feature(hist_output);
                module_lbp{i} = cell2mat(hist_output);
            end
        end
        LBP_feature = cell2mat(module_lbp);%这里我需要cell型
    end


end