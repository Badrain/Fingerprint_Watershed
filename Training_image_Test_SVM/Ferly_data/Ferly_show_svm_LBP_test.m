function Ferly_show_svm_LBP_test(image_name,mat_name,predict_label,lbpSize)
%该函数用于figure出svm_test的结果

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
     
% %对图像进行预处理并得到局部极大值
%     se = strel('square', 2);%目前最成功的在ppt里，值是“3”（针对fp1.bmp)
%     Ie = imerode(I, se);
%     Iobr = imreconstruct(Ie, I);
%     Iobrd = imdilate(Iobr, se);
%     Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
%     Iobrcbr = imcomplement(Iobrcbr);
%     max = imregionalmax(Iobrcbr);

max = imregionalmax(I);
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
  
% %% 用滑动窗口筛选去除多余的点
%     pore_coor_after = [];
%     un_pore_coor_after = [];
%     im = max_coor;
%     im(un_coor==1)=1;
%     scale = 8;
%     for i=1:2:imx
%         for j=1:2:imy
%             if (i-scale/2+1)>=1 && (j-scale/2+1)>=1 && (i+scale/2)<=imx && (j+scale/2)<=imy
%                 temp = im((i-scale/2+1):(i+scale/2),(j-scale/2+1):(j+scale/2));
%                 if length(find(temp~=0))>=12
%                     im((i-scale/2+1):(i+scale/2),(j-scale/2+1):(j+scale/2)) = 0;
%                 end
%             end
%         end
%     end
%         se = strel('square', 2);%为了节省计算量
%     im = imerode(im,se);
% 
%     for m=1:size(pore_coor,1)
%         if im(pore_coor(m,1),pore_coor(m,2))==1%根据滑块筛选pore_coor
%             pore_coor_after = [pore_coor_after;pore_coor(m,:)];
%         else
%             max_coor(pore_coor(m,1),pore_coor(m,2))=0;
%         end
%     end
%     for n=1:size(un_pore_coor,1)
%         if im(un_pore_coor(n,1),un_pore_coor(n,2))==1%根据滑块筛选un_pore_coor
%             un_pore_coor_after = [un_pore_coor_after;un_pore_coor(n,:)];
%         else
%             un_coor(un_pore_coor(n,1),un_pore_coor(n,2))=0;
%         end
%     end 
% 
%     pore_coor = pore_coor_after;
%     un_pore_coor = un_pore_coor_after;
% 
    
    
    
    num_pores = size(pore_coor,1);%计算pore_core的个数，在后面会用到。
    [rang_x,rang_y]=size(I);
    m=[];
    n=[];
    pore_coor_after = [];
    un_pore_coor_after = [];
    for i=1:num_pores  
        m = pore_coor(i,1);%m是y n是x
        n = pore_coor(i,2);
        if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%这一步排除了边界点
            pore_coor_after = [pore_coor_after;pore_coor(i,1:2)];
        end
    end
    
    num_un_pores = size(un_pore_coor,1);%计算pore_core的个数，在后面会用到。
    [rang_x,rang_y]=size(I);
    m=[];
    n=[];
    for i=1:num_un_pores  
        m = un_pore_coor(i,1);%m是y n是x
        n = un_pore_coor(i,2);
        if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%这一步排除了边界点
            un_pore_coor_after = [un_pore_coor_after;un_pore_coor(i,1:2)];
        end
    end

    
coor_image = zeros(imx,imy);
un_coor_image = zeros(imx,imy);
coor = [pore_coor_after;un_pore_coor_after];
coor = [coor,predict_label];
for i=1:size(coor,1)
    if coor(i,3)==1
        coor_image(coor(i,1),coor(i,2))=1;
    elseif coor(i,3)==-1
        un_coor_image(coor(i,1),coor(i,2))=1;  
    end
end
figure;imshow(gray2rgb(I,coor_image,un_coor_image));

end
