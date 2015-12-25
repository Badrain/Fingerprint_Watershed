function [SIFT_feature_1,SIFT_feature_2] = SIFT_MAX_feature(image_name,mat_name,siftSize)%�ú����Ƕ���ͼ�����������õ�ͬʱ���㼫��ֵ�ͱ�ǵĶ�Ӧ��������LBP����

%����ͼ���Լ�����
    I=imread(image_name);
    imx = size(I,1);
    imy = size(I,2);
    I_coor=zeros(imx,imy);
    load(mat_name);%�õ�����new_coor_after�ļ�
    mat_name_after = [];
    for i=1:size(new_coor_after,1)
        if new_coor_after(i,3)==1
            mat_name_after = [mat_name_after;new_coor_after(i,1:2)];%�õ���"mat_name_after"��ȥ���˱�ǡ�0������������
            row = new_coor_after(i,1);
            col = new_coor_after(i,2);
            I_coor(row,col)=1;
        end
    end
%��I_coor��������
    se_coor = strel('square', 5);
    I_coor = imdilate(I_coor,se_coor);
     
%��ͼ�����Ԥ�����õ��ֲ�����ֵ
    se = strel('square', 2);%Ŀǰ��ɹ�����ppt�ֵ�ǡ�3�������fp1.bmp)
    Ie = imerode(I, se);
    Iobr = imreconstruct(Ie, I);
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    max = imregionalmax(Iobrcbr);
    
%�жϸ������Ƿ�Ҳͬʱ���Ͼֲ�����ֵ
    max_coor = zeros(imx,imy);%�洢��pore��Ķ�ֵͼ
    un_coor = zeros(imx,imy);%�洢����pore��Ķ�ֵͼ
    pore_coor = [];
    un_pore_coor = [];
    for i=1:imx
        for j=1:imy
            if I_coor(i,j)==1 && max(i,j)==1%�Ǽ���ֵ��ͬʱ��֮ǰ��ǵ�
                max_coor(i,j) = 1;
                pore_coor = [pore_coor;[i,j]];
            elseif I_coor(i,j)==0 && max(i,j)==1%�Ǽ���ֵ�����ǲ���֮ǰ��ǵ�
                un_pore_coor = [un_pore_coor;[i,j]];
                un_coor(i,j) = 1;
            end
        end
    end
    %figure;imshow(gray2rgb(I,max_coor,un_coor));

    
    
%% ��һ���������������un_pore_coor��(LBP_feature_2)
        SIFT_feature_2 = [];
        SIFT_feature_2 = [SIFT_feature_2;sift_feature_extr(I,un_pore_coor,siftSize)];
     
%% ��һ���������������pore_coor��(LBP_feature_1)
        SIFT_feature_1 = [];
        SIFT_feature_1 = [SIFT_feature_1;sift_feature_extr(I,pore_coor,siftSize)];
        
end


