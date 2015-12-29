function Ferly_show_svm_LBP_test(image_name,mat_name,predict_label,lbpSize)
%�ú�������figure��svm_test�Ľ��

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
  
% %% �û�������ɸѡȥ������ĵ�
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
%         se = strel('square', 2);%Ϊ�˽�ʡ������
%     im = imerode(im,se);
% 
%     for m=1:size(pore_coor,1)
%         if im(pore_coor(m,1),pore_coor(m,2))==1%���ݻ���ɸѡpore_coor
%             pore_coor_after = [pore_coor_after;pore_coor(m,:)];
%         else
%             max_coor(pore_coor(m,1),pore_coor(m,2))=0;
%         end
%     end
%     for n=1:size(un_pore_coor,1)
%         if im(un_pore_coor(n,1),un_pore_coor(n,2))==1%���ݻ���ɸѡun_pore_coor
%             un_pore_coor_after = [un_pore_coor_after;un_pore_coor(n,:)];
%         else
%             un_coor(un_pore_coor(n,1),un_pore_coor(n,2))=0;
%         end
%     end 
% 
%     pore_coor = pore_coor_after;
%     un_pore_coor = un_pore_coor_after;
% 
    
    
    
    num_pores = size(pore_coor,1);%����pore_core�ĸ������ں�����õ���
    [rang_x,rang_y]=size(I);
    m=[];
    n=[];
    pore_coor_after = [];
    un_pore_coor_after = [];
    for i=1:num_pores  
        m = pore_coor(i,1);%m��y n��x
        n = pore_coor(i,2);
        if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%��һ���ų��˱߽��
            pore_coor_after = [pore_coor_after;pore_coor(i,1:2)];
        end
    end
    
    num_un_pores = size(un_pore_coor,1);%����pore_core�ĸ������ں�����õ���
    [rang_x,rang_y]=size(I);
    m=[];
    n=[];
    for i=1:num_un_pores  
        m = un_pore_coor(i,1);%m��y n��x
        n = un_pore_coor(i,2);
        if ( m>lbpSize && n>lbpSize && m<rang_x-lbpSize && n<rang_y-lbpSize )%��һ���ų��˱߽��
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
