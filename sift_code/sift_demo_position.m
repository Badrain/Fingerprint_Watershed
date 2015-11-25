nexp = 2 ;
switch nexp
  case 1
    I1=imreadbw('data/landscape-a.jpg') ; % I1=I1(1:2:end,:) ;
    I2=imreadbw('data/landscape-b.jpg') ; % I2=I2(1:2:end,:) ;
    I1c=double(imread('data/landscape-a.jpg'))/255.0 ;
    I2c=double(imread('data/landscape-b.jpg'))/255.0 ;
    
  case 2
    %I1=imreadbw('data/vessel-1.pgm') ; I1c = I1 ;
    %I2=imreadbw('data/vessel-2.pgm') ; I2c = I2 ;
    I1=imreadbw('F:\LDA\LDA_Image\1.bmp') ; I1c = I1 ;I11c=I1;
    I2=imreadbw('F:\LDA\LDA_Image\2.bmp') ; I2c = I2 ;
    I3=imreadbw('F:\LDA\LDA_Image\4.bmp') ; I3c = I3 ;
end
%读取图片并光滑
I1=imsmooth(I1,.1) ;
I2=imsmooth(I2,.1) ;
I3=imsmooth(I3,.1) ;

I1=I1-min(I1(:)) ;
I1=I1/max(I1(:)) ;
I2=I2-min(I2(:)) ;
I2=I2/max(I2(:)) ;
I3=I3-min(I3(:)) ;
I3=I3/max(I3(:)) ;

S=3 ;
%获得关键点描述子
fprintf('Computing frames and descriptors.\n') ;
[frames1,descr1,gss1,dogss1] = sift( I1, 'Verbosity', 1, 'Threshold', ...
                                     0.005, 'NumLevels', S ) ;
[frames2,descr2,gss2,dogss2] = sift( I2, 'Verbosity', 1, 'Threshold', ...
                                     0.005, 'NumLevels', S ) ;
[frames3,descr3,gss3,dogss3] = sift( I3, 'Verbosity', 1, 'Threshold', ...
                                     0.005, 'NumLevels', S ) ;
%figure(11) ; clf ; plotss(dogss1) ; colormap gray ;
%figure(12) ; clf ; plotss(dogss2) ; colormap gray ;
drawnow ;
%获得最后四个描述子
frames11 = frames1(:,end-3:end);
frames22 = frames2(:,end-3:end);
frames33 = frames3(:,end-3:end);
%部分描述子在图片上显示
figure(2) ; clf ;
tightsubplot(2,2,1) ; imagesc(I1) ; colormap gray ; axis image ;
hold on ;
h=plotsiftframe( frames11 ) ; set(h,'LineWidth',2,'Color','g') ;
h=plotsiftframe( frames11 ) ; set(h,'LineWidth',1,'Color','k') ;

tightsubplot(2,2,2) ; imagesc(I2) ; colormap gray ; axis image ;
hold on ;
h=plotsiftframe( frames22 ) ; set(h,'LineWidth',2,'Color','g') ;
h=plotsiftframe( frames22) ; set(h,'LineWidth',1,'Color','k') ;

tightsubplot(2,2,3) ; imagesc(I3) ; colormap gray ; axis image ;
hold on ;
h=plotsiftframe( frames33 ) ; set(h,'LineWidth',2,'Color','g') ;
h=plotsiftframe( frames33) ; set(h,'LineWidth',1,'Color','k') ;

fprintf('Computing matches.\n') ;
% By passing to integers we greatly enhance the matching speed (we use
% the scale factor 512 as Lowe's, but it could be greater without
% overflow)
descr1=uint8(512*descr1) ;
descr2=uint8(512*descr2) ;
descr3=uint8(512*descr3) ;
tic ; 
%关键点描述子匹配
matches=siftmatch( descr1, descr2, 25) ;
matches13=siftmatch( descr1, descr3, 3) ;
fprintf('Matched in %.3f s\n', toc) ;
%关键点描述子坐标
x1_or=[frames1(1,matches(1,:))];
y1_or=[frames1(2,matches(1,:))];
%获得匹配点的任意匹配的描述子
descr1_matches=descr1(:,matches(6:10));
descr2_matches=descr2(:,matches(6:10));
descr1_random=descr1(:,end-4:end);
descr2_random=descr2(:,end-4:end);
%已匹配的描述子与新图片的描述子匹配
matches1_3=siftmatch( descr1_matches, descr3, 1.5) ;
%新匹配的描述子
frame33=frames1(:,matches(1,6:10));
%图片1与图片3描述子点匹配的图显示
figure(32) ; clf ;
plotmatches(I1c,I3c,frames1(1:2,:),frames3(1:2,:),matches13,...
  'Stacking','v') ;
drawnow ;
%图片1与图片2描述子点匹配的图显示
figure(3) ; clf ;
plotmatches(I1c,I2c,frames1(1:2,:),frames2(1:2,:),matches,...
  'Stacking','v') ;
drawnow ;
%已匹配的描述子与新的图片描述子点匹配的图显示
figure(33) ; clf ;
plotmatches(I11c,I3c,frame33(1:2,:),frames3(1:2,:),matches1_3,...
  'Stacking','v') ;
drawnow ;
% Movie
%图1SIFT描述子图片显示
figure(4) ; set(gcf,'Position',[10 10 1024 512]) ;
figure(4) ; clf ;
tightsubplot(1,1);
imagesc(I1) ; colormap gray ; axis image ; hold on ;
%h=plotsiftframe( frames1 ) ; set(h,'LineWidth',1,'Color','g') ;
h=plotsiftframe( frames1(:,matches(1,:)) ) ; set(h,'LineWidth',1,'Color','g') ;
%h=plot(frames1(1,1:100),frames1(2,1:100),'r.') ;
h=plot(frames1(1,matches(1,:)),frames1(2,matches(1,:)),'r.') ;
MOV(1)=getframe ;
%图2SIFT描述子图片显示
figure(5) ; set(gcf,'Position',[10 10 1024 512]) ;
figure(5) ; clf ;
tightsubplot(1,1);
imagesc(I2) ; colormap gray ; axis image ; hold on ;
%h=plotsiftframe( frames2 ) ; set(h,'LineWidth',1,'Color','g') ;
h=plotsiftframe( frames2(:,matches(2,:)) ) ; set(h,'LineWidth',1,'Color','g') ;
%h=plot(frames2(1,1:100),frames2(2,1:100),'r.') ;
h=plot(frames2(1,matches(2,:)),frames2(2,matches(2,:)),'r.') ;
MOV(2)=getframe ;
%只显示图1指定的SIFT描述子
figure(6) ; set(gcf,'Position',[10 10 1024 512]) ;
figure(6) ; clf ;
tightsubplot(1,1);
imagesc(I1) ; colormap gray ; axis image ; hold on ;
h=plotsiftframe( frames1(:,matches(1,6:10)) ) ; set(h,'LineWidth',1,'Color','g') ;
MOV(3)=getframe ;
%只显示图2指定的SIFT描述子
figure(7) ; set(gcf,'Position',[10 10 1024 512]) ;
figure(7) ; clf ;
tightsubplot(1,1);
imagesc(I2) ; colormap gray ; axis image ; hold on ;
h=plotsiftframe( frames2(:,matches(2,6:10)) ) ; set(h,'LineWidth',1,'Color','g') ;
MOV(4)=getframe ;
%只显示图3指定的SIFT描述子
figure(8) ; set(gcf,'Position',[10 10 1024 512]) ;
figure(8) ; clf ;
tightsubplot(1,1);
imagesc(I3) ; colormap gray ; axis image ; hold on ;
h=plotsiftframe( frames3(:,matches13(2,6:10)) ) ; set(h,'LineWidth',1,'Color','g') ;
MOV(5)=getframe ;
%只显示图4指定的SIFT描述子
figure(9) ; set(gcf,'Position',[10 10 1024 512]) ;
figure(9) ; clf ;
tightsubplot(1,1);
imagesc(I1) ; colormap gray ; axis image ; hold on ;
h=plotsiftframe( frames1(:,matches13(1,6:10)) ) ; set(h,'LineWidth',1,'Color','g') ;
MOV(6)=getframe ;

