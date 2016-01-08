clc;
clear;

Positive_LBP_feature_all = [];
Negative_LBP_feature_all = [];
%% train
tic;
sample_list = 1:20;
success = 0;%记录成功提取特征的图片数
for l = 1:length(sample_list)
    tic;
    i = sample_list(l)
    image_name = strcat('F:\TTDownload\FP data form HongKong\GroundTruth\PoreGroundTruth\PoreGroundTruthSampleimage\', num2str(i),'.bmp');
    mat_name = strcat(num2str(i),'.mat');
    %load(mat_name);%得到的是new_coor_after文件
    Positive_feature_name = strcat('Positive_LBP_feature_',num2str(i),'_4x4.mat');
    Negative_feature_name = strcat('Negative_LBP_feature_',num2str(i),'_4x4.mat');
    Positive_LBP_feature = [];%每一幅图片的正样本
    Negative_LBP_feature = [];%每一幅图片的负样本
    if exist(Positive_feature_name,'file')==0 || exist(Negative_feature_name,'file')==0
        [LBP_feature_1,LBP_feature_2] = LBP_MAX_feature(image_name,mat_name,4);%得到所有的需要的满足要求的LBP特征，并在下一步存储
        success = success + 1
        toc;
        Positive_LBP_feature = [Positive_LBP_feature;LBP_feature_1];
        Negative_LBP_feature = [Negative_LBP_feature;LBP_feature_2];
    else
        load(Positive_feature_name);
        load(Negative_feature_name);
    end
    feature_length = size(Positive_LBP_feature,1);%！！！！！！可以考虑x2进行试验！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！x2试验失败，效果不佳
    Negative_feature_num = randsample(size(Negative_LBP_feature,1),size(Positive_LBP_feature,1));
    Negative_LBP_feature_after = [];%经过缩减的负样本
    for m=1:feature_length
        Negative_LBP_feature_after =  [Negative_LBP_feature_after;Negative_LBP_feature(Negative_feature_num(m),:)];
    end
    Positive_LBP_feature_all = [Positive_LBP_feature_all;Positive_LBP_feature];%总的正样本
    Negative_LBP_feature_all = [Negative_LBP_feature_all;Negative_LBP_feature_after];%总的负样本
end
save('Positive_LBP_feature_all_30pic_4x4','Positive_LBP_feature_all');
save('Negative_LBP_feature_all_30pic_4x4','Negative_LBP_feature_all');
LBP_feature_inst = [Positive_LBP_feature_all;Negative_LBP_feature_all];%总的正负样本
LBP_feature_label = [ones(size(Positive_LBP_feature_all,1),1);-ones(size(Negative_LBP_feature_all,1),1)];%总样本的标签
disp 'get feature';
toc;
tic;
disp 'svmtraining:';
model = svmtrain(LBP_feature_label , LBP_feature_inst); 
save('Hongkong_svm_LBP_model_all_4x4_Ver2','model');
toc;
tic;
disp 'predict_label_self:';
[predict_label_test] = svmpredict(LBP_feature_label,LBP_feature_inst,model);
toc;
%% test
clear all;
disp('calculate the test feature');
tic;
load('Hongkong_svm_LBP_model_all_4x4_Ver1');
Positive_LBP_feature = [];
Negative_LBP_feature = [];
all_true_pores_num = 0;
for i=21:30
    i
    image_name = strcat('F:\TTDownload\FP data form HongKong\GroundTruth\PoreGroundTruth\PoreGroundTruthSampleimage\', num2str(i),'.bmp');
    mat_name = strcat(num2str(i),'.mat');
    load(mat_name);
    all_true_pores_num = all_true_pores_num + size(new_coor_after,1);
    [LBP_feature_1,LBP_feature_2] = LBP_MAX_feature_4_test(image_name,mat_name,4);%得到所有的需要的满足要求的LBP特征，并在下一步存储
    Positive_LBP_feature = [Positive_LBP_feature;LBP_feature_1];
    Negative_LBP_feature = [Negative_LBP_feature;LBP_feature_2];
end
LBP_feature_inst_test = Positive_LBP_feature;
LBP_feature_label_test = ones(size(Positive_LBP_feature,1),1);
toc;
tic;
disp 'predict_label_test:';
[predict_label_test,RF,value] = svmpredict(LBP_feature_label_test,LBP_feature_inst_test,model);
%show_svm_LBP_test(image_name,mat_name,predict_label_test,4);
RT = size(find(predict_label_test==1),1)/all_true_pores_num*100
RF = 100-RF(1) 
toc;