close all;
clear all;
clc;
I=imread('SnakeBmp.bmp') ;
I1=imreadbw('SnakeBmp.bmp') ; I1c = I1 ;I11c=I1;
I1=imsmooth(I1,.1) ;
I1=imresize(I1,1);
I=imresize(I,1);
I1=I1-min(I1(:)) ;
I1=I1/max(I1(:)) ;
S=3 ;
num_frame=50;
num_sift=50;
[row,col]=size(I1);
xmin=0;
xmax=0;
ymin=0;
ymax=0;
p=8;const_p=20;sum_p=p*p;mj=1;p_row=row/p;p_col=col/p;bool=0;mi=1;temp(mi)=1;
%获得关键点描述子
fprintf('Computing frames and descriptors.\n') ;
[frames1,descr1,gss1,dogss1] = sift( I1, 'Verbosity', 1, 'Threshold', ...
                                     0.1, 'NumLevels', S ) ;

[fra_i,fra_j]=size(frames1);
rand_num=randperm(sum_p);
rand_sel=rand_num(1:const_p);

for i=1:const_p
    bool=0;
    sel_num=rand_sel(i);
    sel_fix=fix(sel_num/p)+1;
    sel_rem=rem(sel_num,p);
    if sel_rem==0
        sel_rem=p;
    end
    sel_row_rd=sel_fix*p_row;
    sel_col_rd=sel_rem*p_col;
    sel_row_lu=sel_row_rd-p_row+1;
    sel_col_lu=sel_col_rd-p_col+1;
    for j=1:fra_j
        if frames1(1,j)<sel_col_rd && frames1(1,j)>sel_col_lu && frames1(2,j)<sel_row_rd && frames1(2,j)>sel_row_lu
       
            sdescr(:,mj)=descr1(:,j);
            sframes(:,mj)=frames1(:,j);
            mj=mj+1;
            bool=1;
        end
    end
    if bool==1
       
       de{mi}=sdescr(:,temp(mi):(mj-1));
       fr{mi}=sframes(:,temp(mi):(mj-1));
       
       mi=mi+1;
       temp(mi)=mj;
    end
end
%排序
for i=1:(mi-1)
    [bta,ind]=sort(fr{i}(4,:));
    [ind_i,ind_j]=size(ind);
    for j=1:ind_j
        sde{1,i}(:,j)=de{1,i}(:,ind(j));
    end
    varargout{i,1}=pca(sde{1,i}, 1, 'svd');
end
%varargout_mat=cell2mat(varargout);
%rand_I1=randperm(fra_j);
%rdescr1=descr1(:,rand_I1(1:num_sift));
%rframes1=frames1(:,rand_I1(1:num_sift));
%[rframes1_row,rframes1_col]=size(rframes1);
%for i=1:rframes1_col
    %rframes_1(1,rframes1_col)=fix(rframes1(1,rframes1_col));
    %rframes_1(2,rframes1_col)=fix(rframes1(2,rframes1_col));
%    ra=fix(rframes1(1,rframes1_col));
%    rb=fix(rframes1(2,rframes1_col));
%    ra_p1=ra-p;
%    ra_p2=ra+p;
%    rb_p1=rb-p;
 %   rb_p2=rb+p;
%end
                                
drawnow ;
figure(1);imshow(I);

%图1SIFT描述子图片显示
figure(2) ; set(gcf,'Position',[10 10 1024 512]) ;
figure(2) ; clf ;
tightsubplot(1,1);
imagesc(I) ; colormap gray ; axis image ; hold on ;
%h=plotsiftframe( frames1 ) ; set(h,'LineWidth',1,'Color','g') ;
h=plotsiftframe( frames1(:,:) ) ; set(h,'LineWidth',1,'Color','g') ;
h=plot(frames1(1,1),frames1(2,1),'r.') ;
%if(fra_j>=num_frame)
%   rand_sel=randperm(fra_j);
   %h=plot(frames1(1,rand_sel(1:num_frame)),frames1(2,rand_sel(1:num_frame)),'r.') ;
%   h=plot(frames1(1,1),frames1(2,1),'r.') ;
%end

%if(fra_j<num_frame)
%   rand_sel=randperm(fra_j);
   %h=plot(frames1(1,rand_sel(1:fra_j)),frames1(2,rand_sel(1:fra_j)),'r.') ;
%   h=plot(frames1(1,1),frames1(2,1),'r.') ;
%end

%h=plot(frames1(1,matches(1,:)),frames1(2,matches(1,:)),'r.') ;

for k=1:fra_j
    frames_1k=fix(frames1(1,k));
    frames_2k=fix(frames1(2,k));
    if(frames_1k>xmin && frames_1k<xmax && frames_2k>ymin && frames_2k<ymax)
        %frames_copy(:,k)=frames1(:,k);
        %descr_copy(:,k)=descr1(:,k);
        frames1(:,k)=0;
        descr1(:,k)=0;
    end
end
figure(3) ; set(gcf,'Position',[10 10 1024 512]) ;
figure(3) ; clf ;
tightsubplot(1,1);
imagesc(I) ; colormap gray ; axis image ; hold on ;
M=9;N=9;
[xt, yt] = meshgrid(round(linspace(1, size(I, 1), M)), ...
    round(linspace(1, size(I, 2), N)));%生成数据点矩阵
mesh(yt, xt, zeros(size(xt)), 'FaceColor', ...
    'None', 'LineWidth', 1, ...
    'EdgeColor', 'r');%绘制三维网格图
%h=plotsiftframe( frames1 ) ; set(h,'LineWidth',1,'Color','g') ;
%h=plotsiftframe( frames_copy(:,:) ) ; set(h,'LineWidth',1,'Color','g') ;
h=plotsiftframe( frames1(:,:) ) ; set(h,'LineWidth',1,'Color','g') ;
h=plot(frames1(1,1),frames1(2,1),'r.') ;
%x=1:8;y=1:8;
%M=meshgrid(x,y);
MOV(1)=getframe ;



















