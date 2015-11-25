function [score,frames1,descr1,gss1,dogss1] = fusion_sift(image_sample,image_template,flag)

I1=imreadbw(image_sample) ; 
I2=imreadbw(image_template) ;
S=2 ;
I1=I1-min(I1(:)) ;
I1=I1/max(I1(:)) ;
I2=I2-min(I2(:)) ;
I2=I2/max(I2(:)) ;
fprintf('Computing frames and descriptors.\n') ;
%计算dog和descriptor
if flag==1 %一样的话
[frames1,descr1,gss1,dogss1] = sift( I1, 'Verbosity', 1, 'Threshold', ...
                                     0.06, 'NumLevels', S ) ;
elseif flag==0
    [frames1,descr1,gss1,dogss1]
end
                                 
[frames2,descr2,gss2,dogss2] = sift( I2, 'Verbosity', 1, 'Threshold', ...
                                     0.06, 'NumLevels', S ) ;
fprintf('Computing matches.\n') ;
descr1=uint8(512*descr1) ;
descr2=uint8(512*descr2) ;
tic ; 
match_threshold = 1.1;%这里是我改过的！！！
matches=siftmatch( descr1, descr2 ,match_threshold) ;%计算匹配程度
score = sift_score(descr1, descr2, matches, match_threshold);%此处是自行添加。
fprintf('Matched in %.3f s\n', toc) ;

end