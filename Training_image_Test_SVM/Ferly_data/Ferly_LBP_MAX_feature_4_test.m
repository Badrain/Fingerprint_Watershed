function [LBP_feature_1,LBP_feature_2] = LBP_MAX_feature_4_test(image_name,mat_name,lbpSize)%�ú����Ƕ���ͼ�����������õ�ͬʱ���㼫��ֵ�ͱ�ǵĶ�Ӧ��������LBP����
%�������ú���������LBP_MAX_feature�ĵط�������ɸѡȥ��һЩ����Ҫ�㡣
%����ͼ���Լ�����
mode=2;%new_LBPģʽ
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
     
% %��ͼ�����Ԥ�����õ��ֲ�����ֵ
%     se = strel('square', 2);%Ŀǰ��ɹ�����ppt�ֵ�ǡ�3�������fp1.bmp)
%     Ie = imerode(I, se);
%     Iobr = imreconstruct(Ie, I);
%     Iobrd = imdilate(Iobr, se);
%     Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
%     Iobrcbr = imcomplement(Iobrcbr);
%     max = imregionalmax(Iobrcbr);

max = imregionalmax(I);
%�жϸ������Ƿ�Ҳͬʱ���Ͼֲ�����ֵ
    max_coor = zeros(imx,imy);%�洢��pore��Ķ�ֵͼ��ֻ�ǵ����ã���дʱ��ɾȥ��
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

%�û�������ɸѡȥ������ĵ�
filter_mode = 2;%"1"means slipping window, while "1" means preprocessing mode.
if filter_mode==1
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
    se = strel('square', 2);%Ϊ�˽�ʡ������
    im = imerode(im,se);
    for m=1:size(pore_coor,1)
        if im(pore_coor(m,1),pore_coor(m,2))==1%���ݻ���ɸѡpore_coor
            pore_coor_after = [pore_coor_after;pore_coor(m,:)];
        else
            max_coor(pore_coor(m,1),pore_coor(m,2))=0;
        end
    end
    for n=1:size(un_pore_coor,1)
        if im(un_pore_coor(n,1),un_pore_coor(n,2))==1%���ݻ���ɸѡun_pore_coor
            un_pore_coor_after = [un_pore_coor_after;un_pore_coor(n,:)];
        else
            un_coor(un_pore_coor(n,1),un_pore_coor(n,2))=0;
        end
    end 
    pore_coor = pore_coor_after;
    un_pore_coor = un_pore_coor_after;
    %figure;imshow(gray2rgb(I,max_coor,un_coor));
    
elseif filter_mode==2
    %��ͼ�����Ԥ�����õ��ֲ�����ֵ
    se = strel('square', 4);%Ŀǰ��ɹ�����ppt�ֵ�ǡ�3�������fp1.bmp)
    Ie = imerode(I, se);
    Iobr = imreconstruct(Ie, I);
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    max_4 = imregionalmax(Iobrcbr);
    se = strel('square', 4);%Ŀǰ��ɹ�����ppt�ֵ�ǡ�3�������fp1.bmp)
    Ie = imerode(I, se);
    Iobr = imreconstruct(Ie, I);
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    max_5 = imregionalmax(Iobrcbr);
    %Filt the coor according to conditions
    pore_coor_after = [];
    un_pore_coor_after = [];
    for m=1:size(pore_coor,1)
        if max_coor(pore_coor(m,1),pore_coor(m,2))==1 && max_4(pore_coor(m,1),pore_coor(m,2))==0 && max_5(pore_coor(m,1),pore_coor(m,2))==0%���ݻ���ɸѡpore_coor
            pore_coor_after = [pore_coor_after;pore_coor(m,:)];
        else
            max_coor(pore_coor(m,1),pore_coor(m,2))=0;
        end
    end
    for n=1:size(un_pore_coor,1)
        if un_coor(un_pore_coor(n,1),un_pore_coor(n,2))==1 && max_4(un_pore_coor(n,1),un_pore_coor(n,2))==0 && max_5(un_pore_coor(n,1),un_pore_coor(n,2))==0%���ݻ���ɸѡun_pore_coor
            un_pore_coor_after = [un_pore_coor_after;un_pore_coor(n,:)];
        else
            un_coor(un_pore_coor(n,1),un_pore_coor(n,2))=0;
        end
    end 
    pore_coor = pore_coor_after;
    un_pore_coor = un_pore_coor_after;
%     figure;imshow(gray2rgb(I,max_coor,un_coor));
        pore_coor_after = [];
    un_pore_coor_after = [];
    im = max_coor;
    im(un_coor==1)=1;
    scale = 6;
    for i=1:2:imx
        for j=1:2:imy
            if (i-scale/2+1)>=1 && (j-scale/2+1)>=1 && (i+scale/2)<=imx && (j+scale/2)<=imy
                tmp_i_from = i-scale/2+1;
                tmp_i_to = i+scale/2;
                tmp_j_from = j-scale/2+1;
                tmp_j_to = j+scale/2;
                temp = im((tmp_i_from):(tmp_i_to),(tmp_j_from):(tmp_j_to));
                if length(find(temp~=0))>=5
                    im((i-scale/2+1):(i+scale/2),(j-scale/2+1):(j+scale/2)) = 0;
                end
            end
        end
    end
%     se = strel('square', 2);%Ϊ�˽�ʡ������,only necessary in Hongkong database
%     im = imerode(im,se);
    for m=1:size(pore_coor,1)
        if im(pore_coor(m,1),pore_coor(m,2))==1%���ݻ���ɸѡpore_coor
            pore_coor_after = [pore_coor_after;pore_coor(m,:)];
        else
            max_coor(pore_coor(m,1),pore_coor(m,2))=0;
        end
    end
    for n=1:size(un_pore_coor,1)
        if im(un_pore_coor(n,1),un_pore_coor(n,2))==1%���ݻ���ɸѡun_pore_coor
            un_pore_coor_after = [un_pore_coor_after;un_pore_coor(n,:)];
        else
            un_coor(un_pore_coor(n,1),un_pore_coor(n,2))=0;
        end
    end 
    pore_coor = pore_coor_after;
    un_pore_coor = un_pore_coor_after;
%     figure;imshow(gray2rgb(I,max_coor,un_coor));
    
%�ų��������ɫ����suceed!
        pore_coor_after = [];
    un_pore_coor_after = [];
    im = max_coor;
    im(un_coor==1)=1;
    scale = 6;
    for i=1:2:imx
        for j=1:2:imy
            if (i-scale/2+1)>=1 && (j-scale/2+1)>=1 && (i+scale/2)<=imx && (j+scale/2)<=imy
                tmp_i_from = i-scale/2+1;
                tmp_i_to = i+scale/2;
                tmp_j_from = j-scale/2+1;
                tmp_j_to = j+scale/2;
                temp = I((tmp_i_from):(tmp_i_to),(tmp_j_from):(tmp_j_to));
                if sum(sum(temp))>=7200
                    im((i-scale/2+1):(i+scale/2),(j-scale/2+1):(j+scale/2)) = 0;
                end
            end
        end
    end
    for m=1:size(pore_coor,1)
        if im(pore_coor(m,1),pore_coor(m,2))==1%���ݻ���ɸѡpore_coor
            pore_coor_after = [pore_coor_after;pore_coor(m,:)];
        else
            max_coor(pore_coor(m,1),pore_coor(m,2))=0;
        end
    end
    for n=1:size(un_pore_coor,1)
        if im(un_pore_coor(n,1),un_pore_coor(n,2))==1%���ݻ���ɸѡun_pore_coor
            un_pore_coor_after = [un_pore_coor_after;un_pore_coor(n,:)];
        else
            un_coor(un_pore_coor(n,1),un_pore_coor(n,2))=0;
        end
    end 
    pore_coor = pore_coor_after;
    un_pore_coor = un_pore_coor_after;
%      figure;imshow(gray2rgb(I,max_coor,un_coor));

end
   

if mode==1
%��һ���������������pore_coor��(LBP_feature_1)
    num_pores = size(pore_coor,1);%����pore_core�ĸ������ں�����õ���
    [rang_x,rang_y]=size(I);
    mapping=getmapping(8,'ri');
    module_lbp=cell(num_pores,1);
    m=[];
    n=[];
    module_matrix=[];
    for i=1:num_pores  
        m = pore_coor(i,1);%m��y n��x
        n = pore_coor(i,2);
        if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%��һ���ų��˱߽��
            module_matrix=I(m-lbpSize:m+lbpSize,n-lbpSize:n+lbpSize); %��ȡ����ģ��
            module_lbp{i}=lbp(module_matrix,1,8,mapping,'hist');
        end
    end
    LBP_feature_1 = cell2mat(module_lbp);

    
    
%��һ���������������un_pore_coor��(LBP_feature_2)    
    num_un_pores = size(un_pore_coor,1);%����pore_core�ĸ������ں�����õ���
    [rang_x,rang_y]=size(I);
    mapping=getmapping(8,'ri');
    module_lbp=cell(num_un_pores,1);
    m=[];
    n=[];
    module_matrix=[];
    for i=1:num_un_pores  
        m = un_pore_coor(i,1);%m��y n��x
        n = un_pore_coor(i,2);
        if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%��һ���ų��˱߽��
            module_matrix=I(m-lbpSize:m+lbpSize,n-lbpSize:n+lbpSize); %��ȡ����ģ��
            module_lbp{i}=lbp(module_matrix,1,8,mapping,'hist');
        end
    end
    LBP_feature_2 = cell2mat(module_lbp);
    
    
elseif mode==2
    %��һ���������������un_pore_coor��(LBP_feature_2)    
        combine_feature_vector = [];
        num_un_pores = size(un_pore_coor,1);%��ĸ���
        [rang_x,rang_y] = size(I);
        module_lbp=cell(num_un_pores,1);
        m = [];
        n = [];
        module_matrix = [];
        for i=1:num_un_pores  
            m = un_pore_coor(i,1);%m��y n��x
            n = un_pore_coor(i,2);
            if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%��һ���ų��˱߽��
                module_matrix = I(m-lbpSize:m+lbpSize-1,n-lbpSize:n+lbpSize-1); %��ȡ����ģ��
                hist_output = LBP_C(module_matrix);
                combine_feature_vector=[combine_feature_vector;combine_h_feature(hist_output)];
                %module_lbp{i} = cell2mat(hist_output);
            end
        end
        %LBP_feature = cell2mat(module_lbp);%when k=1
        LBP_feature_2 = combine_feature_vector;%when k>1
     
%��һ���������������pore_coor��(LBP_feature_1)
        combine_feature_vector = [];
      num_pores = size(pore_coor,1);%��ĸ���
        [rang_x,rang_y] = size(I);
        module_lbp=cell(num_pores,1);
        m = [];
        n = [];
        module_matrix = [];
        for i=1:num_pores  
            m = pore_coor(i,1);%m��y n��x
            n = pore_coor(i,2);
            if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%��һ���ų��˱߽��
                module_matrix = I(m-lbpSize:m+lbpSize-1,n-lbpSize:n+lbpSize-1); %��ȡ����ģ��
                hist_output = LBP_C(module_matrix);
                combine_feature_vector=[combine_feature_vector;combine_h_feature(hist_output)];
                %module_lbp{i} = cell2mat(hist_output);
            end
        end
        %LBP_feature = cell2mat(module_lbp);%when k=1
        LBP_feature_1 = combine_feature_vector;%when k>1
   

end


end