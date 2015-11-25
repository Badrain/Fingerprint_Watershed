function [new_coor_after,coor_image_after] = store_coor(new_coor,coor_image,coor_insert,coor_delete)%该函数是用来将每一幅标记完成的图像存储（new_coor)并显示出来（coor_image）
%这里的坐标new_coor_after是又加上了一列标识列,"1"表示有用的，“0”表示delete的
    new_coor_after=new_coor;%%%C++里用链表实现
    coor_image_after=coor_image;
    if size(new_coor_after,2)==2
        new_coor_after = [new_coor_after,ones(size(new_coor,1),1)];%这一步只是针对第一次标记的（如果不满意修改的话不需要添加新的一列了）
    end
    %将delete删除（方法就是加“0”的标记）
    for i=1:size(new_coor_after,1)
        for j=1:size(coor_delete,1)
            x1=new_coor_after(i,1);%第几行
            y1=new_coor_after(i,2);%第几列，所以注意下面我要反过来了。
            y2=coor_delete(j,1);
            x2=coor_delete(j,2);
            if sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))<3
                new_coor_after(i,3)=0;%有错误的话，一开始的时候加一列“1”
                coor_image_after(x1,y1)=0;
            end
        end
    end
            
    %将insert添加（方法就是接在后面）
    coor_insert = round(coor_insert);
    new_coor_after=[new_coor_after;[coor_insert(:,2),coor_insert(:,1),ones(size(coor_insert,1),1)]];%同样是因为行列和坐标是相反的,!!!!!!!!也就是说，new_coor_after里面第一列是行是y，第二列是列是x
    for i=1:size(coor_insert,1)
        x=coor_insert(i,2);
        y=coor_insert(i,1);
        coor_image_after(x,y)=1;
    end
    se = strel(ones(3,3));
    coor=imdilate(coor_image_after,se);%膨胀红点，目的是看的清楚一点
    %figure;imshow(coor);






end