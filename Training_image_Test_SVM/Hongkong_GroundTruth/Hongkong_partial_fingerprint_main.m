%ǰ����ͼ�������±��һ�£���20��ͼע��һ�£���������̫��
clc;
clear;
all_coor_store = {};
for i=21:21
    image_name = strcat('F:\TTDownload\FP data form HongKong\GroundTruth\PoreGroundTruth\PoreGroundTruthSampleimage\', num2str(i),'.bmp');
    mat_name = strcat(num2str(i),'.mat');
    %image_name = strcat('F:\TTDownload\FP data form HongKong\GroundTruth\DotsandIncipientsGroundTruth\SetIGroundTruthSampleimage\',num2str(i),'.bmp');
    %mat_name = strcat('F:\TTDownload\FP data form HongKong\GroundTruth\DotsandIncipientsGroundTruth\SetIGroundTruthSampleimage\',num2str(i),'.mat');
    im = imread(image_name);
    imx = size(im,1);
    imy = size(im,2);
    coor_image = zeros(imx,imy);
    un_coor = zeros(imx,imy);
    if exist(mat_name,'file')~=0          %!����Ѿ��Ĺ��Ļ��øĹ�������
        load(mat_name);%����new_coor_after
        new_coor = new_coor_after;
        %��Ҫ��ʼ��new_coor_after =
        for j=1:size(new_coor,1)
            if new_coor(j,3)==1
                coor_image(new_coor(j,1),new_coor(j,2))=1;%��һ����Ҫ��coor_image���㶨
            end
        end
        coor_image = im2bw(coor_image,graythresh(coor_image));
    else bgm = watershed_stepone(image_name);%!���û�иĹ������¿�ʼ��ȡ
         [IM,new_coor,coor_image] = watershed_steptwo(bgm, 'binary');
         new_coor_after = [new_coor,ones(size(new_coor,1),1)];
         save(mat_name,'new_coor_after');
    end
    un_coor = show_un_coor(image_name,mat_name);
    im = gray2rgb(imread(image_name),coor_image,un_coor);
    figure;imshow(im);
    [coor_insert,coor_delete] = mark_coor(image_name,coor_image);
    [new_coor_after,coor_image_after] = store_coor(new_coor,coor_image,coor_insert,coor_delete);
    %un_coor = show_un_coor(image_name,mat_name);%%%%%%%%%%%%%%%%Ŀǰ�����⣡ֻ�ܲ���һ�β��ܻڸ�
    %im = gray2rgb(imread(image_name),coor_image_after,un_coor);%%%%%%%%%%%%%%%%Ŀǰ�����⣡ֻ�ܲ���һ�β��ܻڸ�
    coor_name = strcat('1 (',num2str(i),').mat');
    %figure;imshow(im); 
    hold on;
    [~,~,button]=ginput(1);
    if button==3%��ʱ��������в�����ĵط������Ҽ�����һ���޸Ļ��ᡣ
        [coor_insert,coor_delete] = mark_coor(image_name,coor_image_after);
        [new_coor_after_after,coor_image_after_after] = store_coor(new_coor_after,coor_image_after,coor_insert,coor_delete);    %�����Ӧ����ǰ��һ����������
        coor_image_after = coor_image_after_after;
        new_coor_after = new_coor_after_after;
        im = gray2rgb(imread(image_name),coor_image_after);
        figure;imshow(im); 
        hold on;
        [~,~,button2]=ginput(1);
        if button2==2
            save(coor_name,'new_coor_after');
        else break;
        end
    elseif button==2
        save(coor_name,'new_coor_after');
    end
        
end