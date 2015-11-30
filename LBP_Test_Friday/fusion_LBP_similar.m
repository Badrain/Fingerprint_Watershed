function similar = fusion_LBP_similar(sample_LBP,template_LBP)
%该函数负责给出两幅图像的相似度similar，输入是两幅图像的LBP值们



distance_min = 100;
distance_sum = 0;
distance_avr = 0;
pore_num_sample = size(sample_LBP,1);
for i=1:pore_num_sample
    LBP_1 = sample_LBP(i,:);
    for j=1:size(template_LBP,1)
        LBP_2 = template_LBP(j,:);
        distance = sum(((LBP_1 - LBP_2).^2) ./ (LBP_1 + LBP_2 + 0.001));
       if distance < distance_min
           distance_min = distance;
       end
    end
    distance_sum = distance_sum + distance_min;
end
distance_avr = distance_sum / pore_num_sample;
similar = distance_avr;

end