%temporary for make smaples
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
save('svm_model','model');
toc;
tic;
disp 'predict_label_self:';
[predict_label_test_after] = svmpredict(LBP_feature_label_after,LBP_feature_inst_after,model);
toc;
