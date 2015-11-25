function LBP_feature = LBP_MAX_feature(image_name,mat_name,lbpSize)%�ú����Ƕ���ͼ�����������õ�ͬʱ���㼫��ֵ�ͱ�ǵĶ�Ӧ��������LBP����

    %����ͼ���Լ�����
    I=imread(image_name);
    load(mat_name);%�õ�����new_coor_after�ļ�
    mat_name_after = [];
    for i=1:size(new_coor_after,1)
        if new_coor_after(i,3)==1
            mat_name_after = [mat_name_after;new_coor_after(i,1:2)];%�õ���"mat_name_after"��ȥ���˱�ǡ�0������������
        end
    end
    num_pores = size(mat_name_after,1);%��ĸ���
    
    %��ͼ�����Ԥ�����õ��ֲ�����ֵ
    se = strel('square', 2);%Ŀǰ��ɹ�����ppt�ֵ�ǡ�3�������fp1.bmp)
    Ie = imerode(I, se);
    Iobr = imreconstruct(Ie, I);
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    max = imregionalmax(Iobrcbr);
    
    %�жϸ������Ƿ�Ҳͬʱ���Ͼֲ�����ֵ
    max_coor_flag=0;
    for i=size(mat_name_after,1)%%%%%%!!!!!!!!!!!!!!!!!!!!!!���ܳ��������ǹ���ͼ��߽磡����
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
        m = mat_name_after(i,1);%m��y n��x
        n = mat_name_after(i,2);
        if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%��һ���ų��˱߽��
            module_matrix=I(m-lbpSize:m+lbpSize,n-lbpSize:n+lbpSize); %��ȡ����ģ��
            module_lbp{i}=lbp(module_matrix,1,8,mapping,'hist');
        end

    end
    LBP_feature = cell2mat(module_lbp);


end