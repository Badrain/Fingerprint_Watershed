function IM = gray2rgb(im_gray,varargin)

num = numel(varargin);

%im_gray=im_gray*255;

d = size(im_gray);
rgb = zeros(d(1),d(2),3);
IM1 = rgb(:,:,1);
IM2 = rgb(:,:,2);
IM3 = rgb(:,:,3);
IM1=im_gray;IM2=im_gray;IM3=im_gray;
if num >= 1
    coor = varargin{1};
    coor = im2bw(coor,graythresh(coor));
    IM1(coor) = 255; IM2(coor) = 0; IM3(coor) = 0;
end
if num >= 2
    un_coor = varargin{2};
    un_coor = im2bw(un_coor,graythresh(un_coor));
    IM1(un_coor) = 0; IM2(un_coor) = 0; IM3(un_coor) = 255;
IM = cat(3,IM1,IM2,IM3);
end