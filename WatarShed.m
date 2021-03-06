%% 转灰度，转梯度
rgb=imread('1.bmp');
%rgb = imread('pears.png');
I = rgb2gray(rgb);
subplot(341);imshow(I),title('input image');
I_binary= im2bw(I,graythresh(I));       %对图像二值化
subplot(342);imshow(I_binary,[]), title('binary of input image)')
% I_watershed=watershed(I)%直接分割会出现过度分割的情况
% figure, imshow(I_watershed), title('Watershed transform of original image')
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
%gradmag = sqrt(Ix.^2 + Iy.^2);
Im=double(I);
[ix,iy]=gradient(Im);
gradmag = sqrt(ix.*ix+iy.*iy);
gradmag = uint8(gradmag);
subplot(3,4,11);imshow(gradmag),title('gradmag');
% figure;imshow(gradmag,[]), title('Gradient magnitude (gradmag)')

% L_watershed_gradmag = watershed(gradmag);
% %L = label2rgb(L);
% figure, imshow(L_watershed_gradmag), title('Watershed transform of gradient magnitude')
% %RigionMin = imregionalmin(L_watershed_gradmag);
% RigionMin = imregionalmin(I);%计算原始图像的 regionalmin
% figure;imshow(RigionMin ,[]), title('region minima')
% 
% RigionMin_modified=bwareaopen(RigionMin, 20);
% figure;imshow(RigionMin ,[]), title('modified region minima')
% 
% externalMakers=watershed(RigionMin);
% figure;imshow(externalMakers,[]), title('externalMakers')
%MakerImage = imimposemin(I_binary, RigionMin);
%figure;imshow(MakerImage,[]), title('MakerImage')


%% comput the background markers
% D = bwdist(RigionMin);
% %figure;imshow(D), title('D')
% DL = watershed(D);
% backMakers = DL == 0;
% figure;imshow(DL), title('Watershed ridge lines (bgm)')


%%
%Mark the Foreground Objects
se = strel('square', 3);
%Io = imopen(I, se);
%figure;imshow(Io), title('Opening (Io)')
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
%figure;imshow(Iobr), title('Opening-by-reconstruction (Iobr)')
%Ioc = imclose(Io, se);
% figure;imshow(Ioc), title('Opening-closing (Ioc)')
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
%作用：Calculate the regional maxima of Iobrcbr to obtain good foreground markers.
Iobrcbr = imcomplement(Iobrcbr);%Iobrcbr为经过什么开环闭环重建后的image，暂时不知道有没有用
subplot(343);imshow(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)')
%imreginalmax() 返回该像素与其周围8个像素点比较是否为最大值，是则返回1，否则返回0
fgm = imregionalmin(Iobrcbr);
subplot(344);imshow(fgm), title('Regional minima of opening-closing by reconstruction (fgm)')
I2 = I;%(原来这里是I哦！！！！！想改成Iobrcbr）
I2(fgm) = 255;%将为1的像素点赋值为255(regional minima设置为白色)
%感觉这里I2效果最好
subplot(345); imshow(I2), title('Regional minima  is tapped on original image (I2)')


%%---------------------对foreground Makers进行 modify-------------------%%
%%-------------- 问题应该出现在这里面-------------------------/
%不modified的话fgb太多，最后的结果太复杂，modified的话有fgb太少，最后无法分割
se2 = strel(ones(2,2));
fgm2 = imopen(fgm, se2);
%fgm3 = imreconstruct(fgm2, fgm);  %这句话把好多Rigional minima都给去除了
fgm3 = bwareaopen(fgm2, 5);
I3 = I;
I3(fgm3) = 255;% I3为改善后的原图像的 regional minima,暂时还不知道是否有用 

%subplot(346);imshow(fgm3);title('Modified regional maxima superimposed on original image (fgm4)')

%%
%Compute Background Markers
%bw1 = im2bw(Iobrcbr, graythresh(Iobrcbr));
bw1 = im2bw(I3, graythresh(I3)); %二值化(I2就是加了白块的I)
%subplot(3,4,12);imshow(bw1),title('binary of I2')
D = bwdist(bw1);
DL = watershed(D);
bgm = DL == 0; %bgm一开始是0，然后将DL中值为0的像素点赋值给 bgm为1
fgm3(bgm)=255;
subplot(347); imshow(fgm3), title('bgm')
bw1(fgm3)=255;
subplot(346);imshow(bw1)

backMaker=watershed(im2bw(I2, graythresh(I2)));
subplot(348);imshow(backMaker),title('my_backMaker')
gradmag2 = imimposemin(gradmag,fgm|bgm);
gradmag2=uint8(gradmag2);
%subplot(3,4,12);imshow(gradmag2),title('gradmag2')
%gradmag2 = imimposemin(gradmag,fgm4);
subplot(3,4,12); imshow(gradmag2), title('gradmag2')
L = watershed(gradmag2);
subplot(349);imshow(label2rgb(L)),title('final result')
I4 = I;
I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;
subplot(3,4,10);imshow(I4);title('Markers and object boundaries superimposed on original image (I4)')
% I5=I;
% I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;