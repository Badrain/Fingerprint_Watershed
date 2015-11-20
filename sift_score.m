function score = sift_score(descr1, descr2, matches, match_threshold)%该函数用于得到两幅图片匹配的得分
    dist_sum = 0;%存储一对图片里的所有对应像素点的距离和
    matches_num = size(matches,2);
    for i=1:matches_num
        one_sum = 0;
        for j=1:128
            x = descr1(j,matches(1,i));
            y = descr2(j,matches(2,i));
            one_sum = one_sum + x*x + y*y;%存储一对对应坐标的平方和
        end
        one_sum = sqrt(double(one_sum));%得到一对像素点的距离
        dist_sum = dist_sum + one_sum;
    end
    dist_average = dist_sum / matches_num;
    score = dist_average / match_threshold * 100;
end