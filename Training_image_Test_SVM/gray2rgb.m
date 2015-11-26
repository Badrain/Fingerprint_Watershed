function IM = gray2rgb(im_gray,coor)

%im_gray=im_gray*255;
coor = im2bw(coor,graythresh(coor));
d = size(im_gray);
rgb = zeros(d(1),d(2),3);
IM1 = rgb(:,:,1);
IM2 = rgb(:,:,2);
IM3 = rgb(:,:,3);
IM1=im_gray;IM2=im_gray;IM3=im_gray;
IM1(coor) = 255; IM2(coor) = 0; IM3(coor) = 0;
IM = cat(3,IM1,IM2,IM3);
end
