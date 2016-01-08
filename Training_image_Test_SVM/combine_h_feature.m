% This function is used to combine the histogram feature of the lbp code
% iamge
function combine_feature_vector=combine_h_feature(lbp_image)
k=4;% the blocks
mapping=myself_mapping(8);% getmapping
bins= mapping.num;% bins
feature_vector=zeros(1,bins*k*k);% the feature vector variant

% combination of the feature
vector_lable=0;
for i=1:k*k
    for j=1:bins
        vector_lable=vector_lable+1;
        feature_vector(vector_lable)=lbp_image{i}(j);
    end
end

combine_feature_vector=feature_vector;