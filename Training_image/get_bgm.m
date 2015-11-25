function bgm= get_bgm( input )

%% 读入图片
%rgb=imread('fp1.bmp');
%I=imread(input);
%I=rgb2gray(I);
I=input;
%figure;imshow(I);title('before transform');



% [m,n]=size(I)
% mm=m/2;
% nn=m/2;
% I1=I(1:mm,1:nn);
% I2=I(mm+1:m,1:nn);
% I3=I(1:mm,nn+1:n);
% I4=I(mm+1:m,nn+1:n);
% c1=median(I1(:));
% threhold1=median(c1(:));
% 
% c2=median(I2(:));
% threhold2=median(c2(:));
% 
% c3=median(I3(:));
% threhold3=median(c3(:));
% 
% c4=median(I4(:));
% threhold4=median(c4(:));
% 
% for i=1:mm
%     for j=1:nn
%         if(I1(i,j)<threhold1)
%             I1(i,j)=0;
%         end
%          if(I2(i,j)<threhold2)
%              I2(i,j)=0;
%          end
%           if(I3(i,j)<threhold3)
%              I3(i,j)=0;
%           end
%             if(I4(i,j)<threhold4)
%              I4(i,j)=0;
%             end      
%         end
% end
% I_combine=zeros(m,n);
% I_combine(1:mm,1:nn)=I1;
% I_combine(mm+1:m,1:nn)=I2;
% I_combine(1:mm,nn+1:n)=I3;
% I_combine(mm+1:m,nn+1:n)=I4;
% figure;imshow(I_combine);title('after transform');
% I=I_combine;
%subplot(341);imshow(I),title('input image');
I_binary = im2bw(I,graythresh(I));       %对图像二值化
%subplot(342);imshow(I_binary,[]), title('binary of input image)')
% I_watershed=watershed(I)%直接分割会出现过度分割的情况
% figure, imshow(I_watershed), title('Watershed transform of original image')
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);


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
%subplot(343);imshow(Iobrcbr), title('(Iobrcbr)')
%imreginalmax() 返回该像素与其周围8个像素点比较是否为最大值，是则返回1，否则返回0
fgm = imregionalmin(Iobrcbr);
fgm_min = imextendedmin(Iobrcbr, 0.35);
%fgm_min = imregionalmin(fgm_min);
%subplot(3,4,10); imshow(fgm_min),title('fgm_extendedmin');
copy_Iobrcbr=Iobrcbr;
%subplot(344);imshow(fgm), title('fgm')
I2 = I;
I2(fgm) = 255;%将为1的像素点赋值为255(regional minima设置为白色)
%subplot(345); imshow(I2), title('I2')
%% k-means处理fgm
[m,n]=size(fgm);
mn=m*n;
for x=1:m
    for y=1:n
        if(fgm(x,y)==0)
            Iobrcbr(x,y)=0;
        end
    end
end
[px_regmin,py_regmin]=find(Iobrcbr~=0);%寻找矩阵中非零元素的坐标
NotZero=find(Iobrcbr~=0);%寻找矩阵中非零元素的索引
pxy=[px_regmin,py_regmin];%列向量合成矩阵
tempVecKmeans=Iobrcbr(:);%按照列来排序，变成一列
vector_for_kmeans=tempVecKmeans(tempVecKmeans~=0);%提取非零元素作为Kmeans的输入
%[kmeans_result,C,sumD,D]=kmeans(vector_for_kmeans,3,'dist','sqEuclidean','rep',10,'emptyaction','singleton');
%[kmeans_result,C] =      kmeans(vector_for_kmeans,3,'distance','cosine','start','sample', 'emptyaction','singleton');
vector_for_kmeans=double(vector_for_kmeans);
kmeans_result = kmeans(vector_for_kmeans,2,'dist','sqEuclidean','rep',10,'emptyaction','singleton');
%kmeans_result;
vecLength=length(kmeans_result);
%以下是要选择小的那一组
p1=sum(vector_for_kmeans(kmeans_result==1))/length(vector_for_kmeans(kmeans_result==1));
p2=sum(vector_for_kmeans(kmeans_result==2))/length(vector_for_kmeans(kmeans_result==2));
if p1>=p2
    i=2;
else i=1;
end
for x=1:vecLength
    if(kmeans_result(x)==i) %将fgm中的某些点变为为黑点
       NotZero(x)=0;
    end
end
NotZero_index=NotZero;
%[notzero_size,aa]=size(px_regmin);
% for i=1:notzero_size
%     if(pxy_new(i,:)==0)
%         NotZero_index(i)=0;
%     end
% end
NotZero_index(NotZero_index==0)=[];%把不为0的元素提取出来，形成新的向量,新向量为fgm中
                                   %需要剔除的点的索引
copy_fgm=fgm;
copy_fgm(NotZero_index)=0;
I5=I;
I5(copy_fgm)=255;
%subplot(346); imshow(copy_fgm), title('After K-means,fgm')
%subplot(347); imshow(I5), title('After K-means,I5')
%%对foreground Makers进行 modify,貌似没鸟用，fgm4全部变成0了-------------------%%
%%-------------- 问题应该出现在这里面-------------------------/
%不modified的话fgb太多，最后的结果太复杂，modified的话有fgb太少，最后无法分割
%copy_fgm = fgm_min;
se2 = strel(ones(2,2));
fgm2 = imopen(copy_fgm, se2);
%fgm3 = imreconstruct(fgm2, fgm);  %这句话把好多Rigional minima都给去除了
fgm3 = bwareaopen(fgm2, 5);
I3 = I;
%I3(fgm3) = 0;% I3为改善后的原图像的 regional minima,暂时还不知道是否有用 
I3 = imimposemin(I3,fgm3);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%关键，用的是fgm3（kmeans过的）
%subplot(348);imshow(I3);title('fgm3')
%%
%Compute Background Markers
%bw1 = im2bw(Iobrcbr, graythresh(Iobrcbr));
bw1 = im2bw(I3, graythresh(I3)); %二值化
%figure;imshow(bw1), title('binary of I2')
D = bwdist(bw1);
DL = watershed(D);
bgm = DL == 0; %bgm一开始是0，然后将DL中值为0的像素点赋值给 bgm为1
%bgm = imread('fp3.png');
%bgm = im2bw(bgm, graythresh(bgm));
%subplot(349); imshow(bgm), title('bgm')

% backMaker=watershed(im2bw(I5, graythresh(I5)));
% figure;imshow(backMaker),title('my_backMaker')
gradmag2 = imimposemin(gradmag,fgm3|bgm);
%gradmag2 = imimposemin(gradmag,fgm4);
%figure; imshow(gradmag2), title('gradmag2')
L = watershed(gradmag2);
LL = L == 0;
%subplot(3,4,11);imshow(LL),title('final result')
%figure;imshow(LL);
%figure;imshow(bgm);
L_orig=watershed(gradmag);
%subplot(3,4,12);imshow(L_orig),title('FINAL RESULT')
I4 = I;
I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm3) = 255;
%subplot(3410);imshow(I4);title('Markers and object boundaries superimposed on original image (I4)')
% I5=I;
% I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;
%figure;imshow(bgm);

end

