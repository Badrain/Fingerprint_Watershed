% ��ת����ͳһģʽ
function mapping = myself_mapping(samples)
% clear
% clc
% samples=8;
model_bins=samples+2;% riu2ģʽ��Ŀ
%
for i=1:2^samples-1
    x=i;% ������ȡ������
    num_u=0;% 0/1�仯����ͳ�Ʊ���
   % ���Ӧ�Ķ�����
   for j=1:8
       binary_model_array(j)=mod(x,2);% ȡ��
       x=floor(x/2); % ����ȡ��
   end
   % Ѱ�ҷ���ͳһģʽ��ģʽ
   for k=1:samples-1
       num_variation=abs(binary_model_array(k)-binary_model_array(k+1));% ͳ��0/1�仯�Ĵ���
       if num_variation==1
          num_u=num_u+1;% ͳ��0/1�仯�Ĵ���
       end
   end
   if num_u<=2 % ͳ����ת������
      table(i+1)=sum(bitget(i,1:samples));% ��ͳһģʽ����ͳ�ƣ�ͳ������1�ĸ�����Ϊ��ת��������ģʽ
   else
      table(i+1)=samples+1; % ��ͳһ��ת����ģʽͳһ��һ�����
   end
end

mapping.table=table;%��ƥ���
mapping.samples=samples;% ������
mapping.num=model_bins;% ģʽ��Ŀ













