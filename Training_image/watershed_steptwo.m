function [IM,new_coor,coor_image]=watershed_steptwo(bgm,image_type)
%image_type是'binary'或者'rgb'
coor = line_scan(bgm,3,7);%第一个数字是下阈值，第二个是上阈值
[new_coor,coor_image] = coor_cluster(coor,7);%数字代表聚类的距离阈值
se = strel(ones(3,3));
coor=imdilate(coor_image,se);%膨胀红点，目的是看的清楚一点
%figure;imshow(coor);
%coor=coor_image;

if strcmp(image_type,'binary')
    bgm=bgm*255;
    d = size(bgm);
    rgb = zeros(d(1),d(2),3);
    IM1 = rgb(:,:,1);
    IM2 = rgb(:,:,2);
    IM3 = rgb(:,:,3);
    IM1=bgm;IM2=bgm;IM3=bgm;
    IM1(coor) = 255; IM2(coor) = 0; IM3(coor) = 0;
    IM = cat(3,IM1,IM2,IM3);
%     for i=1:size(new_coor,1)
%         plot(new_coor(i,2),new_coor(i,1),'r');%%%%%这里注意，横纵坐标是反的！！！
%     end
elseif strcmp(image_type,'rgb')
    IM1 = rgb(:,:,1);
    IM2 = rgb(:,:,2);
    IM3 = rgb(:,:,3);
    IM1(coor) = 0; IM2(coor) = 0; IM3(coor) = 255;
    IM1(fgm3) = 255; IM2(fgm3) = 0; IM3(fgm3) = 0;
    IM1(bgm) = 0; IM2(bgm) = 255; IM3(bgm) = 0;
    IM = cat(3,IM1,IM2,IM3);
end
    %figure;imshow(IM);

%     [imx,imy]=size(IM);
%     mm = zeros(imx,imy,3);
%     mm1=mm(:,:,1);
%     mm2=mm(:,:,2);
%     mm3=mm(:,:,3);
%     mm1=D/10*256;
%     mm2=D/10*256;
%     mm3=D/10*256;
%     mm1(bgm)=0; mm2(bgm)=255; mm3(bgm)=0;
%     MM = cat(3,mm1,mm2,mm3);
%     %figure;imshow(MM);
% 
% 
% 
% 
%     Db = bwdist(I_binary);
%     DLb = watershed(Db);
% %figure;imshow(label2rgb(DLb));
% end