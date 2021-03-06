function [LBP_feature_1,LBP_feature_2] = LBP_MAX_feature_4_test(image_name,mat_name,lbpSize)%该函数是读入图像和坐标点来得到同时满足极大值和标记的对应坐标所有LBP特征
%！！！该函数区别于LBP_MAX_feature的地方是做了筛选去除一些不必要点。
%加载图像以及坐标
filter_mode=2;%mode用于选择筛选方式："1"是是在LBP_MAX_feature的基础+滑动窗口减少计算量方式，“2”是不使用预处理+利用4:6去除法+cluster,“3"是在LBP_MAX_feature的基础+cluster一下，“4”是不使用预处理+cluster(猜测RF差的原因是开的pore保留了，RT差的原因是非pore位置保留太多）
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
     


if filter_mode==1
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
            max_coor = zeros(imx,imy);%存储是pore点的二值图（只是调试用，改写时可删去）
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
        %     figure;imshow(gray2rgb(I,max_coor,un_coor));

        %用滑动窗口筛选去除多余的点
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
        %     figure;imshow(gray2rgb(I,max_coor,un_coor));
    
elseif filter_mode==2
                %把I_coor进行膨胀
            se_coor = strel('square', 3);
            I_coor = imdilate(I_coor,se_coor);

            max = imregionalmax(I);
        %判断该坐标是否也同时符合局部极大值
            max_coor = zeros(imx,imy);%存储是pore点的二值图（只是调试用，改写时可删去）
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
        %     figure;imshow(gray2rgb(I,max_coor,un_coor));
            filter_count=0;%无需了解,只是记录层数
            for filter_parameter=6:6%4:6
                se = strel('square', filter_parameter);%目前最成功的在ppt里，值是“3”（针对fp1.bmp)
                Ie = imerode(I, se);
                Iobr = imreconstruct(Ie, I);
                Iobrd = imdilate(Iobr, se);
                Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
                Iobrcbr = imcomplement(Iobrcbr);
                filter_count = filter_count + 1;
                max_filter(:,:,filter_count) = imregionalmax(Iobrcbr);
            end
            %Filt the coor according to conditions
            pore_coor_after = [];
            un_pore_coor_after = [];
            for filter_parameter=1:1
                for m=1:size(pore_coor,1)
                    if max_coor(pore_coor(m,1),pore_coor(m,2))==1 && max_filter(pore_coor(m,1),pore_coor(m,2),filter_parameter)==0%根据滑块筛选pore_coor
                        pore_coor_after = [pore_coor_after;pore_coor(m,:)];
                    else
                        max_coor(pore_coor(m,1),pore_coor(m,2))=0;
                    end
                end
                for n=1:size(un_pore_coor,1)
                    if un_coor(un_pore_coor(n,1),un_pore_coor(n,2))==1 && max_filter(un_pore_coor(n,1),un_pore_coor(n,2),filter_parameter)==0%根据滑块筛选un_pore_coor
                        un_pore_coor_after = [un_pore_coor_after;un_pore_coor(n,:)];
                    else
                        un_coor(un_pore_coor(n,1),un_pore_coor(n,2))=0;
                    end
                end 
            end
            pore_coor = pore_coor_after;
            un_pore_coor = un_pore_coor_after;  
        %     figure;imshow(gray2rgb(I,max_coor,un_coor));
            [pore_coor,max_coor_after,continue_cluster_flag] = coor_cluster(max_coor,2);
            [un_pore_coor,un_coor_after,continue_cluster_flag] = coor_cluster(un_coor,2);
            max_coor = max_coor_after;
            un_coor = un_coor_after;
        %     figure;imshow(gray2rgb(I,max_coor,un_coor));
elseif filter_mode==3
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
            filter_count=0;%无需了解,只是记录层数
            for filter_parameter=4:6
                se = strel('square', filter_parameter);%目前最成功的在ppt里，值是“3”（针对fp1.bmp)
                Ie = imerode(I, se);
                Iobr = imreconstruct(Ie, I);
                Iobrd = imdilate(Iobr, se);
                Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
                Iobrcbr = imcomplement(Iobrcbr);
                filter_count = filter_count + 1;
                max_filter(:,:,filter_count) = imregionalmax(Iobrcbr);
            end
            %Filt the coor according to conditions
            pore_coor_after = [];
            un_pore_coor_after = [];
            for filter_parameter=1:3
                for m=1:size(pore_coor,1)
                    if max_coor(pore_coor(m,1),pore_coor(m,2))==1 && max_filter(pore_coor(m,1),pore_coor(m,2),filter_parameter)==0%根据滑块筛选pore_coor
                        pore_coor_after = [pore_coor_after;pore_coor(m,:)];
                    else
                        max_coor(pore_coor(m,1),pore_coor(m,2))=0;
                    end
                end
                for n=1:size(un_pore_coor,1)
                    if un_coor(un_pore_coor(n,1),un_pore_coor(n,2))==1 && max_filter(un_pore_coor(n,1),un_pore_coor(n,2),filter_parameter)==0%根据滑块筛选un_pore_coor
                        un_pore_coor_after = [un_pore_coor_after;un_pore_coor(n,:)];
                    else
                        un_coor(un_pore_coor(n,1),un_pore_coor(n,2))=0;
                    end
                end 
            end
            pore_coor = pore_coor_after;
            un_pore_coor = un_pore_coor_after;  

        %     figure;imshow(gray2rgb(I,max_coor,un_coor));
            clear pore_coor;
            clear un_pore_coor;
            [pore_coor,max_coor_after,continue_cluster_flag] = coor_cluster(max_coor,2);
            clear max_coor;
            [un_pore_coor,un_coor_after,continue_cluster_flag] = coor_cluster(un_coor,2);
            max_coor = max_coor_after;
            un_coor = un_coor_after;
        %     figure;imshow(gray2rgb(I,max_coor,un_coor));

elseif filter_mode==4
                    %把I_coor进行膨胀
            se_coor = strel('square', 3);
            I_coor = imdilate(I_coor,se_coor);

            max = imregionalmax(I);
        %判断该坐标是否也同时符合局部极大值
            max_coor = zeros(imx,imy);%存储是pore点的二值图（只是调试用，改写时可删去）
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
%             figure;imshow(gray2rgb(I,max_coor,un_coor));
            
            clear pore_coor;
            clear un_pore_coor;
            pore_coor = [];
            un_pore_coor = [];
            for m=1:2
                for n=1:2
                    high_from = 240*(m-1)/2+1;
                    high_to = 240*m/2;
                    width_from = 320*(n-1)/2+1;
                    width_to = 320*n/2;
                    [pore_coor_after,max_coor_after(high_from:high_to,width_from:width_to),continue_cluster_flag] = coor_cluster(max_coor(high_from:high_to,width_from:width_to),2);
                    pore_coor = [pore_coor;pore_coor_after];
                    [un_pore_coor_after,un_coor_after(high_from:high_to,width_from:width_to),continue_cluster_flag] = coor_cluster(un_coor(high_from:high_to,width_from:width_to),2);
                    un_pore_coor = [un_pore_coor;un_pore_coor_after];
                end
            end
            max_coor = max_coor_after;%仅仅是调试需要
            un_coor = un_coor_after;
%             figure;imshow(gray2rgb(I,max_coor,un_coor));

end



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
                module_matrix = I(m-lbpSize:m+lbpSize-1,n-lbpSize:n+lbpSize-1); %提取矩阵模块
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
                module_matrix = I(m-lbpSize:m+lbpSize-1,n-lbpSize:n+lbpSize-1); %提取矩阵模块
                hist_output = LBP_C(module_matrix);
                combine_feature_vector=[combine_feature_vector;combine_h_feature(hist_output)];
                %module_lbp{i} = cell2mat(hist_output);
            end
        end
        %LBP_feature = cell2mat(module_lbp);%when k=1
        LBP_feature_1 = combine_feature_vector;%when k>1


end