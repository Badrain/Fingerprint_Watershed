clc;
clear;
Test_flag = 1;
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
    combine_feature_vector_1=cell2mat(hist_output);
    combine_feature_vector_1=combine_h_feature(hist_output);
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
    combine_feature_vector_1_large=cell2mat(hist_output);
    combine_feature_vector_1_large=(combine_h_feature(hist_output));

    m=1;n=1;
    for i=172:203
        n=1;
        for j=348:379

            image_input(m,n)=im_large(i,j);
            n=n+1;
        end
        m=m+1;
    end
    hist_output=LBP_C(image_input);
    combine_feature_vector_3=cell2mat(hist_output);
    combine_feature_vector_3=(combine_h_feature(hist_output));

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
    combine_feature_vector_2=cell2mat(hist_output);
    combine_feature_vector_2=(combine_h_feature(hist_output));
    
    
    %卡方距离
    distance = 0;
    distance13 = sum(((combine_feature_vector_1 - combine_feature_vector_3).^2) ./ (combine_feature_vector_1 + combine_feature_vector_3 + 0.001))
    distance12 = sum(((combine_feature_vector_1 - combine_feature_vector_2).^2) ./ (combine_feature_vector_1 + combine_feature_vector_2 + 0.001))
    distance11 = sum(((combine_feature_vector_1 - combine_feature_vector_1_large).^2) ./ (combine_feature_vector_1 + combine_feature_vector_1_large + 0.001))
else

  %% 这里开始是new_LBP的测试程序
  clc;
  clear;
  error_image = '';%mark the error image's name
  error_image_num = [];%mark the error image's number
  dir_sample = 'F:\BaiduYunDownload\FP data form HongKong\DBI\Test\';
  dir_template = 'F:\BaiduYunDownload\FP data form HongKong\DBII\';
  sample_LBP_database = {};
  template_LBP_database = {};
  % for i=1:168%应该是168
  %     for j=1:1
  %         for k=1:1
  %           i
  %           j
  %           k
  %             image_sample = strcat(dir_sample,num2str(i),'_',num2str(j),'_',num2str(k),'.jpg');
  %             mat_sample = strcat(dir_sample,num2str(i),'_',num2str(j),'_',num2str(k),'.mat');
  %             if exist(image_sample,'file')==0 %文件不存在的话进入下一层循环
  %                 continue;
  %             end
  %             bgm = watershed_stepone(image_sample);
  %             [IM,new_coor,coor_image,continue_cluster_flag_sample] = watershed_steptwo(bgm,'binary');
  %             if continue_cluster_flag_sample~=0%this part is new for error
  %               new_coor_after = [new_coor,ones(size(new_coor,1),1)];
  %               save(mat_sample,'new_coor_after');
  %               sample_LBP_database = [sample_LBP_database,LBP_feature(image_sample,mat_sample,16)];
  %             else
  %               error_image = strcat(error_image,image_sample);
  %               error_image_num = [error_image_num;i];
  %             end
  %         end
  %     end
  % end

  for i=1:10%应该是168
      for j=1:1
          for k=1:1
              image_template = strcat(dir_template,num2str(i),'_',num2str(j),'_',num2str(k),'.jpg');
              mat_template = strcat(dir_template,num2str(i),'_',num2str(j),'_',num2str(k),'.mat');
               image_sample = strcat(dir_sample,num2str(i),'_',num2str(j),'_',num2str(k),'.jpg');
               mat_sample = strcat(dir_sample,num2str(i),'_',num2str(j),'_',num2str(k),'.mat');
              if exist(image_template,'file')==0 || exist(image_sample,'file')==0%文件不存在的话进入下一层循环
                  continue;
              end
              bgm_template = watershed_stepone(image_template);
              [IM_template,new_coor_template,coor_image_template,continue_cluster_flag_template] = watershed_steptwo(bgm_template,'binary');
              bgm_sample  =  watershed_stepone(image_sample);
              [IM_sample,  new_coor_sample,  coor_image_sample,  continue_cluster_flag_sample  ] = watershed_steptwo(bgm_sample,  'binary');
              figure;imshow(gray2rgb(imread(image_sample),  coor_image_sample,  bgm_sample));
              figure;imshow(gray2rgb(imread(image_template),coor_image_template,bgm_template));
              if continue_cluster_flag_template~=0 && continue_cluster_flag_sample~=0%this part is new for error
                  new_coor_after_template = [new_coor_template,ones(size(new_coor_template,1),1)];
                  %save(mat_template,'new_coor_after');
                  template_LBP_database = [template_LBP_database,LBP_feature(image_template,new_coor_after_template,16)];

                  new_coor_after_sample  =  [new_coor_sample , ones(size(new_coor_sample,1) , 1)];
                  %save(mat_sample,'new_coor_after');
                  sample_LBP_database  =  [sample_LBP_database , LBP_feature(image_sample , new_coor_after_sample , 16)];

              else
                  error_image = strcat(error_image,image_sample);
                  error_image_num = [error_image_num;i];
              end
          end
      end
  end
  %以上是把每幅图像的LBP计算好，然后下面存储好
  save('sample_LBP_database.mat','sample_LBP_database');
  save('template_LBP_database.mat','template_LBP_database');

  %以下是开始比较计算相似度similar了！
  load('sample_LBP_database.mat');
  load('template_LBP_database.mat');
  correct_count = 0;
  loop_num = length(sample_LBP_database);
  for i=1:loop_num%应该是148
      similar = 0;
      similar_min = 1000;
      num_min = 0;
      i
      for j=1:loop_num
          similar = fusion_LBP_similar(sample_LBP_database{i},template_LBP_database{j});
          if similar < similar_min
              similar_min = similar;
              num_min = j;
          end
      end
      if i==num_min
          correct_count = correct_count + 1
      end
  end
  accuracy = correct_count / 148 * 100
  save('accuracy_new_LBP.mat','accuracy');
  
end

