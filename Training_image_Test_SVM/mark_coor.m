function [coor_insert,coor_delete] = mark_coor(im_gray,coor_image)%函数作用：将原图与已有标记一起显示出，并且手动补全标记和删除标记
    %输入的是原图和pore点中心坐标

    %如果可以的话，设置一个撤销功能！！！！！！！！！！！！！！！！！！！
    im = imread(im_gray);
    se = strel(ones(3,3));
    coor=imdilate(coor_image,se);%膨胀红点，目的是看的清楚一点
    coor_insert=[];
    coor_delete=[];
    IM = gray2rgb(im,coor_image);
    figure;imshow(IM);                  %显示图片
    hold on;
    while(1)
        [x,y,button]=ginput(1);
        if button==1%左键点击
            plot(x,y,'p', 'MarkerSize', 6, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');
            [x,y]
            coor_insert=[coor_insert;[x,y]];
        elseif button==3%右键点击
            plot(x,y,'p', 'MarkerSize', 6, 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g');
            coor_delete=[coor_delete;[x,y]];
        elseif button==2%中键点击则退出
            break;
        end
    end
    
end