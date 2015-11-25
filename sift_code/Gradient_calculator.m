function  [grad_magnitude grad_angle]  = Gradient_calculator(image_name)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
im=im2double(imread(image_name));
%im=rgb2gray(im);
[x y]=size(im);
t=maketform('affine',[(800/y) 0 0;0 (600/x) 0;0 0 1]);
%im=imtransform(im,t);
f=[1 0 -1];
temp_grad_x=double(ones(size(im)));
temp_grad_y=double(ones(size(im)));

    temp_grad_x(:,:)=imfilter(im(:,:),f,'replicate');
    temp_grad_y(:,:)=imfilter(im(:,:),f','replicate');

grad_magnitude=sqrt(temp_grad_x.^2+temp_grad_y.^2);
grad_angle=atan(abs(temp_grad_y./temp_grad_x));

%dlmwrite('a.txt',grad_angle,'\n')


end

