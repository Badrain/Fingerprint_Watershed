clc;
clear;
all_coor_store = {};
for i=2:20
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
        [new_coor_after,coor_image_after] = store_coor(new_coor,coor_image,coor_insert,coor_delete);    
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
