clc;
clear;
Positive_LBP_feature = [];
Negative_LBP_feature = [];
%% ȡ����ֵ����ԭ����ƥ��
for i=1:20
    image_name = strcat('1 (',num2str(i),').jpg');
    mat_name = strcat('1 (',num2str(i),').mat');
    %load(mat_name);%�õ�����new_coor_after�ļ�
    
    [LBP_feature_1,LBP_feature_2] = LBP_MAX_feature(image_name,mat_name,16);%�õ����е���Ҫ������Ҫ���LBP������������һ���洢
    Positive_LBP_feature = [Positive_LBP_feature;LBP_feature_1];%�õ�36�еģ�
    Negative_LBP_feature = [Negative_LBP_feature;LBP_feature_2];
end
