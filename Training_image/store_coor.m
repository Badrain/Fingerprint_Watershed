function [new_coor_after,coor_image_after] = store_coor(new_coor,coor_image,coor_insert,coor_delete)%�ú�����������ÿһ�������ɵ�ͼ��洢��new_coor)����ʾ������coor_image��
%���������new_coor_after���ּ�����һ�б�ʶ��,"1"��ʾ���õģ���0����ʾdelete��
    new_coor_after=new_coor;%%%C++��������ʵ��
    coor_image_after=coor_image;
    if size(new_coor_after,2)==2
        new_coor_after = [new_coor_after,ones(size(new_coor,1),1)];%��һ��ֻ����Ե�һ�α�ǵģ�����������޸ĵĻ�����Ҫ����µ�һ���ˣ�
    end
    %��deleteɾ�����������Ǽӡ�0���ı�ǣ�
    for i=1:size(new_coor_after,1)
        for j=1:size(coor_delete,1)
            x1=new_coor_after(i,1);%�ڼ���
            y1=new_coor_after(i,2);%�ڼ��У�����ע��������Ҫ�������ˡ�
            y2=coor_delete(j,1);
            x2=coor_delete(j,2);
            if sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))<3
                new_coor_after(i,3)=0;%�д���Ļ���һ��ʼ��ʱ���һ�С�1��
                coor_image_after(x1,y1)=0;
            end
        end
    end
            
    %��insert��ӣ��������ǽ��ں��棩
    coor_insert = round(coor_insert);
    new_coor_after=[new_coor_after;[coor_insert(:,2),coor_insert(:,1),ones(size(coor_insert,1),1)]];%ͬ������Ϊ���к��������෴��,!!!!!!!!Ҳ����˵��new_coor_after�����һ��������y���ڶ���������x
    for i=1:size(coor_insert,1)
        x=coor_insert(i,2);
        y=coor_insert(i,1);
        coor_image_after(x,y)=1;
    end
    se = strel(ones(3,3));
    coor=imdilate(coor_image_after,se);%���ͺ�㣬Ŀ���ǿ������һ��
    %figure;imshow(coor);






end