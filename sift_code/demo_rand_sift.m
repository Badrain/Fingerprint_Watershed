I1=imreadbw('E:/compact/xml_toolbox/tests/VOC2011/train_images0331/2008_005705.jpg') ; I1c = I1 ;I11c=I1;
I1=imsmooth(I1,.1) ;
I1=I1-min(I1(:)) ;
I1=I1/max(I1(:)) ;
S=3 ;
num_descr=100;
I=imread('E:/compact/xml_toolbox/tests/VOC2011/train_images0331/2008_005705.jpg') ;

[frames1,descr1,gss1,dogss1] = sift( I1, 'Verbosity', 1, 'Threshold', ...
                                     0.025, 'NumLevels', S ) ;

[de_i,de_j]=size(descr1);
if(de_j>=num_descr)
   rand_t=randperm(de_j);
   %descr1=descr1(:,rand_t(1:num_descr));
end
if(de_j<num_descr)
   rand_t=randperm(de_j);
   %descr1=descr1(:,rand_t(1:de_j));
end
drawnow ;
figure(1);imshow(I);

%Í¼1SIFTÃèÊö×ÓÍ¼Æ¬ÏÔÊ¾
figure(2) ; set(gcf,'Position',[10 10 1024 512]) ;
figure(2) ; clf ;
tightsubplot(1,1);
imagesc(I) ; colormap gray ; axis image ; hold on ;
%h=plotsiftframe( frames1 ) ; set(h,'LineWidth',1,'Color','g') ;
h=plotsiftframe( frames1(:,:) ) ; set(h,'LineWidth',1,'Color','g') ;
h=plot(frames1(1,rand_t(1:num_descr)),frames1(2,rand_t(1:num_descr)),'r.') ;