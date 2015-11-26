clc;
clear;
Positive_LBP_feature = [];
Negative_LBP_feature = [];
%% 取极大值并与原坐标匹配
for i=1:20
    image_name = strcat('1 (',num2str(i),').jpg');
    mat_name = strcat('1 (',num2str(i),').mat');
    %load(mat_name);%得到的是new_coor_after文件
    
    [LBP_feature_1,LBP_feature_2] = LBP_MAX_feature(image_name,mat_name,16);%得到所有的需要的满足要求的LBP特征，并在下一步存储
    Positive_LBP_feature = [Positive_LBP_feature;LBP_feature_1];%得到36列的？
    Negative_LBP_feature = [Negative_LBP_feature;LBP_feature_2];
end
