function score = fusion_match_score(descr1,descr2)


match_threshold = 1.1;%这里是我改过的！！！
matches=siftmatch(descr1, descr2 ,match_threshold) ;%计算匹配程度
score = sift_score(descr1, descr2, matches, match_threshold);%此处是自行添加。

end