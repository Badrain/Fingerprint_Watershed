%前三幅图建议重新标记一下（第20幅图注意一下，可能噪声太大）
clc;
clear;
all_coor_store = {};
for i=1:20
    image_name = strcat('1 (', num2str(i),').jpg');
    mat_name = strcat('1 (', num2str(i),').mat');
    im = imread(image_name);
    imx = size(im,1);
    imy = size(im,2);
    coor_image = zeros(imx,imy);
    un_coor = zeros(imx,imy);
    if exist(image_name,'file')==1          %!如果已经改过的话用改过的坐标
        load(mat_name);%读入new_coor_after
        new_coor = new_coor_after;
        %想要初始化new_coor_after =
        for j=1:size(new_coor,1)
            for k=1:size(new_coor,2)
                coor_image(i,j)=1;%这一块是要把coor_image给搞定
            end
        end
        coor_image = im2bw(coor_image,graythresh(coor_image));
    else bgm = watershed_stepone(image_name);%!如果没有改过，重新开始提取
         [IM,new_coor,coor_image] = watershed_steptwo(bgm, 'binary');
    end
    [coor_insert,coor_delete] = mark_coor(image_name,coor_image);
    [new_coor_after,coor_image_after] = store_coor(new_coor,coor_image,coor_insert,coor_delete);
    un_coor = show_un_coor(image_name,mat_name);%%%%%%%%%%%%%%%%目前有问题！只能操作一次不能悔改
    im = gray2rgb(imread(image_name),coor_image_after,un_coor);%%%%%%%%%%%%%%%%目前有问题！只能操作一次不能悔改
    coor_name = strcat('1 (',num2str(i),').mat');
    figure;imshow(im); 
    hold on;
    [~,~,button]=ginput(1);
    if button==3%此时如果发现有不满意的地方，按右键还有一次修改机会。
        [coor_insert,coor_delete] = mark_coor(image_name,coor_image_after);
        [new_coor_after_after,coor_image_after_after] = store_coor(new_coor_after,coor_image_after,coor_insert,coor_delete);    %输入的应该是前面一步处理过的
        coor_image_after = coor_image_after_after;
        new_coor_after = new_coor_after_after;
        im = gray2rgb(imread(image_name),coor_image_after);
        figure;imshow(im); 
        hold on;
        [~,~,button2]=ginput(1);
        if button2==2
            save(coor_name,'new_coor_after');
        else break;
        end
    elseif button==2
        save(coor_name,'new_coor_after');
    end
        
end
