clc;
clear;

Positive_LBP_feature = [];
Negative_LBP_feature = [];
%% ȡ����ֵ����ԭ����ƥ��
tic;
%for j=1:2
    i=9;
    image_name = strcat('1 (',num2str(i),').jpg');
    mat_name = strcat('1 (',num2str(i),').mat');
    %load(mat_name);%�õ�����new_coor_after�ļ�
    
    [LBP_feature_1,LBP_feature_2] = LBP_MAX_feature(image_name,mat_name,5);%�õ����е���Ҫ������Ҫ���LBP������������һ���洢
    Positive_LBP_feature = [Positive_LBP_feature;LBP_feature_1];%�õ�36�еģ�
    Negative_LBP_feature = [Negative_LBP_feature;LBP_feature_2];
%end
LBP_feature_inst = [Positive_LBP_feature;Negative_LBP_feature];
LBP_feature_label = [ones(size(Positive_LBP_feature,1),1);-ones(size(Negative_LBP_feature,1),1)];
disp 'get feature';
toc;
tic;
disp 'svmtraining:';
model = svmtrain(LBP_feature_label , LBP_feature_inst); 
save('svm_model','model');
toc;
tic;
disp 'predict_label_self:';
[predict_label_test] = svmpredict(LBP_feature_label,LBP_feature_inst,model);
toc;
image_name = '1 (8).jpg';
mat_name = '1 (8).mat';
Positive_LBP_feature = [];
 Negative_LBP_feature = [];
    [LBP_feature_1,LBP_feature_2] = LBP_MAX_feature(image_name,mat_name,16);%�õ����е���Ҫ������Ҫ���LBP������������һ���洢
    Positive_LBP_feature = [Positive_LBP_feature;LBP_feature_1];%�õ�36�еģ�
    Negative_LBP_feature = [Negative_LBP_feature;LBP_feature_2];
LBP_feature_inst_test = [Positive_LBP_feature;Negative_LBP_feature];
LBP_feature_label_test = [ones(size(Positive_LBP_feature,1),1);-ones(size(Negative_LBP_feature,1),1)];

disp 'predict_label_test:';
[predict_label_test] = svmpredict(LBP_feature_label_test,LBP_feature_inst_test,model);
