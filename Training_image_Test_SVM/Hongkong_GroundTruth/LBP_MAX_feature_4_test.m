function [LBP_feature_1,LBP_feature_2] = LBP_MAX_feature_4_test(image_name,mat_name,lbpSize)%�ú����Ƕ���ͼ�����������õ�ͬʱ���㼫��ֵ�ͱ�ǵĶ�Ӧ��������LBP����
%�������ú���������LBP_MAX_feature�ĵط�������ɸѡȥ��һЩ����Ҫ�㡣
%����ͼ���Լ�����
filter_mode=2;%mode����ѡ��ɸѡ��ʽ��"1"������LBP_MAX_feature�Ļ���+�������ڼ��ټ�������ʽ����2���ǲ�ʹ��Ԥ����+����4:6ȥ����+cluster,��3"����LBP_MAX_feature�Ļ���+clusterһ�£���4���ǲ�ʹ��Ԥ����+cluster(�²�RF���ԭ���ǿ���pore�����ˣ�RT���ԭ���Ƿ�poreλ�ñ���̫�ࣩ
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
     


if filter_mode==1
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
        %     figure;imshow(gray2rgb(I,max_coor,un_coor));

        %�û�������ɸѡȥ������ĵ�
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
        %     figure;imshow(gray2rgb(I,max_coor,un_coor));
    
elseif filter_mode==2
                %��I_coor��������
            se_coor = strel('square', 3);
            I_coor = imdilate(I_coor,se_coor);

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
        %     figure;imshow(gray2rgb(I,max_coor,un_coor));
            filter_count=0;%�����˽�,ֻ�Ǽ�¼����
            for filter_parameter=6:6%4:6
                se = strel('square', filter_parameter);%Ŀǰ��ɹ�����ppt�ֵ�ǡ�3�������fp1.bmp)
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
                    if max_coor(pore_coor(m,1),pore_coor(m,2))==1 && max_filter(pore_coor(m,1),pore_coor(m,2),filter_parameter)==0%���ݻ���ɸѡpore_coor
                        pore_coor_after = [pore_coor_after;pore_coor(m,:)];
                    else
                        max_coor(pore_coor(m,1),pore_coor(m,2))=0;
                    end
                end
                for n=1:size(un_pore_coor,1)
                    if un_coor(un_pore_coor(n,1),un_pore_coor(n,2))==1 && max_filter(un_pore_coor(n,1),un_pore_coor(n,2),filter_parameter)==0%���ݻ���ɸѡun_pore_coor
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
            filter_count=0;%�����˽�,ֻ�Ǽ�¼����
            for filter_parameter=4:6
                se = strel('square', filter_parameter);%Ŀǰ��ɹ�����ppt�ֵ�ǡ�3�������fp1.bmp)
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
                    if max_coor(pore_coor(m,1),pore_coor(m,2))==1 && max_filter(pore_coor(m,1),pore_coor(m,2),filter_parameter)==0%���ݻ���ɸѡpore_coor
                        pore_coor_after = [pore_coor_after;pore_coor(m,:)];
                    else
                        max_coor(pore_coor(m,1),pore_coor(m,2))=0;
                    end
                end
                for n=1:size(un_pore_coor,1)
                    if un_coor(un_pore_coor(n,1),un_pore_coor(n,2))==1 && max_filter(un_pore_coor(n,1),un_pore_coor(n,2),filter_parameter)==0%���ݻ���ɸѡun_pore_coor
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
                    %��I_coor��������
            se_coor = strel('square', 3);
            I_coor = imdilate(I_coor,se_coor);

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
            max_coor = max_coor_after;%�����ǵ�����Ҫ
            un_coor = un_coor_after;
%             figure;imshow(gray2rgb(I,max_coor,un_coor));

end



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