function score = fusion_match_score(descr1,descr2)


match_threshold = 1.1;%�������ҸĹ��ģ�����
matches=siftmatch(descr1, descr2 ,match_threshold) ;%����ƥ��̶�
score = sift_score(descr1, descr2, matches, match_threshold);%�˴���������ӡ�

end