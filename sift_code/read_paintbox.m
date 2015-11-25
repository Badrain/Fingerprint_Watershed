clear all;
close all;
clc;
addpath([cd '/VOC2011/Annotations']);
addpath([cd '/VOC2011/JPEGImages']);
%str = fileread( 'feature.xml' );
I1=imreadbw('E:/compact/xml_toolbox/tests/VOC2011/train_images0331/2009_001019.jpg') ; I1c = I1 ;I11c=I1;
I1=imsmooth(I1,.1) ;
I1=I1-min(I1(:)) ;
I1=I1/max(I1(:)) ;
S=3 ;
I=imread('E:/compact/xml_toolbox/tests/VOC2011/train_images0331/2009_001019.jpg') ;
str = fileread( 'E:/compact/xml_toolbox/tests/VOC2011/train_annotations0331/2009_001019.xml' );
v = xml_parse( str );
[v_i,v_j]=size(v);
result=I;
for i=1:v_j
    i_width_xmin(i)=str2num(v(1,i).object.bndbox.xmin);
    i_width_xmax(i)=str2num(v(1,i).object.bndbox.xmax);
    i_height_ymin(i)=str2num(v(1,i).object.bndbox.ymin);
    i_heitht_ymax(i)=str2num(v(1,i).object.bndbox.ymax);
    x(i)=i_width_xmax(i)-i_width_xmin(i);
    y(i)=i_heitht_ymax(i)-i_height_ymin(i);
    
    pointAll=[i_height_ymin(i),i_width_xmin(i)];
    windSize=[x(i),y(i)];
    [state,result]=draw_rect(result,pointAll,windSize);
    clear state;
    clear pointAll;
    clear windSize;
end
%获得关键点描述子
fprintf('Computing frames and descriptors.\n') ;
[frames1,descr1,gss1,dogss1] = sift( I1, 'Verbosity', 1, 'Threshold', ...
                                     0.005, 'NumLevels', S ) ;
%图1SIFT描述子图片显示
figure(2) ; set(gcf,'Position',[10 10 1024 512]) ;
figure(2) ; clf ;
tightsubplot(1,1);
imagesc(result) ; colormap gray ; axis image ; hold on ;
%h=plotsiftframe( frames1 ) ; set(h,'LineWidth',1,'Color','g') ;
h=plotsiftframe( frames1(:,:) ) ; set(h,'LineWidth',1,'Color','g') ;

%for i=1:v_j
%    pointAll(i)=[i_width_xmin(i),i_height_ymin(i)];
%    windSize(i)=[x(i),y(i)];
%    [state(i),I]=draw_rect(I,pointAll,windSize);
    %clear state;
    %clear pointAll;
    %clear windSize;
%end
%return;  