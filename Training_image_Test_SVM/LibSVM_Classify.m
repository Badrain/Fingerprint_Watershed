Positive_LBP_feature = [];
%% ȡ����ֵ����ԭ����ƥ��
for i=1:20
    image_name = strcat('1 (',num2str(i),').jpg');
    mat_name = strcat('1 (',num2str(i),').mat');
    load(mat_name);%�õ�����new_coor_after�ļ�
    
    LBP_feature = LBP_feature(image_name,mat_name,16);
    Positive_LBP_feature = [Positive_LBP_feature;LBP_feature];
end

%% 

I=imread('1 (5).jpg');
se = strel('square', 2);%%%%%%%%Ŀǰ��ɹ�����ppt���ֵ�ǡ�3������Ե���fp1.bmp)
%Io = imopen(I, se);
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
%Ioc = imclose(Io, se);
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
%���ã�Calculate the regional maxima of Iobrcbr to obtain good foreground markers.
Iobrcbr = imcomplement(Iobrcbr);%IobrcbrΪ����ʲô�����ջ��ؽ����image����ʱ��֪����û����
%subplot(343);imshow(Iobrcbr), title('(Iobrcbr)')
fgm = imregionalmax(Iobrcbr);
IM=gray2rgb(I,fgm);
figure;imshow(IM);