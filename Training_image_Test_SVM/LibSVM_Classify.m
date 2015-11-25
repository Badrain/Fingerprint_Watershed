Positive_LBP_feature = [];
%% 取极大值并与原坐标匹配
for i=1:20
    image_name = strcat('1 (',num2str(i),').jpg');
    mat_name = strcat('1 (',num2str(i),').mat');
    load(mat_name);%得到的是new_coor_after文件
    
    LBP_feature = LBP_feature(image_name,mat_name,16);
    Positive_LBP_feature = [Positive_LBP_feature;LBP_feature];
end

%% 

I=imread('1 (5).jpg');
se = strel('square', 2);%%%%%%%%目前最成功的在ppt里的值是“3”（针对的是fp1.bmp)
%Io = imopen(I, se);
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
%Ioc = imclose(Io, se);
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
%作用：Calculate the regional maxima of Iobrcbr to obtain good foreground markers.
Iobrcbr = imcomplement(Iobrcbr);%Iobrcbr为经过什么开环闭环重建后的image，暂时不知道有没有用
%subplot(343);imshow(Iobrcbr), title('(Iobrcbr)')
fgm = imregionalmax(Iobrcbr);
IM=gray2rgb(I,fgm);
figure;imshow(IM);