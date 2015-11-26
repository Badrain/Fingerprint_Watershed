clc;
clear;
dir_sample = 'F:\DBI\Test\';
dir_template = 'F:\DBII\';
for threshold=0.05:0.01:0.07
    sample_database = {};
    template_database = {};
    %批量读取图片,并进行打分
    for i=1:168%应该是168
        for j=1:1
            for k=1:1
                image_sample = strcat(dir_sample,num2str(i),'_',num2str(j),'_',num2str(k),'.jpg');
                if exist(image_sample,'file')==0 %文件不存在的话进入下一层循环
                    continue;
                end
                sample_database = [sample_database,sift_calculate(image_sample,threshold)];
            end
        end
    end
    for l=1:168
        for m=1:1
            for n=1:1
                image_template = strcat(dir_template,num2str(l),'_',num2str(m),'_',num2str(n),'.jpg');
                if exist(image_template,'file')==0 %文件不存在的话进入下一层循环
                    continue;
                end
                template_database = [template_database,sift_calculate(image_template,threshold)];
            end
        end
    end
    save(strcat('sample_database_',num2str(threshold),'.mat'),'sample_database');
    save(strcat('template_database_',num2str(threshold),'.mat'),'template_database');
    %load('sample_database.mat');
    %load('template_database.mat');
    correct_count = 0;
    for i=1:148%应该是148
        score = 0;
        score_max = 0;
        num_max = 0;
        i
        for j=1:148
            score = fusion_match_score(sample_database{i},template_database{j});
            if score > score_max
                score_max = score;
                num_max = j;
            end
        end
        if i==num_max
            correct_count = correct_count + 1
        end
    end
    accuracy1 = correct_count / 10 * 100
    save(strcat('accuracy_',num2str(threshold),'.mat'),'accuracy1');
end


sample_database = {};
template_database = {};
for i=1:168
    for j=1:2
        for k=1:5
            image_sample = strcat(dir_sample,num2str(i),'_',num2str(j),'_',num2str(k),'.jpg');
            if exist(image_sample,'file')==0 %文件不存在的话进入下一层循环
                continue;
            end
            sample_database = [sample_database,sift_calculate(image_sample)];
        end
    end
end
for l=1:168
    for m=1:2
        for n=1:5
            image_template = strcat(dir_template,num2str(l),'_',num2str(m),'_',num2str(n),'.jpg');
            if exist(image_template,'file')==0 %文件不存在的话进入下一层循环
                continue;
            end
            template_database = [template_database,sift_calculate(image_template)];
        end
    end
end
save(sample_database,'sample_database_final');
save(template_database,'template_database_final');
