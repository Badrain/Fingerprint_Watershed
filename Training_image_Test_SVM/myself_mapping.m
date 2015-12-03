% 旋转不变统一模式
function mapping = myself_mapping(samples)
% clear
% clc
% samples=8;
model_bins=samples+2;% riu2模式数目
%
for i=1:2^samples-1
    x=i;% 用于求取二进制
    num_u=0;% 0/1变化次数统计变量
   % 求对应的二进制
   for j=1:8
       binary_model_array(j)=mod(x,2);% 取余
       x=floor(x/2); % 向下取商
   end
   % 寻找符合统一模式的模式
   for k=1:samples-1
       num_variation=abs(binary_model_array(k)-binary_model_array(k+1));% 统计0/1变化的次数
       if num_variation==1
          num_u=num_u+1;% 统计0/1变化的次数
       end
   end
   if num_u<=2 % 统计旋转不变量
      table(i+1)=sum(bitget(i,1:samples));% 对统一模式进行统计，统计其中1的个数即为旋转不变量的模式
   else
      table(i+1)=samples+1; % 非统一旋转不变模式统一用一个编号
   end
end

mapping.table=table;%　匹配表
mapping.samples=samples;% 采样点
mapping.num=model_bins;% 模式数目













