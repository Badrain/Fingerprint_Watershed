clc;
clear;
image_name = '1 (2).jpg';
mat_name = '1 (2).mat';
Positive_LBP_feature = [];
Negative_LBP_feature = [];
[LBP_feature_1,LBP_feature_2] = LBP_MAX_feature(image_name,mat_name,5);%得到所有的需要的满足要求的LBP特征，并在下一步存储
Positive_LBP_feature = [Positive_LBP_feature;LBP_feature_1];%得到36列的？
Negative_LBP_feature = [Negative_LBP_feature;LBP_feature_2];
save('Positive_LBP_feature_2_4x4.mat','Positive_LBP_feature');
save('Negative_LBP_feature_2_4x4.mat','Negative_LBP_feature');
load('Positive_LBP_feature_2_2x2.mat');
load('Negative_LBP_feature_2_2x2.mat');
LBP_feature_inst_test = [Positive_LBP_feature;Negative_LBP_feature];
LBP_feature_label_test = [ones(size(Positive_LBP_feature,1),1);-ones(size(Negative_LBP_feature,1),1)];
load('svm_model_2x2.mat');
[predict_label_test] = svmpredict(LBP_feature_label_test,LBP_feature_inst_test,model);
show_svm_test(image_name,mat_name,predict_label_test,4);


mode = 0;
if mode == 4  % 82.9259% (4444/5359) 
    disp 'predict_label_test:';
    load('svm_model_4x4.mat');
    load('Positive_LBP_feature_8_4x4.mat');
    load('Negative_LBP_feature_8_4x4.mat');
    LBP_feature_inst_test = [Positive_LBP_feature;Negative_LBP_feature];
    LBP_feature_label_test = [ones(size(Positive_LBP_feature,1),1);-ones(size(Negative_LBP_feature,1),1)];
    [predict_label_test] = svmpredict(LBP_feature_label_test,LBP_feature_inst_test,model);
    show_svm_test(image_name,mat_name,predict_label_test,5);
elseif mode == 2 % 87.8709% (4709/5359)
    disp 'predict_label_test:';
    load('svm_model_2x2.mat');
    load('Positive_LBP_feature_8_2x2.mat');
    load('Negative_LBP_feature_8_2x2.mat');
    LBP_feature_inst_test = [Positive_LBP_feature;Negative_LBP_feature];
    LBP_feature_label_test = [ones(size(Positive_LBP_feature,1),1);-ones(size(Negative_LBP_feature,1),1)];
    [predict_label_test] = svmpredict(LBP_feature_label_test,LBP_feature_inst_test,model);
    show_svm_test(image_name,mat_name,predict_label_test,5);
elseif mode == 1
end