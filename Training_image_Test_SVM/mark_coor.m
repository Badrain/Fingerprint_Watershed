function [coor_insert,coor_delete] = mark_coor(im_gray,coor_image)%�������ã���ԭͼ�����б��һ����ʾ���������ֶ���ȫ��Ǻ�ɾ�����
    %�������ԭͼ��pore����������

    %������ԵĻ�������һ���������ܣ�������������������������������������
    im = imread(im_gray);
    se = strel(ones(3,3));
    coor=imdilate(coor_image,se);%���ͺ�㣬Ŀ���ǿ������һ��
    coor_insert=[];
    coor_delete=[];
    IM = gray2rgb(im,coor_image);
    figure;imshow(IM);                  %��ʾͼƬ
    hold on;
    while(1)
        [x,y,button]=ginput(1);
        if button==1%������
            plot(x,y,'p', 'MarkerSize', 6, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');
            [x,y]
            coor_insert=[coor_insert;[x,y]];
        elseif button==3%�Ҽ����
            plot(x,y,'p', 'MarkerSize', 6, 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g');
            coor_delete=[coor_delete;[x,y]];
        elseif button==2%�м�������˳�
            break;
        end
    end
    
end