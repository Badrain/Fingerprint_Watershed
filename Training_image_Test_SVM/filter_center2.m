%%���ĵ�ϲ�
function final_center = filter_center2( input )
%input=center;
[m,n]=size(input);

[x,y]=find(input~=0);%�ҷ���Ԫ�ص�����
index=find(input~=0);%�ҷ���Ԫ�ص�����
[num,d]=size(index);
numCluster=0;
radius=10;
for i=1:num
    if(input(index(i))==1)
        [m_,n_]=ind2sub(size(input),index(i));%���ݾ���ĳߴ磬������ת��Ϊ�Ǳ�
        m_;
        n_;
        if(m_>radius&&m_<m-radius&&n_>radius&&n_<n-radius)
        for x=m_-radius:m_+radius
            for y=n_-radius:n_+radius
                if(input(x,y)==1)
                    input(x,y)=0;
                    input(m_,n_)=1;
                end
            end
        end
        end
    end
end
final_center=input;

%figure;imshow(input);title('dddd');





