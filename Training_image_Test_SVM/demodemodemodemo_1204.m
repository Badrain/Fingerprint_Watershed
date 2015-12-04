image_name = '1 (8).jpg';
mat_name = '1 (8).mat';
Positive_LBP_feature = [];
 Negative_LBP_feature = [];
    [LBP_feature_1,LBP_feature_2] = LBP_MAX_feature(image_name,mat_name,16);%得到所有的需要的满足要求的LBP特征，并在下一步存储
    Positive_LBP_feature = [Positive_LBP_feature;LBP_feature_1];%得到36列的？
    Negative_LBP_feature = [Negative_LBP_feature;LBP_feature_2];
LBP_feature_inst_test = [Positive_LBP_feature;Negative_LBP_feature];
LBP_feature_label_test = [ones(size(Positive_LBP_feature,1),1);-ones(size(Negative_LBP_feature,1),1)];

disp 'predict_label_test:';
[predict_label_test] = svmpredict(LBP_feature_label_test,LBP_feature_inst_test,model);
