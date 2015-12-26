clc;
clear;

Positive_LBP_feature_all = [];
Negative_LBP_feature_all = [];
%% train
tic;
sample_list = [2,3,7,8,9,11:19];%[2 8 9 12 13 14];
for l = 1:length(sample_list)
    i = sample_list(l);
    image_name = strcat('1 (',num2str(i),').jpg');
    mat_name = strcat('1 (',num2str(i),').mat');
    %load(mat_name);%得到的是new_coor_after文件
    Positive_feature_name = strcat('Positive_LBP_feature_',num2str(i),'_4x4.mat');
    Negative_feature_name = strcat('Negative_LBP_feature_',num2str(i),'_4x4.mat');
    Positive_LBP_feature = [];%每一幅图片的正样本
    Negative_LBP_feature = [];%每一幅图片的负样本
    if exist(Positive_feature_name,'file')==0 || exist(Negative_feature_name,'file')==0
        [LBP_feature_1,LBP_feature_2] = LBP_MAX_feature(image_name,mat_name,4);%得到所有的需要的满足要求的LBP特征，并在下一步存储
        Positive_LBP_feature = [Positive_LBP_feature;LBP_feature_1];
        Negative_LBP_feature = [Negative_LBP_feature;LBP_feature_2];
    else
        load(Positive_feature_name);
        load(Negative_feature_name);
    end
    feature_length = size(Positive_LBP_feature,1);%！！！！！！可以考虑x2进行试验！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
    Negative_feature_num = randsample(size(Negative_LBP_feature,1),size(Positive_LBP_feature,1));
    Negative_LBP_feature_after = [];%经过缩减的负样本
    for m=1:feature_length
        Negative_LBP_feature_after =  [Negative_LBP_feature_after;Negative_LBP_feature(Negative_feature_num(m),:)];
    end
    Positive_LBP_feature_all = [Positive_LBP_feature_all;Positive_LBP_feature];%总的正样本
    Negative_LBP_feature_all = [Negative_LBP_feature_all;Negative_LBP_feature_after];%总的负样本
end
LBP_feature_inst = [Positive_LBP_feature_all;Negative_LBP_feature_all];%总的正负样本
LBP_feature_label = [ones(size(Positive_LBP_feature_all,1),1);-ones(size(Negative_LBP_feature_all,1),1)];%总样本的标签
disp 'get feature';
toc;
tic;
disp 'svmtraining:';
model = svmtrain(LBP_feature_label , LBP_feature_inst); 
save('svm_LBP_model_all_4x4','model');
toc;
tic;
disp 'predict_label_self:';
[predict_label_test] = svmpredict(LBP_feature_label,LBP_feature_inst,model);
toc;
%% test
clc;
clear;
disp('calculate the test feature');
tic;
image_name = '1 (20).jpg';
mat_name = '1 (20).mat';
load('svm_LBP_model_all_4x4');
Positive_LBP_feature = [];
 Negative_LBP_feature = [];
[LBP_feature_1,LBP_feature_2] = LBP_MAX_feature_4_test(image_name,mat_name,4);%得到所有的需要的满足要求的LBP特征，并在下一步存储
Positive_LBP_feature = [Positive_LBP_feature;LBP_feature_1];%得到36列的？
Negative_LBP_feature = [Negative_LBP_feature;LBP_feature_2];
LBP_feature_inst_test = [Positive_LBP_feature;Negative_LBP_feature];
LBP_feature_label_test = [ones(size(Positive_LBP_feature,1),1);-ones(size(Negative_LBP_feature,1),1)];
toc;
tic;
disp 'predict_label_test:';
[predict_label_test] = svmpredict(LBP_feature_label_test,LBP_feature_inst_test,model);
show_svm_test(image_name,mat_name,predict_label_test,4);
toc;