%前三幅图建议重新标记一下（第20幅图注意一下，可能噪声太大）
clc;
clear;
all_coor_store = {};
for i=1:200
    image_name = strcat('1 (', num2str(i),').jpg');
    bgm = watershed_stepone(image_name);
    [IM,new_coor,coor_image] = watershed_steptwo(bgm, 'binary');
    %figure;imshow(IM);
    [coor_insert,coor_delete] = mark_coor(image_name,coor_image);
    [new_coor_after,coor_image_after] = store_coor(new_coor,coor_image,coor_insert,coor_delete);
    im = gray2rgb(imread(image_name),coor_image_after);
    %all_coor_store{i} = new_coor_after;
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
