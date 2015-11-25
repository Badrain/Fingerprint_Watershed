clc;
clear;
dir_sample = 'F:\TTDownload\DBI\Test\';
dir_template = 'F:\TTDownload\DBII\';
sample_database = {};
template_database = {};
correct_count = 0;
%批量读取图片,并进行打分
for i=1:168
    for j=1:1
        for k=1:1
            image_sample = strcat(dir_sample,num2str(i),'_',num2str(j),'_',num2str(k),'.jpg');
            if exist(image_sample,'file')==0 %文件不存在的话进入下一层循环
                continue;
            end
            sample_database = [sample_database,sift_calculate(image_sample)];
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
            template_database = [template_database,sift_calculate(image_template)];
        end
    end
end
save(sample_database,'sample_database');
save(template_database,'template_database');
for i=1:168
    score = 0;
    score_max = 0;
    num_max = 0;
    for j=1:168
        score = fusion_match_score(sample_database{i},template_database{j});
        if score > score_max
            score_max = score;
            num_max = j;
        end
    end
    if i==num_max
        correct_count = correct_count + 1;
    end
end
accuracy1 = correct_count / 168 /168;


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
