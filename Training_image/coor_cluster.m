function [new_coor,coor_image] = coor_cluster(coor,threshold)
%该函数用来将坐标点进行聚类,threshold用来设定聚类的雨里阈值

X=[];%用来存储所有坐标点
count=1;
[imx,imy]=size(coor);
for i=1:imx %将坐标存储到X里面
    for j=1:imy
        if coor(i,j)==1
            X(count,1)=i;
            X(count,2)=j;
            count=count+1;
        end
    end
end
Y=pdist(X);
Z=linkage(Y);
[Z_x,~]=size(Z);
for i=1:Z_x
    if Z(i,3)>threshold
        number=Z_x-i+1;
        T=cluster(Z,number);
        break;
    end
end
new_coor_temp=zeros(number,3);%第一列是x，第二列是y，第三列是个数
for i=1:(Z_x+1)
    new_coor_temp(T(i),1)=new_coor_temp(T(i),1)+X(i,1);%进行x叠加
    new_coor_temp(T(i),2)=new_coor_temp(T(i),2)+X(i,2);%进行y叠加
    new_coor_temp(T(i),3)=new_coor_temp(T(i),3)+1;%个数相加
end
new_coor=zeros(number,2);
for i=1:number
    new_coor(i,1)=round(new_coor_temp(i,1)/new_coor_temp(i,3));
    new_coor(i,2)=round(new_coor_temp(i,2)/new_coor_temp(i,3));
end
coor_image=zeros(imx,imy);
for i=1:number
    coor_image(new_coor(i,1),new_coor(i,2))=1;
end
coor_image=im2bw(coor_image,graythresh(coor_image));