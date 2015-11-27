%function final_center = filter_center( input )

input=center;
[m,n]=size(input);
threhold=10;
[x,y]=find(input~=0);%找非零元素的坐标
index=find(input~=0);%找非零元素的索引
copyIndex=index;
[num,d]=size(index);
distance=zeros(num,num);
nearest=zeros(num,1);
for i=1:num
    for j=1:num
        if(i==j)
            distance(i,j)=1000;
        else
        distance(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);  
        end
    end
    
end
delete=[];
for i=1:num
    nearest(i) = find(distance(i,:) == min(distance(i,:))); % 最小值的位置
    distance(i, nearest(i))
    if(distance(i, nearest(i))<threhold)
        delete(i)=index(i);
        index(i)=0;
    end    
end
delete(delete==0)=[];%去掉向量中的零元素，形成新的向量


index(index==0)=[];%去掉向量中的零元素，形成新的向量
I=zeros(m,n);
I(index)=255;
figure;imshow(I);title('center after filter');
    final_center=distance;



