clc;
clear;
Test_flag = 0;
im = imread('1.jpg');
im_large = imread('1_large.jpg');
image_input = zeros(32,32);
if Test_flag==1
    m=1;n=1;
    for i=79:110
        n=1;
        for j=128:159

            image_input(m,n)=im(i,j);
            n=n+1;
        end
        m=m+1;
    end
    hist_output=LBP_C(image_input);
    combine_feature_vector_1=cell2mat(hist_output);%combine_h_feature(hist_output);
    m=1;

    for i=173:204
        n=1;
        for j=365:396

            image_input(m,n)=im_large(i,j);
            n=n+1;
        end
        m=m+1;
    end
    hist_output=LBP_C(image_input);
    combine_feature_vector_1_large=cell2mat(hist_output);%combine_h_feature(hist_output);

    m=1;n=1;
    for i=88:119
        n=1;
        for j=141:172

            image_input(m,n)=im(i,j);
            n=n+1;
        end
        m=m+1;
    end
    hist_output=LBP_C(image_input);
    combine_feature_vector_2=cell2mat(hist_output);%combine_h_feature(hist_output);

    %卡方距离
    distance = 0;
    distance12 = sum(((combine_feature_vector_1 - combine_feature_vector_2).^2) ./ (combine_feature_vector_1 + combine_feature_vector_2 + 0.001))
    distance11 = sum(((combine_feature_vector_1 - combine_feature_vector_1_large).^2) ./ (combine_feature_vector_1 + combine_feature_vector_1_large + 0.001));
end

clc;
clear;
dir_sample = 'F:\TTDownload\DBI\Test\';
dir_template = 'F:\TTDownload\DBII\';
sample_LBP_database = {};
template_LBP_database = {};
for i=1:3%应该是168
    for j=1:1
        for k=1:1
            image_sample = strcat(dir_sample,num2str(i),'_',num2str(j),'_',num2str(k),'.jpg');
            mat_sample = strcat(dir_sample,num2str(i),'_',num2str(j),'_',num2str(k),'.mat');
            if exist(image_sample,'file')==0 %文件不存在的话进入下一层循环
                continue;
            end
            bgm = watershed_stepone(image_sample);
            [IM,new_coor,coor_image] = watershed_steptwo(bgm,'binary');
            new_coor_after = [new_coor,ones(size(new_coor,1),1)];
            save(mat_sample,'new_coor_after');
            sample_LBP_database = [sample_LBP_database,LBP_feature(image_sample,mat_sample,16)];
        end
    end
end
for i=1:3%应该是168
    for j=1:1
        for k=1:1
            image_template = strcat(dir_template,num2str(i),'_',num2str(j),'_',num2str(k),'.jpg');
            mat_template = strcat(dir_template,num2str(i),'_',num2str(j),'_',num2str(k),'.mat');
            if exist(image_template,'file')==0 %文件不存在的话进入下一层循环
                continue;
            end
            bgm = watershed_stepone(image_template);
            [IM,new_coor,coor_image] = watershed_steptwo(bgm,'binary');
            new_coor_after = [new_coor,ones(size(new_coor,1),1)];
            save(mat_template,'new_coor_after');
            template_LBP_database = [template_LBP_database,LBP_feature(image_template,mat_template,16)];
        end
    end
end
save('sample_database.mat','sample_LBP_database');
save('template_database.mat','template_LBP_database');
correct_count = 0;
for i=1:3%应该是148
    similar = 0;
    similar_min = 1000;
    num_max = 0;
    i
    for j=1:3
        similar = fusion_LBP_similar(sample_LBP_database{i},template_LBP_database{j});
        if similar < similar_min
            similar_min = similar;
            num_max = j;
        end
    end
    if i==num_max
        correct_count = correct_count + 1
    end
end
accuracy = correct_count / 148 * 100;
