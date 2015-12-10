%temporary for make smaples
% load('Negative_LBP_feature_9.mat');
% load('Positive_LBP_feature_9.mat');
i=9;
image_name = strcat('1 (',num2str(i),').jpg');
mat_name = strcat('1 (',num2str(i),').mat');
%load(mat_name);%得到的是new_coor_after文件

[LBP_feature_1,LBP_feature_2] = LBP_MAX_feature(image_name,mat_name,5);%得到所有的需要的满足要求的LBP特征，并在下一步存储
Positive_LBP_feature = [Positive_LBP_feature;LBP_feature_1];%得到36列的？
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
