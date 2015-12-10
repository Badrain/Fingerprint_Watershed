%temporary for make smaples
% load('Negative_LBP_feature_9.mat');
% load('Positive_LBP_feature_9.mat');
i=9;
image_name = strcat('1 (',num2str(i),').jpg');
mat_name = strcat('1 (',num2str(i),').mat');
%load(mat_name);%�õ�����new_coor_after�ļ�

[LBP_feature_1,LBP_feature_2] = LBP_MAX_feature(image_name,mat_name,5);%�õ����е���Ҫ������Ҫ���LBP������������һ���洢
Positive_LBP_feature = [Positive_LBP_feature;LBP_feature_1];%�õ�36�еģ�
Negative_LBP_feature = [Negative_LBP_feature;LBP_feature_2];

sample_num = randsample(4731,900);%the number we pull out
Negative_LBP_feature_after = [];
for i=1:length(sample_num)
    Negative_LBP_feature_after = [Negative_LBP_feature_after;Negative_LBP_feature(sample_num(i),:)];
end
LBP_feature_inst_after = [Positive_LBP_feature;Negative_LBP_feature_after];
LBP_feature_label_after = [ones(size(Positive_LBP_feature,1),1);-ones(size(Negative_LBP_feature_after,1),1)];
tic;
disp 'svmtraining:';
model = svmtrain(LBP_feature_label_after , LBP_feature_inst_after); 
save('svm_model_2x2','model');
toc;
tic;
disp 'predict_label_self:';
[predict_label_test_after] = svmpredict(LBP_feature_label_after,LBP_feature_inst_after,model);
toc;
