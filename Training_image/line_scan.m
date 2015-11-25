function im_coordinate = line_scan(im,length_min,length_max)
%length_min和length_max用来设定line长度的最小值和最大值
%% 扫描图片，存储数据
%clc;
%clear;
%im = [0 0 1 1 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0;0 0 1 1 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0;0 0 1 1 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0];
[imx, imy] = size(im);
im_coordinate = zeros(imx,imy);
flag = 0;%flag为0不记录长度，flag为1记录长度
count_length = 0;%用于记录长度
temp_left = zeros(1,2);%用于记录每一段长度的左端点
temp_right = zeros(1,2);
data = {};%用于存储所有符合要求的坐标点
temp_data = {};%用于临时存储一对坐标
data_count = 0;
for i=1:imx
    for j=2:imy
        if im(i,j)==0 && im(i,j-1)==1%一段的开始
            flag = 1;
            count_length = 0;
            temp_left = [i,j-1];
        elseif im(i,j)==1 && im(i,j-1)==0 && flag==1%一段的结束
            flag = 0;
            temp_right = [i,j];
            if count_length<length_max && count_length>length_min%%%%%%%%%%%%%%%%%%%%%%%%%%%%%threshold
                temp_data = {temp_left,temp_right};
                data_count = data_count+1;
                data{i}{data_count}=temp_data;
            end
        elseif j==imy && flag==1 && im(i,j)==0%只有左边坐标没有右边坐标
            flag = 0;
        end
        if flag==1
            count_length = count_length + 1;
        end
    end
    data_count = 0;
end


%% 搜索数据，提取坐标
sign = zeros(imx,imy);%用于标记data中该位置是否已经统计过
temp_store={};%用于集中存储每一个pore点的全部涵盖点集
temp_coor={};
coor_x=0;
coor_y=0;
all_coor={};%用于存储所有pore点中心坐标
%class = {};
%class_number = 1;
for i=1:length(data)%一行一行来
    for j=1:length(data{i})%一对一对来
        if sign(i,j)==1;%判断该对坐标是否被标记过，每次走到这里意味着去找下一个pore点了，那么要把number置1
            continue;
        end
        muber=1;%每次走到这里意味着去找下一个pore点了，那么要把number置1
        temp_store={};%同上，store要清零了
        temp_coor=data{i}{j};%temp拿着每一对玩意儿
        temp_store=[temp_store,temp_coor];%用‘[]’的意思是放在store里面我只要以每个坐标存储就行了，不需要cell了
        sign(i,j)=1;
        search_flag=0;%表示该块pore点搜索完毕，并且为下一个pore点做准备
        for k=(i+1):length(data)%以当前点所在行为基准行，从下一行开始检索
            for l=1:length(data{k})
                if sign(k,l)==1
                    continue;
                elseif data{k}{l}{1}(2)==temp_coor{1}(2) || data{k}{l}{1}(2)+1==temp_coor{1}(2) || data{k}{l}{1}(2)-1==temp_coor{1}(2)%如果data的该对坐标的左边那个的纵坐标和temp的左边那个的纵坐标对应上的话，进入下一步
                    search_flag=1;%置1，代表这一层和上一层是连着的
                else search_flag=0;
                end
                %if找到和上一行左右关系的，then把flag置1（temp一开始就是基准点）%%%%%实现啦，上面那段if
                if search_flag==1%是否连着？1连0断
                    temp_coor=data{k}{l};%1连的话，把此坐标给temp，作为下一行的参照坐标
                    temp_store=[temp_store,temp_coor];%给完temp之后，把temp的坐标加到store里面
                    sign(k,l)=1;%把temp位置的sign给变号
                    if k==length(data)
                        search_flag=0;
                    end
                    break;%到这里说明找到了连着的，这样就可以跳出这一行了，到下一行寻找
                end
            end
            if search_flag==0%如果符号没有变化，那么说明断了，断了的话就不用去下一行了，直接找下一个pore点%%%%%（有一个隐患，壁厚假设不为1）
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
                %all_coor=%break之前，要先把store转换成有用的信息存起来，放在all_coor里面
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



