function score = sift_score(descr1, descr2, matches, match_threshold)%�ú������ڵõ�����ͼƬƥ��ĵ÷�
    dist_sum = 0;%�洢һ��ͼƬ������ж�Ӧ���ص�ľ����
    matches_num = size(matches,2);
    for i=1:matches_num
        one_sum = 0;
        for j=1:128
            x = descr1(j,matches(1,i));
            y = descr2(j,matches(2,i));
            one_sum = one_sum + x*x + y*y;%�洢һ�Զ�Ӧ�����ƽ����
        end
        one_sum = sqrt(double(one_sum));%�õ�һ�����ص�ľ���
        dist_sum = dist_sum + one_sum;
    end
    dist_average = dist_sum / matches_num;
    score = dist_average / match_threshold * 100;
end