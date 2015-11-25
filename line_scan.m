function im_coordinate = line_scan(im,length_min,length_max)
%length_min��length_max�����趨line���ȵ���Сֵ�����ֵ
%% ɨ��ͼƬ���洢����
%clc;
%clear;
%im = [0 0 1 1 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0;0 0 1 1 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0;0 0 1 1 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0];
[imx, imy] = size(im);
im_coordinate = zeros(imx,imy);
flag = 0;%flagΪ0����¼���ȣ�flagΪ1��¼����
count_length = 0;%���ڼ�¼����
temp_left = zeros(1,2);%���ڼ�¼ÿһ�γ��ȵ���˵�
temp_right = zeros(1,2);
data = {};%���ڴ洢���з���Ҫ��������
temp_data = {};%������ʱ�洢һ������
data_count = 0;
for i=1:imx
    for j=2:imy
        if im(i,j)==0 && im(i,j-1)==1%һ�εĿ�ʼ
            flag = 1;
            count_length = 0;
            temp_left = [i,j-1];
        elseif im(i,j)==1 && im(i,j-1)==0 && flag==1%һ�εĽ���
            flag = 0;
            temp_right = [i,j];
            if count_length<length_max && count_length>length_min%%%%%%%%%%%%%%%%%%%%%%%%%%%%%threshold
                temp_data = {temp_left,temp_right};
                data_count = data_count+1;
                data{i}{data_count}=temp_data;
            end
        elseif j==imy && flag==1 && im(i,j)==0%ֻ���������û���ұ�����
            flag = 0;
        end
        if flag==1
            count_length = count_length + 1;
        end
    end
    data_count = 0;
end


%% �������ݣ���ȡ����
sign = zeros(imx,imy);%���ڱ��data�и�λ���Ƿ��Ѿ�ͳ�ƹ�
temp_store={};%���ڼ��д洢ÿһ��pore���ȫ�����ǵ㼯
temp_coor={};
coor_x=0;
coor_y=0;
all_coor={};%���ڴ洢����pore����������
%class = {};
%class_number = 1;
for i=1:length(data)%һ��һ����
    for j=1:length(data{i})%һ��һ����
        if sign(i,j)==1;%�жϸö������Ƿ񱻱�ǹ���ÿ���ߵ�������ζ��ȥ����һ��pore���ˣ���ôҪ��number��1
            continue;
        end
        muber=1;%ÿ���ߵ�������ζ��ȥ����һ��pore���ˣ���ôҪ��number��1
        temp_store={};%ͬ�ϣ�storeҪ������
        temp_coor=data{i}{j};%temp����ÿһ�������
        temp_store=[temp_store,temp_coor];%�á�[]������˼�Ƿ���store������ֻҪ��ÿ������洢�����ˣ�����Ҫcell��
        sign(i,j)=1;
        search_flag=0;%��ʾ�ÿ�pore��������ϣ�����Ϊ��һ��pore����׼��
        for k=(i+1):length(data)%�Ե�ǰ��������Ϊ��׼�У�����һ�п�ʼ����
            for l=1:length(data{k})
                if sign(k,l)==1
                    continue;
                elseif data{k}{l}{1}(2)==temp_coor{1}(2) || data{k}{l}{1}(2)+1==temp_coor{1}(2) || data{k}{l}{1}(2)-1==temp_coor{1}(2)%���data�ĸö����������Ǹ����������temp������Ǹ����������Ӧ�ϵĻ���������һ��
                    search_flag=1;%��1��������һ�����һ�������ŵ�
                else search_flag=0;
                end
                %if�ҵ�����һ�����ҹ�ϵ�ģ�then��flag��1��tempһ��ʼ���ǻ�׼�㣩%%%%%ʵ�����������Ƕ�if
                if search_flag==1%�Ƿ����ţ�1��0��
                    temp_coor=data{k}{l};%1���Ļ����Ѵ������temp����Ϊ��һ�еĲ�������
                    temp_store=[temp_store,temp_coor];%����temp֮�󣬰�temp������ӵ�store����
                    sign(k,l)=1;%��tempλ�õ�sign�����
                    if k==length(data)
                        search_flag=0;
                    end
                    break;%������˵���ҵ������ŵģ������Ϳ���������һ���ˣ�����һ��Ѱ��
                end
            end
            if search_flag==0%�������û�б仯����ô˵�����ˣ����˵Ļ��Ͳ���ȥ��һ���ˣ�ֱ������һ��pore��%%%%%����һ���������ں���費Ϊ1��
                coor_x=0;
                coor_y=0;
                coor_number=length(temp_store);
                for m=1:coor_number
                    coor_x = coor_x + temp_store{m}(1);
                    coor_y = coor_y + temp_store{m}(2);
                end
                coor_x = coor_x / coor_number;
                coor_y = coor_y / coor_number;
                im_coordinate(round(coor_x),round(coor_y))=1;
                all_coor=[all_coor,[coor_x,coor_y]];
                %all_coor=%break֮ǰ��Ҫ�Ȱ�storeת�������õ���Ϣ������������all_coor����
                break;
            end
        end
    end
end
%sign=im_coordinate;
%for i=1:imx
%    for j=1:imy
%        if im_coordinate(i,j)==1 && sign(i,j)==1
%            im_coordinate(i+1,j-1)=1;
%            im_coordinate(i+1,j)=1;
%            im_coordinate(i+1,j+1)=1;
%            im_coordinate(i,j-1)=1;
            %im_coordinate(i,j+1)=1;
            %im_coordinate(i-1,j-1)=1;
            %im_coordinate(i-1,j)=1;
            %im_coordinate(i-1,j+1)=1;     
%        end
%    end
%end

im_coordinate = im2bw(im_coordinate,graythresh(im_coordinate));



